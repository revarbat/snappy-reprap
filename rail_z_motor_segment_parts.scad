include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rail_z_motor_segment()
{
	joiner_length = 10;
	side_joiner_len = 10;

	xlen = motor_rail_length/2-25;
	ylen = (rail_width-motor_mount_spacing)/2;
	hlen = sqrt(xlen*xlen+ylen*ylen);
	ang = atan2(ylen,hlen);

	color("SpringGreen")
	prerender(convexity=20)
	union() {
		difference() {
			union() {
				// Bottom.
				up(rail_thick/2) {
					union() {
						yrot(90) sparse_strut(h=rail_width, l=motor_rail_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
						xspread(motor_mount_spacing) {
							cube(size=[joiner_width, motor_rail_length, rail_thick], center=true);
						}
					}
				}

				// Walls.
				zring(r=0, n=2) {
					up((rail_height+3)/2) {
						right((rail_spacing+joiner_width)/2) {
							if (wall_style == "crossbeams")
								sparse_strut(h=rail_height+3, l=motor_rail_length-joiner_length, thick=joiner_width, strut=5);
							if (wall_style == "thinwall")
								thinning_wall(h=rail_height+3, l=motor_rail_length-joiner_length, thick=joiner_width, strut=5, bracing=false);
							if (wall_style == "corrugated")
								corrugated_wall(h=rail_height+3, l=motor_rail_length-joiner_length, thick=joiner_width, strut=5);
						}
					}
				}

				// Rail backing.
				xspread(rail_spacing+joiner_width)
					up(rail_height+groove_height/2)
						chamfer(size=[joiner_width, motor_rail_length, groove_height], chamfer=1, edges=[[1,1,0,0], [1,1,0,0], [0,0,0,0]])
							cube(size=[joiner_width, motor_rail_length, groove_height], center=true);

				// Top side support
				up((rail_height-15)/2) {
					yspread(motor_rail_length-18) {
						zrot(90) sparse_strut(h=rail_height-15, l=rail_width, thick=5, strut=5);
						down((rail_height-15-rail_thick)/2) {
							cube(size=[rail_width, 5, rail_thick], center=true);
						}
					}
				}

				// Motor mount joiners.
				up(rail_height+groove_height/2) {
					joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=15, a=joiner_angle);
				}
				xspread(motor_mount_spacing) {
					up(rail_height/4+groove_height/4) {
						fwd(15/2) {
							cube(size=[joiner_width, 15, rail_height/2+groove_height/2], center=true);
						}
					}
				}

				// Motor mount supports.
				xflip_copy() {
					up((rail_height+groove_height)/2) {
						fwd(motor_rail_length/4) {
							right((rail_width+motor_mount_spacing)/4-2) {
								zrot(ang) {
									sparse_strut(h=rail_height+groove_height, l=hlen, thick=7.5, strut=5);
									down((rail_height+groove_height-rail_thick)/2) {
										cube(size=[7.5, hlen, rail_thick], center=true);
									}
								}
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
			joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length+0.05, h=rail_height, w=joiner_width, l=13, a=joiner_angle);
		}

		// Side mount joiners.
		up(rail_height/2/2) {
			back(side_mount_spacing/2) {
				xflip_copy() {
					right(rail_width/2+side_joiner_len) {
						zrot(-90) {
							half_joiner(h=rail_height/2, w=joiner_width, l=side_joiner_len+joiner_width/2, a=joiner_angle);
						}
					}
				}
			}
		}
	}
}
//!rail_z_motor_segment();



module rail_z_motor_segment_parts() { // make me
	zrot(90) rail_z_motor_segment();
}


rail_z_motor_segment_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
