include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module z_strut()
{
	color([0.9, 0.7, 1.0])
	prerender(convexity=20)
	union() {
		difference() {
			union() {
				// Bottom.
				up(rail_thick/2) yrot(90)
					sparse_strut(h=rail_width, l=motor_rail_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);

				// Walls.
				zrot_copies([0, 180]) {
					up(rail_height/2) {
						right((rail_spacing+joiner_width)/2) {
							if (wall_style == "crossbeams")
								sparse_strut(h=rail_height, l=motor_rail_length-10, thick=joiner_width, strut=5);
							if (wall_style == "thinwall")
								thinning_wall(h=rail_height, l=motor_rail_length-10, thick=joiner_width, strut=5, bracing=false);
							if (wall_style == "corrugated")
								corrugated_wall(h=rail_height, l=motor_rail_length-10, thick=joiner_width, strut=5);
						}
					}
				}

				// Side Supports
				up(rail_height/4) {
					yspread(motor_rail_length-2*5-5) {
						difference() {
							cube(size=[rail_width-joiner_width, 4, rail_height/2], center=true);
							xspread(rail_width/3, n=3) {
								cube(size=[16, 11, 12], center=true);
							}
						}
					}
				}
			}

			// Clear space for joiners.
			up(rail_height/2) {
				joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length+0.05, h=rail_height+0.001, w=joiner_width, clearance=5, a=joiner_angle);
			}

			// Shrinkage stress relief
			up(rail_thick/2) {
				yspread(20, n=4) {
					#cube(size=[rail_width+1, 1, rail_thick-2], center=true);
				}
				xspread(18, n=6) {
					yspread(motor_rail_length-10) {
						#cube(size=[1, 30, rail_thick-2], center=true);
					}
				}
			}
		}

		// Snap-tab joiners.
		up(rail_height/2) {
			joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, l=5, a=joiner_angle);
		}
	}
}
//!z_strut();



module z_strut_parts() { // make me
	zrot(90) z_strut();
}



z_strut_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

