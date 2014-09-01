include <config.scad>
use <GDMUtils.scad>
use <publicDomainGearV1.1.scad>
use <joiners.scad>
use <roller_parts.scad>
use <cap_parts.scad>



module herringbone_rack(l=100, h=10, w=10, tooth_size=5, CA=30)
{
	render(convexity=10) translate([-(rack_tooth_size/2), 0, 0]) {
		mirror_copy([0,0,1]) {
			skew_along_z(xang=CA) {
				intersection() {
					translate([-(l/2-rack_tooth_size/2), 0, h/4]) {
						rack(
							mm_per_tooth=rack_tooth_size,
							number_of_teeth=floor(l/rack_tooth_size),
							thickness=h/2,
							height=w,
							pressure_angle=20,
							backlash=0
						);
					}
					cube(size=[l, h*3, h*3], center=true);
				} 
			}
		}
	}
}
//!herringbone_rack(l=100, h=10, tooth_size=5, CA=30);



module slider_sled(show_rollers=false, with_rack=false, nut_size=undef, nut_thick=undef)
{
	platform_length=with_rack? ceil(platform_length/rack_tooth_size)*rack_tooth_size : platform_length; // quantize to rack tooth size, if needed.
	axle_rad = (roller_axle/2) - 0.5;
	axle_len = roller_thick;

	union() {
		difference() {
			// Bottom strut.
			translate([0,0,platform_thick/2])
				yrot(90) sparse_strut(h=platform_width, l=platform_length, thick=platform_thick, maxang=45, strut=12, max_bridge=999);

			// Remove bits from platform so snap tabs have freedom.
			zrot_copies([0,180]) {
				grid_of(
					xa=[-(platform_width-joiner_width/2-5)/2, (platform_width-joiner_width/2-5)/2],
					ya=[platform_length/2]
				) {
					xrot(joiner_angle) translate([-(joiner_width+10)/2,0,-1])
						cube(size=[joiner_width+10,platform_thick,platform_thick*3], center=false);
				}
			}
		}

		translate([0,0,platform_height/2]) {
			// Snap-tab joiners.
			zrot_copies([0,180]) {
				yrot_copies([0,180]) {
					translate([platform_width/2-joiner_width/2, platform_length/2, 0]) {
						joiner(h=platform_height, w=joiner_width, l=10, a=joiner_angle);
					}
				}
			}

			// Solid walls.
			grid_of(xa=[-(platform_width-joiner_width)/2, (platform_width-joiner_width)/2]) {
				thinning_wall(h=platform_height, l=platform_length-18, thick=joiner_width, strut=platform_thick, wall=3, bracing=false);
			}
		}

		grid_of(xa=[-roller_spacing/2,roller_spacing/2]) {
			grid_of(ya=[-(platform_length/2)/2, (platform_length/2)/2]) {
				// Roller pedestals
				translate([0,0,roller_base/2]) {
					cylinder(h=roller_base, r=axle_rad+1.5, center=true, $fn=32);
				}

				// Roller axles
				translate([0,0,axle_len/2+roller_base]) {
					tube(h=axle_len+0.05, r=axle_rad, wall=2.5, center=true, $fn=32);
					if (show_rollers) {
						roller();
						translate([0,0,axle_len/2]) xrot(180)
							cap(r=roller_axle/2-3, h=10, lip=2, wall=3);
					}
				}
			}
		}

		translate([0,0,platform_thick/2]) {
			// Length-wise bracing.
			if (with_rack == true) {
				translate([-10, 0, 1])
					cube(size=[14,platform_length,platform_thick+2], center=true);
			} else {
				cube(size=[14,platform_length,platform_thick], center=true);
			}
		}

		// Drive rack
		if (with_rack == true) {
			translate([-8, 0, platform_thick+2+5]) {
				zrot(-90) herringbone_rack(l=platform_length, h=10, tooth_size=rack_tooth_size, CA=30);
			}
		}

		// Drive nut.
		if (nut_size != undef) {
			grid_of(ya=[-roller_spacing/2, roller_spacing/2]) {
				difference() {
					translate([0, 0, (nut_size+roller_base)/2])
						cube(size=[nut_size+10, nut_thick+10, nut_size+roller_base], center=true);
					translate([0, 0, roller_base+roller_thick/2]) {
						hull() {
							grid_of(za=[0, 20]) {
								scale([1.05, 1.05, 1.00]) zrot(90) yrot(90)
									cylinder(h=nut_thick, r=(nut_size/2)/cos(30), center=true, $fn=6);
							}
						}
					}
					translate([0, 0, roller_base+roller_thick/2]) {
						hull() {
							grid_of(za=[0, 20]) {
								scale([0.65, 3, 0.65]) zrot(90) yrot(90)
									cylinder(h=nut_thick, r=nut_size/2, center=true, $fn=24);
							}
						}
					}
				}
			}
		}
	}
}



slider_sled(show_rollers=true, nut_size=17.5, nut_thick=9.2);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

