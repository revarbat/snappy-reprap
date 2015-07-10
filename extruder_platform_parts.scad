include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 1;
$fs = 1.5;

module extruder_platform()
{
	platform_vert_off = rail_height+groove_height+rail_offset;
	l = extruder_length;
	w = rail_width;
	h = rail_height;
	thick = extruder_thick;

	color("LightSteelBlue")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Bottom.
				up(thick/2)
					cube(size=[w, l, thick], center=true);

				// Walls.
				xspread(rail_spacing+joiner_width) {
					up(h/6) {
						cube(size=[joiner_width, l/2-5, h/3], center=true);
					}
				}

				// Wall Triangles
				zring(n=2) {
					xflip_copy() {
						up(h/2) {
							fwd(l/2-l/6-10+0.05) {
								right((rail_spacing+joiner_width)/2) {
									thinning_brace(h=h, l=l/3, thick=joiner_width, strut=5);
								}
							}
						}
					}
				}

				// side support walls
				yspread(l-2*10+4) {
					up(h/2/2) {
						difference() {
							cube([w, 4, h/2], center=true);
							xspread(w/3, n=3) {
								down(2) cube([16, 11, 11], center=true);
							}
						}
					}
				}
			}

			// Extruder mount holes.
			xspread(15, n=3) {
				yspread(50) {
					cylinder(r=4.5/2, h=20, center=true);
				}
			}

			// Extruder hole.
			rrect(r=10, size=[75, 40, 20], center=true);

			// Clear space for joiners.
			up(rail_height/2+0.005) {
				joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=l+0.001, h=h, w=joiner_width, clearance=5, a=joiner_angle);
			}

			// Shrinkage stress relief
			up(thick/2) {
				yspread(20, n=6) {
					cube(size=[w+1, 1, thick-2], center=true);
				}
				xspread(16, n=6) {
					cube(size=[1, l+1, thick-2], center=true);
				}
			}

			// Wiring acess holes.
			xspread(w-35-joiner_width*2) {
				yspread(80) {
					cylinder(h=20, r=w/8, center=true);
				}
			}

		}

		// Fan shroud mounts
		zring(n=2, r=(w+10)/2-0.05) {
			up(10/2) {
				difference() {
					difference() {
						cube(size=[fan_mount_width, fan_mount_length, fan_mount_width], center=true);
						up(fan_mount_width/2) {
							right(fan_mount_width/2) {
								yrot(45) {
									cube(size=[2*sqrt(2), fan_mount_length+1, 2*sqrt(2)], center=true);
								}
							}
						}
					}
					xrot(90) cylinder(h=fan_mount_length+1, r=fan_mount_screw*1.1/2, center=true, $fn=12);
					yspread(fan_mount_length-2*4) {
						hull() {
							grid_of(za=[0,5]) {
								xrot(90) zrot(90) {
									metric_nut(size=set_screw_size, hole=false, center=true);
								}
							}
						}
					}
				}
			}
		}

		// Snap-tab joiners.
		up(rail_height/2) {
			joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=l-0.05, h=h, w=joiner_width, l=10, a=joiner_angle);
		}
	}
}
//!extruder_platform();



module extruder_platform_parts() { // make me
	zrot(90) extruder_platform();
}



extruder_platform_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

