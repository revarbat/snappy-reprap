include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module bridge_center()
{
	joiner_length = 10;
	side_joiner_len = 10;

	color("SpringGreen")
	prerender(convexity=20)
	union() {
		difference() {
			union() {
				// Bottom.
				up(rail_thick/2) {
					yrot(90) sparse_strut(h=rail_width, l=motor_rail_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
				}

				// Walls.
				zring(r=0,n=2) {
					up(rail_height/2) {
						right((rail_spacing+joiner_width)/2) {
							if (wall_style == "crossbeams")
								sparse_strut(h=rail_height, l=motor_rail_length-joiner_length, thick=joiner_width, strut=5);
							if (wall_style == "thinwall")
								thinning_wall(h=rail_height, l=motor_rail_length-joiner_length, thick=joiner_width, strut=5, bracing=false);
							if (wall_style == "corrugated")
								corrugated_wall(h=rail_height, l=motor_rail_length-joiner_length, thick=joiner_width, strut=5);
						}
					}
				}

				// Side Supports
				up(rail_height/4) {
					yspread(motor_rail_length-20) {
						difference() {
							cube(size=[rail_width, 4, rail_height/2], center=true);
							xspread(rail_width/3, n=3) {
								cube(size=[16, 11, 11], center=true);
							}
						}
					}
				}
			}

			// Clear space for joiners.
			up(rail_height/2) {
				joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, clearance=5, a=joiner_angle);
			}

			// Shrinkage stress relief
			up(rail_thick/2) {
				yspread(16, n=5) {
					cube(size=[rail_width+1, 1, rail_thick-2], center=true);
				}
				xspread(15, n=7) {
					yspread(motor_rail_length-10) {
						cube(size=[1, 60, rail_thick-2], center=true);
					}
				}
			}
		}

		// Snap-tab joiners.
		up(rail_height/2) {
			joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, l=13, a=joiner_angle);
		}
	}
}
//!bridge_center();



module bridge_center_parts() { // make me
	zrot(90) bridge_center();
}


bridge_center_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

