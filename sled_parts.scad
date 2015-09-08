include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <publicDomainGearV1.1.scad>


slop = 0.1;


$fa = 2;
$fs = 2;

module herringbone_rack(l=100, h=10, w=10, tooth_size=5, CA=30)
{
	left(tooth_size/2) {
		zflip_copy() {
			skew_xy(xang=CA) {
				intersection() {
					up(h/4-0.01) {
						left(l/2-tooth_size/2) {
							rack(
								mm_per_tooth=tooth_size,
								number_of_teeth=floor(l/tooth_size),
								thickness=h/2+0.005,
								height=w,
								pressure_angle=20,
								backlash=0
							);
						}
					}
					cube(size=[l, h*3, h*3], center=true);
				}
			}
		}
	}
}
//!herringbone_rack(l=100, h=10, tooth_size=5, CA=30);



module slider_segment(l=30, base=10, slop=0.1)
{
	w = joiner_width + 2*5;
	h = base + groove_height;
	wall = 5;
	difference() {
		up(h/2) cube([joiner_width+2*wall, l, h], center=true);
		up(base-printer_slop) {
			up((groove_height+5)/2) {
				cube([joiner_width+slop, l+1, groove_height+5], center=true);
			}
			yspread(l) {
				scale([1, 1, tan(30)]) {
					xrot(45) cube([joiner_width+slop, 2*sqrt(2), 2*sqrt(2)], center=true);
				}
			}
		}
		up(h) {
			xspread(w) {
				yrot(45) {
					cube([wall/2*sqrt(2), l+1, wall/2*sqrt(2)], center=true);
				}
			}
		}
	}
	up(base) {
		up(groove_height/2) {
			xflip_copy() {
				left((joiner_width+slop)/2) {
					difference() {
						scale([tan(groove_angle), 1, 1]) {
							yrot(45) cube([groove_height*sin(45), l, groove_height*sin(45)], center=true);
						}
						yflip_copy() {
							right(sqrt(2)*groove_height/2) {
								fwd(l/2) {
									zrot(45) cube(groove_height, center=true);
								}
							}
						}
					}
				}
			}
		}
	}
}



module sled()
{
	slider_len = 20;
	slider_count = 2;
	slider_spacing = (platform_length-slider_len-15)/(slider_count-1);

	color("MediumSlateBlue")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Bottom
				up(platform_thick/2)
					yrot(90) sparse_strut(h=platform_width, l=platform_length, thick=platform_thick, maxang=45, strut=12, max_bridge=999);

				// Walls.
				zrot_copies([0, 180]) {
					translate([(platform_width-joiner_width)/2, 0, platform_height/2]) {
						chamfer(chamfer=3, size=[joiner_width, platform_length, platform_height], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
							if (wall_style == "crossbeams")
								sparse_strut(h=platform_height, l=platform_length-10, thick=joiner_width, strut=5);
							if (wall_style == "thinwall")
								thinning_wall(h=platform_height, l=platform_length-10, thick=joiner_width, strut=platform_thick, wall=3, bracing=false);
							if (wall_style == "corrugated")
								corrugated_wall(h=platform_height, l=platform_length-10, thick=joiner_width, strut=platform_thick, wall=3);
						}
					}
				}

				// Drive rack
				rack_module = rack_tooth_size / 3.1415926535;
				rack_pcd = gear_teeth * rack_module;
				left(rack_pcd/2+printer_slop) {
					up(platform_thick+rack_base+rack_height/2) {
						difference() {
							zrot(-90) herringbone_rack(l=platform_length, h=rack_height+0.1, w=10, tooth_size=rack_tooth_size, CA=30);
							up(rack_height/2) {
								left(rack_tooth_size/2) {
									yrot(15) up(2) {
										cube(size=[rack_tooth_size*2, platform_length+10, 4], center=true);
									}
								}
							}
						}
					}

					// rack base
					addendum = rack_module;
					up(platform_thick/2+rack_base/2) {
						left(10/2-addendum) {
							cube(size=[10,platform_length,platform_thick+rack_base], center=true);
						}
					}
				}

				// sliders
				xspread(rail_spacing+joiner_width) {
					yspread(slider_spacing, n=slider_count) {
						slider_segment(l=slider_len, base=rail_offset, slop=slop);
					}
				}
			}

			// Clear space for joiners.
			translate([0,0,platform_height/2]) {
				joiner_quad_clear(xspacing=platform_width-joiner_width, yspacing=platform_length-0.1, h=platform_height, w=joiner_width, clearance=5, a=joiner_angle);
			}

			// Shrinkage stress relief
			up(platform_thick/2) {
				yspread(18, n=5) {
					cube(size=[platform_width+1, 1, platform_thick-2], center=true);
				}
				xspread(20, n=7) {
					yspread(platform_length-10) {
						cube(size=[1, 20, platform_thick-2], center=true);
					}
				}
			}
		}

		// Snap-tab joiners.
		up(platform_height/2) {
			difference() {
				joiner_quad(xspacing=platform_width-joiner_width, yspacing=platform_length, h=platform_height, w=joiner_width, l=6, a=joiner_angle);
				up(platform_height/2) {
					xspread(platform_width-joiner_width) {
						xspread(joiner_width) {
							xrot(90) chamfer_mask(r=3, h=platform_length+10);
						}
					}
				}
			}
		}
	}
}
//!sled();



module sled_parts() { // make me
	zrot(-90) sled();
}


sled_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
