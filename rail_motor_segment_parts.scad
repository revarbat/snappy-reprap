include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <NEMA.scad>


// connectby valid options: "", "fwd", "back"
module rail_motor_segment(explode=0, connectby="")
{
	joiner_length = 10;
	side_joiner_len = 10;
	fillet = 1.5;
	motor_width = nema_motor_width(17);

	up(
		(connectby=="fwd")? -rail_height/2 :
		(connectby=="back")? -rail_height/2 :
		0
	) back(
		(connectby=="back")? -motor_rail_length/2 :
		(connectby=="fwd")? motor_rail_length/2 :
		0
	) {
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
								up((motor_top_z-motor_length+6-rail_thick)/2) {
									cube(size=[motor_mount_spacing+joiner_width, 30+20, motor_top_z-motor_length+6], center=true);
								}
							}
							cube(size=[motor_mount_spacing-joiner_width, 20, motor_length], center=true);

							// Clearance for NEMA17 stepper motor
							up(motor_top_z-rail_thick/2) {
								down(motor_length/2) {
									cube(size=[motor_width, motor_width, motor_length], center=true);
									cube(size=[20, motor_rail_length/2+10, motor_length], center=true);
								}
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
						up(rail_height+groove_height/2-fillet)
							rcube(size=[joiner_width, motor_rail_length, groove_height+fillet], r=fillet, center=true, $fn=18);

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

									// fillets
									facelen = groove_height/2/sin(90-groove_angle);
									yflip_copy() {
										fwd(motor_rail_length/2) {
											left(facelen*sin(groove_angle)) {
												difference() {
													zflip_copy() {
														left(fillet) {
															yrot(-groove_angle) {
																right(fillet) {
																	down(facelen*1.5/2) {
																		cube([fillet*2, fillet*2, facelen*1.5], center=true);
																	}
																}
															}
														}
													}
													zflip_copy() {
														left(fillet) {
															yrot(-groove_angle) {
																right(fillet) {
																	down(facelen) {
																		back(fillet) left(fillet) {
																			cylinder(r=fillet, h=facelen*3, center=true, $fn=12);
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

				// Side wiring access hole
				up(10/2+rail_thick) {
					xspread(rail_width-joiner_width) {
						yspread(motor_rail_length-2*30) {
							cube(size=[joiner_width+1, 16, 10], center=true);
						}
					}
				}
			}

			// Snap-tab joiners.
			up(rail_height/2) {
				joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, l=13, a=joiner_angle);
			}
		}
		up(motor_top_z-motor_length/2+explode) {
			if ($children > 0) children(0);
		}
		up(rail_height/2) {
			fwd(motor_rail_length/2+explode) {
				if ($children > 1) children(1);
			}
			back(motor_rail_length/2+explode) {
				if ($children > 2) children(2);
			}
		}
	}
}
//!rail_motor_segment();



module rail_motor_segment_parts() { // make me
	zrot(90) rail_motor_segment();
}


rail_motor_segment_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
