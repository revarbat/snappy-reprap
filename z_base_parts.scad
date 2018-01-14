include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>

$fa=2;
$fs=2;

// connectby valid options: "", "fwd", "back"
module z_base(explode=0, connectby="")
{
	coupler_len = lifter_coupler_len;
	side_joiner_len = 5;
	wall_thick = 3;
	l = z_base_height;
	wall_dx = rail_spacing - (z_joiner_spacing-joiner_width);
	wall_ang = atan2(wall_dx/2, l-coupler_len);
	side_off = sin(wall_ang)*(motor_length+wall_thick);
	cross_dx = rail_spacing/2 + (z_joiner_spacing-joiner_width)/2 + joiner_width;
	cross_ang = atan2(cross_dx, l - coupler_len - 2*rail_thick);
	cross_l = hypot(cross_dx, l - coupler_len - 2*rail_thick);
	motor_width = nema_motor_width(17);
	plinth_diam = nema_motor_plinth_diam(17);

	up(
		(connectby=="fwd")? -rail_height/2 :
		(connectby=="back")? -rail_height/2 :
		0
	) back(
		(connectby=="back")? -l/2 :
		(connectby=="fwd")? l/2 :
		0
	) {
		color([0.9, 0.7, 1.0])
		prerender(convexity=20)
		union() {
			difference() {
				union() {
					// Bottom.
					up(rail_thick/2) {
						fwd((l-2*rail_thick)/2-0.5) {
							cube(size=[rail_spacing+joiner_width, 2*rail_thick, rail_thick], center=true);
						}
						back((l-2*rail_thick)/2-0.5) {
							cube(size=[z_joiner_spacing, 2*rail_thick, rail_thick], center=true);
						}
						intersection() {
							xflip_copy() {
								right((rail_spacing+joiner_width)/2) {
									fwd(l/2-3) {
										zrot(cross_ang) {
											back(cross_l/2) {
												cube(size=[2*rail_thick, cross_l, rail_thick], center=true);
											}
										}
									}
								}
							}
							cube(size=[2*rail_spacing, l-1, rail_thick+1], center=true);
						}
					}

					// Walls.
					xflip_copy() {
						up(rail_height/2+groove_height/2) {
							fwd(l/2) {
								skew_xz(xang=wall_ang) {
									back((l-coupler_len)/2) {
										left((rail_spacing+joiner_width)/2) {
											difference() {
												union() {
													// Wall
													if (wall_style == "crossbeams")
														sparse_strut(h=rail_height+groove_height, l=l-coupler_len-0.1, thick=joiner_width, strut=7);
													if (wall_style == "thinwall")
														thinning_wall(h=rail_height+groove_height, l=l-coupler_len-0.1, thick=joiner_width, strut=7);
													if (wall_style == "corrugated")
														corrugated_wall(h=rail_height+groove_height, l=l-coupler_len-0.1, thick=joiner_width, strut=7);

													// Side wiring access hole frame
													if (wall_style == "corrugated") {
														down((rail_height+groove_height)/2) {
															up(15/2+rail_thick) {
																cube(size=[joiner_width, 16+4, 10+4], center=true);
															}
														}
													}

													// Triangle to increase stability
													up(rail_height/2+groove_height/2-0.05) {
														fwd((l-coupler_len)/2) {
															right(joiner_width/2) {
																zrot(90) right_triangle([rail_height/2, joiner_width, groove_height]);
															}
														}
													}
												}

												// Side wiring access hole
												if (wall_style != "crossbeams") {
													down((rail_height+groove_height)/2) {
														up(15/2+rail_thick) {
															cube(size=[joiner_width+1, 16, 10], center=true);
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

					// Motor cage
					back(l/2-(motor_length+wall_thick)/2-coupler_len)
					difference() {
						union() {
							upcube([motor_width+2*wall_thick, motor_length+2*wall_thick, rail_height+groove_height/2+motor_width/2]);

							// Top side supports
							back((motor_length+wall_thick)/2) {
								upcube([z_joiner_spacing, wall_thick, rail_height+groove_height]);
							}

							// Bottom side supports
							fwd((motor_length+wall_thick)/2) {
								up(rail_thick+16) upcube([z_joiner_spacing+2*side_off, wall_thick, rail_height+groove_height-rail_thick-16]);
							}

							// Motor clip
							clip_w = 5;
							clip_h = 2;
							up(rail_height+groove_height/2+motor_width/2-0.05) {
								yflip_copy() {
									fwd(motor_length/2+wall_thick/2) {
										xspread(motor_width-16) {
											trapezoid([clip_w+2*clip_h, wall_thick], [clip_w, wall_thick], h=clip_h, center=false);
											back(wall_thick/2) up(clip_h/2) {
												yscale(0.75) {
													yrot(90) cylinder(d=clip_h, h=clip_w, center=true, $fn=6);
												}
											}
										}
									}
								}
							}
						}
						up(rail_height+groove_height/2) {
							// Clear motor space
							cube([motor_width+printer_slop, motor_length+printer_slop, motor_width+0.01], center=true);

							// Clear plinth slot
							xrot(-90) cylinder(d=plinth_diam, h=motor_length, center=false);
							back(motor_length/2) upcube([plinth_diam, motor_length, motor_width]);

							// Clear upper side holes
							cube([motor_width+3*wall_thick, motor_length/2, plinth_diam], center=true);
							fwd(wall_thick) cube([motor_width/2, motor_length+2*wall_thick, plinth_diam], center=true);
						}
						up(rail_thick) {
							// Side bottom motor cage holes.
							upcube([motor_width+3*wall_thick, motor_length/2, rail_height+groove_height/2-motor_width/2-rail_thick-5]);
							upcube([motor_width/2, motor_length+3*wall_thick, rail_height+groove_height/2-motor_width/2-rail_thick-5]);

							// Clear motor standoffs
							upcube([motor_width, motor_length/2, rail_height+groove_height/2-motor_width/2-rail_thick+0.01]);
							upcube([motor_width/2, motor_length, rail_height+groove_height/2-motor_width/2-rail_thick+0.01]);
						}
					}
				}

				// Clear bottom of motor cage
				back(l/2-(motor_length+wall_thick)/2-15) {
					cylinder(d=min(motor_width, motor_length)*0.67, h=rail_thick*3, center=true);
				}

				// Clear space for joiners.
				up(rail_height/2) {
					back(l/2-0.05) joiner_pair_clear(spacing=z_joiner_spacing, h=rail_height, w=joiner_width, clearance=4, a=joiner_angle);
					fwd(l/2-0.05) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, clearance=4, a=joiner_angle);
				}
			}

			// Endstop clip
			standoff = 10 - endstop_thick/2;
			fwd((endstop_depth+2-l)/2) {
				right((z_joiner_spacing+joiner_width-0.01)/2) {
					right(endstop_thick/2+2+standoff) {
						up(rail_height+groove_height/2) {
							difference() {
								left(standoff/2) cube([endstop_thick+standoff+2*2, endstop_depth+2, endstop_length+2*2], center=true);
								back(2/2) {
									cube([endstop_thick+2*printer_slop+0.05, endstop_depth+0.05, endstop_length+2*printer_slop], center=true);
									cube([endstop_thick+2*printer_slop-2, endstop_depth+10, endstop_length+2*printer_slop-1], center=true);
								}
							}
							down(endstop_length/2+2+endstop_thick*2/2+5/2-0.05) {
								left((endstop_thick)/2+2+standoff) {
									right_half() trapezoid([0.05, 0.05], [2*(endstop_thick+2*2+standoff), endstop_depth+2], h=endstop_thick*2+5, center=true);
								}
							}
							zspread(endstop_hole_spacing) {
								right(endstop_thick/2) {
									back(endstop_depth/2+2/2-endstop_hole_inset) {
										scale([0.5, 1, 1]) {
											sphere(d=endstop_screw_size, center=true, $fn=8);
										}
									}
								}
							}
						}
					}
				}
			}

			// Snap-tab joiners.
			up(rail_height/2+0.05) {
				back(l/2) xspread(z_joiner_spacing) yrot(180) joiner(h=rail_height, w=joiner_width, l=coupler_len+0.1, a=joiner_angle);
				back(l/2-coupler_len/2) xspread(z_joiner_spacing) up(rail_height/2-0.01) upcube([joiner_width, coupler_len+0.1, groove_height+0.01]);
				fwd(l/2) zrot(180) xspread(rail_spacing+joiner_width) joiner(h=rail_height, w=joiner_width, l=7, a=joiner_angle);
			}
		}
		up(rail_height/2) {
			fwd(l/2+explode) {
				if ($children > 0) children(0);
			}
			back(l/2+explode) {
				if ($children > 1) children(1);
			}
		}
		up(rail_height/2/2) {
			back(l/2-10) {
				left(rail_spacing/2+joiner_width+side_joiner_len) {
					if ($children > 2) children(2);
				}
				right(rail_spacing/2+joiner_width+side_joiner_len) {
					if ($children > 3) children(3);
				}
			}
		}
	}
}
//!z_base();



module z_base_parts() { // make me
	//zrot(90)
	z_base();
}



z_base_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

