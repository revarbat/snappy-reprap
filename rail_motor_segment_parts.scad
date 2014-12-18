include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rail_motor_segment()
{
	joiner_length = 10;
	side_joiner_len = 10;

	color("SpringGreen")
	prerender(convexity=20)
	union() {
		difference() {
			union() {
				// Bottom.
				translate([0,0,rail_thick/2]) {
					difference() {
						union() {
							yrot(90)
								sparse_strut(h=rail_width, l=motor_rail_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
							cube(size=[motor_mount_spacing+joiner_width, 45+20, rail_thick], center=true);
						}
						cube(size=[motor_mount_spacing-joiner_width, 45, rail_thick+1], center=true);
					}
				}

				// Walls.
				zrot_copies([0, 180]) {
					translate([(rail_spacing/2+joiner_width/2), 0, (rail_height+3)/2]) {
						if (wall_style == "crossbeams")
							sparse_strut(h=rail_height+3, l=motor_rail_length-2*joiner_length, thick=joiner_width, strut=5);
						if (wall_style == "thinwall")
							thinning_wall(h=rail_height+3, l=motor_rail_length-2*joiner_length, thick=joiner_width, strut=5, bracing=false);
						if (wall_style == "corrugated")
							corrugated_wall(h=rail_height+3, l=motor_rail_length-2*joiner_length, thick=joiner_width, strut=5);
					}
				}

				// Rail backing.
				grid_of(count=2, spacing=rail_spacing+joiner_width)
					translate([0,0,rail_height+groove_height/2])
						chamfer(size=[joiner_width, motor_rail_length, groove_height], chamfer=1, edges=[[1,1,0,0], [1,1,0,0], [0,0,0,0]])
							cube(size=[joiner_width, motor_rail_length, groove_height], center=true);

				// Side Supports
				translate([0, 0, rail_height/4]) {
					grid_of(count=[1,2], spacing=[0, motor_rail_length-20]) {
						cube(size=[rail_width, 5, rail_height/2], center=true);
					}
				}

				// Motor mount joiners.
				translate([0, 0, rail_height-5-20]) {
					xrot(90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=rail_height-5-20, a=joiner_angle);
				}
			}

			// Rail grooves.
			translate([0,0,rail_height+groove_height/2]) {
				mirror_copy([1,0,0]) {
					translate([-(rail_width/2-joiner_width/2), 0, 0]) {
						mirror_copy([1,0,0]) {
							translate([(joiner_width/2), 0, 0]) {
								// main groove
								scale([tan(groove_angle),1,1]) yrot(45) {
									cube(size=[groove_height*sqrt(2)/2,motor_rail_length+1,groove_height*sqrt(2)/2], center=true);
								}

								// chamfers
								mirror_copy([0,1,0]) {
									translate([0, motor_rail_length/2, 0]) {
										hull() {
											grid_of(count=[1,2], spacing=2) {
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
			translate([0, 0, rail_height/4]) {
				grid_of(count=[3,2], spacing=[rail_width/3, motor_rail_length-20]) {
					cube(size=[16, 11, 10], center=true);
				}
			}

			// Clear space for joiners.
			translate([0,0,rail_height/2]) {
				joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, clearance=5, a=joiner_angle);
			}

			// Shrinkage stress relief
			translate([0, 0, rail_thick/2]) {
				grid_of(count=[1, 5], spacing=[0, 16]) {
					cube(size=[rail_width+1, 1, rail_thick-2], center=true);
				}
				grid_of(count=[7, 2], spacing=[15, motor_rail_length-10]) {
					cube(size=[1, 60, rail_thick-2], center=true);
				}
			}

			// Clear space for side mount joiners.
			zrot_copies([0,180]) {
				translate([rail_width/2-5, 0, 0]) {
					translate([side_joiner_len+joiner_width/2, 0, rail_height/2/2]) {
						translate([0, -platform_length/4, 0]) {
							zrot(-90) half_joiner_clear(h=rail_height/2, w=joiner_width, l=side_joiner_len, a=joiner_angle);
						}
						translate([0, platform_length/4, 0]) {
							zrot(-90) half_joiner_clear(h=rail_height/2, w=joiner_width, l=side_joiner_len, a=joiner_angle, slop=printer_slop);
						}
					}
				}
			}
		}

		// Snap-tab joiners.
		translate([0,0,rail_height/2]) {
			joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, l=13, a=joiner_angle);
		}

		// Side mount joiners.
		zrot_copies([0,180]) {
			translate([rail_width/2-5, 0, 0]) {
				translate([side_joiner_len+joiner_width/2, 0, rail_height/2/2]) {
					translate([0, -side_mount_spacing/2, 0]) {
						zrot(-90) {
							chamfer(chamfer=joiner_width/3, size=[joiner_width, side_joiner_len*2, rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
								half_joiner(h=rail_height/2, w=joiner_width, l=side_joiner_len, a=joiner_angle);
							}
						}
					}
					translate([0, side_mount_spacing/2, 0]) {
						zrot(-90) {
							chamfer(chamfer=joiner_width/3, size=[joiner_width, side_joiner_len*2, rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
								half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len, a=joiner_angle, slop=printer_slop);
							}
						}
					}
				}
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

