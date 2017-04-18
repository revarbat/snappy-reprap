include <config.scad>
use <GDMUtils.scad>
use <sliders.scad>
use <joiners.scad>
use <NEMA.scad>


// connectby valid options: "", "fwd", "back"
module rail_xy_motor_segment(explode=0, connectby="")
{
	joiner_length = 8;
	side_joiner_len = 2;
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
								yrot(90) sparse_strut(h=rail_width, l=motor_rail_length, thick=rail_thick, maxang=75, strut=10, max_bridge=500);
								up((motor_top_z-motor_length+6-rail_thick)/2) {
									cube(size=[motor_width+2*7, motor_width+2*3, motor_top_z-motor_length+6], center=true);
								}
								up(motor_top_z-rail_thick/2) {
									down(motor_length/2) {
										cube(size=[motor_width+2*7, motor_width+2*3, motor_length+2*1], center=true);
									}
								}
							}

							// Clearance for NEMA17 stepper motor
							up(motor_top_z-rail_thick/2-motor_length/2) {
								up(2/2+0.05) {
									difference() {
										cube(size=[motor_width+2*printer_slop, motor_width+2*printer_slop, motor_length+printer_slop+2], center=true);
										up(motor_length/2) {
											yspread(motor_width+2*printer_slop) {
												cube(size=[5, 2, 2], center=true);
												cube(size=[5, 1, 8], center=true);
											}
										}
									}
								}
								down(5/2) cube(size=[motor_width/2, motor_width+20, motor_length-5], center=true);
								down(motor_length/2/2) cube(size=[motor_width+20, motor_width/2, motor_length/2], center=true);
								up(5/2) cube(size=[motor_width+2*4, motor_width/2, motor_length+5], center=true);
								cylinder(d=motor_width*3/4, h=motor_length*2, center=true);
							}
						}
					}

					// Walls.
					zring(r=0,n=2) {
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

					// Rails.
					xspread(rail_spacing+joiner_width) {
						up(rail_height+groove_height/2-0.05) {
							rail(l=motor_rail_length, w=joiner_width, h=groove_height);
						}
					}

					// Side Supports
					up(rail_height/4) {
						yspread(motor_rail_length-20) {
							cube(size=[rail_width, 5, rail_height/2], center=true);
						}
					}

					// Endstop clip
					zrot_copies([0, 180]) {
						fwd((endstop_depth+2)/2-8) {
							right((motor_width+endstop_thick+3+2*7)/2) {
								up(rail_height+groove_height-2-(endstop_length+2*2)/2) {
									difference() {
										left(2/2) cube([endstop_thick+4, endstop_depth+2, endstop_length+2*2], center=true);
										left(2/2) back(2/2) {
											cube([endstop_thick+2*printer_slop+0.05, endstop_depth+0.05, endstop_length+2*printer_slop], center=true);
											cube([endstop_thick+2*printer_slop-2, endstop_depth+10, endstop_length+2*printer_slop-1], center=true);
										}
									}
									down(endstop_length/2+2+endstop_thick*1.8/2-0.05) {
										left((endstop_thick+4.1)/2) {
											right_half() trapezoid([0.05, 0.05], [2*(endstop_thick+2)+2, endstop_depth+2], h=endstop_thick*1.8, center=true);
										}
									}
									zspread(endstop_hole_spacing) {
										right(endstop_thick/2-1.5/2+0.05) {
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

					// Side wiring access hole frame
					if (wall_style == "corrugated") {
						up(10/2+rail_thick) {
							xspread(rail_width-joiner_width) {
								yspread(motor_rail_length-2*28) {
									cube(size=[joiner_width, 16+4, 10+4], center=true);
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

				// Clear space for joiners.
				up(rail_height/2) {
					joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length-0.05, h=rail_height, w=joiner_width, clearance=5, a=joiner_angle);
				}

				// Side wiring access hole
				if (wall_style != "crossbeams") {
					up(10/2+rail_thick) {
						xspread(rail_width-joiner_width) {
							yspread(motor_rail_length-2*28) {
								cube(size=[joiner_width+1, 16, 10], center=true);
							}
						}
					}
				}

				// Clear space for Side half joiners
				up(rail_height/2/2) {
					yspread(side_mount_spacing) {
						zring(r=rail_spacing/2+joiner_width+side_joiner_len-0.05, n=2) {
							zrot(-90) {
								chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
									half_joiner_clear(h=rail_height/2, w=joiner_width, a=joiner_angle);
								}
							}
						}
					}
				}
			}

			// Snap-tab joiners.
			up(rail_height/2) {
				joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, l=6, a=joiner_angle);
			}

			// Side half joiners
			up(rail_height/2/2) {
				yspread(side_mount_spacing) {
					zring(r=rail_spacing/2+joiner_width+side_joiner_len, n=2) {
						zrot(-90) {
							chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
								half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len+joiner_width/2, a=joiner_angle);
							}
						}
					}
				}
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
//!rail_xy_motor_segment();



module rail_xy_motor_segment_parts() { // make me
	zrot(90) rail_xy_motor_segment();
}


rail_xy_motor_segment_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
