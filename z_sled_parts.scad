include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>
use <sliders.scad>



$fa = 2;
$fs = 2;

module z_sled(explode=0, arrows=false)
{
	slider_len = 15;
	slider_wall = 5;
	cantlen = cantilever_length - slider_wall - groove_height/2;
	motor_width = nema_motor_width(17);
	plinth_diam = nema_motor_plinth_diam(17);
	motor_joiner_h = motor_length * 0.75;
	motor_joiner_x = motor_width - joiner_width;
	arch_offset = rail_length * (1-cos(bridge_arch_angle));

	color("MediumSlateBlue")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Back
				up((rail_height+groove_height)/2) {
					right(cantilever_length - platform_thick/2 - 2/2 - 8) {
						if (wall_style == "crossbeams")
							sparse_strut(l=rail_spacing+joiner_width, h=rail_height+groove_height, thick=platform_thick+2, strut=6);
						if (wall_style == "thinwall")
							thinning_wall(l=rail_spacing+joiner_width, h=rail_height+groove_height, thick=platform_thick+2, strut=6, bracing=false);
						if (wall_style == "corrugated") {
							corrugated_wall(l=rail_spacing+joiner_width, h=rail_height+groove_height, thick=platform_thick+2, strut=6);

							// Wiring access hole frame
							down(rail_height/2+groove_height/2-(10+8)/2-2) {
								cube(size=[platform_thick+2, 16+4, 10+8], center=true);
							}
						}

						// joiner backing.
						right(rail_height*sin(bridge_arch_angle)+arch_offset/2) {
							yspread(rail_spacing+joiner_width) {
								cube(size=[platform_thick+2+arch_offset+2*rail_height*sin(bridge_arch_angle), joiner_width, rail_height+groove_height], center=true);
							}
						}
					}
				}


				difference() {
					// Motor Cage
					up((rail_height+groove_height)/2) {
						cube(size=[motor_width+6, motor_width+6, rail_height+groove_height], center=true);
					}

					up((motor_length+1+printer_slop)/2) {
						difference() {
							// Clear motor volume
							cube(size=[motor_width+2*printer_slop, motor_width+2*printer_slop, motor_length+1+printer_slop+0.1], center=true);

							// Tabs to hold motor in
							down(motor_length/2) {
								yspread(motor_width+2*printer_slop) {
									cube(size=[5, 2, 2], center=true);
									cube(size=[5, 1, 8], center=true);
								}
							}
						}
					}

					// Clear motor cage wiring access
					up(groove_height/2) {
						right(motor_width/2+printer_slop) {
							cube(size=[10, motor_width*0.5, groove_height+1], center=true);
						}
					}

					// Motor tray cooling holes
					up((rail_height+groove_height)/2) {
						zrot_copies([0,90]) {
							cube(size=[motor_width+10, motor_width*0.5, rail_height], center=true);
						}
						cylinder(d=plinth_diam, h=rail_height+groove_height+1, center=true);
					}
				}

				// Motor cage supports
				support_len = cantilever_length - motor_length/2 - platform_thick/2 - 10 - 2 - printer_slop;
				yspread(motor_width+2*3-5) {
					up((rail_height+groove_height)/2) {
						right(cantilever_length-support_len/2-platform_thick/2-10) {
							cube(size=[support_len, 5, rail_height+groove_height], center=true);
						}
					}
				}

				// sliders
				up(rail_height+groove_height-slider_len/2) {
					yflip_copy() {
						fwd((rail_spacing+joiner_width)/2) {
							difference() {
								// Slider block
								right(slider_wall/2) {
									chamfcube(chamfer=2, size=[groove_height+2+slider_wall, joiner_width+2+2*slider_wall, slider_len], chamfaxes=[0, 0, 1], center=true);
								}

								// Slider groove
								left(slider_wall) {
									cube(size=[groove_height+2+2*slider_wall, joiner_width+2, slider_len+1], center=true);
								}
							}

							// Slider ridges
							zrot(90) xrot(90) {
								down(groove_height/2) {
									slider(l=slider_len, base=0, slop=2*printer_slop);
								}
							}
						}
					}
				}
			}

			// Clear wiring access hole frame
			if (wall_style != "crossbeams") {
				up((rail_height+groove_height)/2) {
					right(cantilever_length - platform_thick/2 - 8) {
						down(rail_height/2+groove_height/2-10/2-8) {
							cube(size=[platform_thick+0.1, 16, 10], center=true);
						}
					}
				}
			}

			// Clear space for front joiners.
			right(cantilever_length+arch_offset) {
				up(rail_height/2) yrot(-bridge_arch_angle) {
					zrot(-90) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height+0.001, w=joiner_width, clearance=1, a=joiner_angle);
					right(rail_width*1.5) {
						cube(size=rail_width*3, center=true);
					}
				}
			}
		}

		right(cantilever_length) {
			up(rail_height/2) {
				right(arch_offset) {
					difference() {
						// Snap-tab front joiners.
						yrot(-bridge_arch_angle) {
							right(0.05) zrot(-90) joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=arch_offset+10+0.1, a=joiner_angle);
						}
						down(rail_height) cube(size=[rail_width*2, rail_width*2, rail_height], center=true);
					}
				}

				// Slider supports.
				left(cantlen/2+10/2) {
					up(rail_height/2+groove_height-slider_len/2) {
						yspread(rail_spacing+joiner_width) {
							cube([cantlen-10+0.05, joiner_width, slider_len], center=true);
							down(slider_len) {
								yrot(180) right_triangle(size=[cantlen-10+0.05, joiner_width, slider_len+0.05], center=true);
							}
						}
					}
				}
			}
		}
	}

	// Placeholder lifter screw
	//#up(rail_height+groove_height/2) cylinder(d=lifter_screw_diam, h=16, center=true);

	// Children
	right(cantilever_length+arch_offset+explode) {
		up(rail_height/2) {
			yrot(-bridge_arch_angle) children();
		}
	}
}
//!z_sled() cylinder(d=1, h=10);



module z_sled_parts() { // make me
	xrot(180) down(rail_height+groove_height) z_sled();
}


z_sled_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
