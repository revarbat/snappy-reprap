include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <NEMA.scad>


module rail_xy_motor_segment()
{
	joiner_length = 10;
	side_joiner_len = 10;
	motor_width = nema_motor_width(17)+printer_slop*2;

	color("SpringGreen")
	prerender(convexity=20)
	union() {
		difference() {
			union() {
				// Bottom.
				up(rail_thick/2) {
					difference() {
						union() {
							yrot(90)
								sparse_strut(h=rail_width, l=motor_rail_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
							up((motor_top_z-motor_length+4-rail_thick)/2) {
								cube(size=[motor_mount_spacing+joiner_width, 30+20, motor_top_z-motor_length+4], center=true);
							}
						}
						cube(size=[motor_mount_spacing-joiner_width, 30, motor_length], center=true);

						// Clearance for NEMA17 stepper motor
						up(motor_top_z-rail_thick/2) {
							down(motor_length/2) cube(size=[motor_width, motor_width, motor_length], center=true);
						}
					}
				}

				// Walls.
				zring(r=0,n=2) {
					up((rail_height+3)/2) {
						right((rail_spacing+joiner_width)/2) {
							if (wall_style == "crossbeams")
								sparse_strut(h=rail_height+3, l=motor_rail_length-2*joiner_length, thick=joiner_width, strut=5);
							if (wall_style == "thinwall")
								thinning_wall(h=rail_height+3, l=motor_rail_length-2*joiner_length, thick=joiner_width, strut=5, bracing=false);
							if (wall_style == "corrugated")
								corrugated_wall(h=rail_height+3, l=motor_rail_length-2*joiner_length, thick=joiner_width, strut=5);
						}
					}
				}

				// Rail backing.
				xspread(rail_spacing+joiner_width)
					up(rail_height+groove_height/2)
						chamfer(size=[joiner_width, motor_rail_length, groove_height], chamfer=1, edges=[[1,1,0,0], [1,1,0,0], [0,0,0,0]])
							cube(size=[joiner_width, motor_rail_length, groove_height], center=true);

				// Side Supports
				up(rail_height/4) {
					yspread(motor_rail_length-20) {
						cube(size=[rail_width, 5, rail_height/2], center=true);
					}
				}

				// Motor mount joiners.
				up(motor_top_z-motor_length/2) {
					xrot(90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=motor_top_z-motor_length/2, a=joiner_angle);
				}
			}

			// Rail grooves.
			up(rail_height+groove_height/2) {
				xflip_copy() {
					left((rail_width-joiner_width)/2) {
						xflip_copy() {
							right(joiner_width/2) {
								// main groove
								scale([tan(groove_angle),1,1]) yrot(45) {
									cube(size=[groove_height*sqrt(2)/2,motor_rail_length+1,groove_height*sqrt(2)/2], center=true);
								}

								// chamfers
								mirror_copy([0,1,0]) {
									back(motor_rail_length/2) {
										hull() {
											yspread(2) {
												zrot(45) scale([tan(groove_angle)*sin(45),1,1]) yrot(45) {
													cube(size=[groove_height*sqrt(2)/2,10,groove_height*sqrt(2)/2], center=true);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}

			// Wiring access holes.
			up(rail_height/4) {
				xspread(rail_width/3, n=3) {
					yspread(motor_rail_length-20) {
						cube(size=[16, 11, 11], center=true);
					}
				}
			}

			// access for stepper wires.
			up(15/2) {
				cube(size=[motor_mount_spacing+joiner_width+1, 20, 15+0.05], center=true);
			}

			// Clear space for joiners.
			up(rail_height/2) {
				joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, clearance=5, a=joiner_angle);
			}

			// Clear space for side mount joiners.
			zring(r=0,n=2) {
				right(rail_width/2-5) {
					up(rail_height/2/2) {
						right(side_joiner_len+joiner_width/2) {
							left(platform_length/4) {
								zrot(-90) half_joiner_clear(h=rail_height/2, w=joiner_width, l=side_joiner_len, a=joiner_angle);
							}
							right(platform_length/4) {
								zrot(-90) half_joiner_clear(h=rail_height/2, w=joiner_width, l=side_joiner_len, a=joiner_angle, slop=printer_slop);
							}
						}
					}
				}
			}

			// Side wiring access hole
			up(10/2+rail_thick) {
				xspread(rail_width-joiner_width) {
					cube(size=[joiner_width+1, 16, 10], center=true);
				}
			}
		}

		// Snap-tab joiners.
		up(rail_height/2) {
			joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, l=13, a=joiner_angle);
		}

		// Side mount joiners.
		zring(n=2) {
			right(rail_width/2-5) {
				up(rail_height/2/2) {
					right(side_joiner_len+joiner_width/2) {
						fwd(side_mount_spacing/2) {
							zrot(-90) {
								chamfer(chamfer=joiner_width/3, size=[joiner_width, side_joiner_len*4, rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
									half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len+joiner_width/2, a=joiner_angle);
								}
							}
						}
						back(side_mount_spacing/2) {
							zrot(-90) {
								chamfer(chamfer=joiner_width/3, size=[joiner_width, side_joiner_len*4, rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
									half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len+joiner_width/2, a=joiner_angle, slop=printer_slop);
								}
							}
						}
					}
				}
			}
		}
	}
}
//!rail_xy_motor_segment();



module rail_xy_motor_segment_parts() { // make me
	zrot(90) rail_xy_motor_segment();
}


rail_xy_motor_segment_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
