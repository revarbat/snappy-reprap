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
	slider_width = 12;
	motor_width = nema_motor_width(17);
	plinth_diam = nema_motor_plinth_diam(17);
	motor_joiner_h = motor_length * 0.75;
	motor_joiner_x = motor_width - joiner_width;
	arch_offset = rail_length * (1-cos(bridge_arch_angle));
	guide_h = z_joiner_spacing/2-joiner_width/2-motor_width/2-3;

	color("MediumSlateBlue")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Back
				up(rail_height/2) {
					right(cantilever_length - platform_thick/2 - 3) {
						skew_xy(xang=-bridge_arch_angle) {
							difference() {
								union() {
									if (wall_style == "crossbeams")
										sparse_strut(l=z_joiner_spacing, h=rail_height, thick=platform_thick+2, strut=6);
									if (wall_style == "thinwall")
										thinning_wall(l=z_joiner_spacing, h=rail_height, thick=platform_thick+2, strut=6);
									if (wall_style == "corrugated") {
										corrugated_wall(l=z_joiner_spacing, h=rail_height, thick=platform_thick+2, strut=6);

										// Wiring access hole frame
										down(rail_height/2-(10+8)/2-2) {
											cube(size=[platform_thick+2, 16+4, 10+8], center=true);
										}
									}
								}

								// Clear wiring access hole frame
								if (wall_style != "crossbeams") {
									down(rail_height/2-(10+8)/2-2) {
										cube(size=[platform_thick+3, 16, 10], center=true);
									}
								}
							}
						}

						// joiner backing.
						right(rail_height*sin(bridge_arch_angle)+arch_offset/2) {
							yspread(z_joiner_spacing-0.05) {
								skew_xy(xang=-bridge_arch_angle) {
									cube(size=[20, joiner_width, rail_height], center=true);
								}
							}
						}
					}
				}


				difference() {
					// Motor Cage
					up(rail_height/2) {
						cube(size=[motor_width+6, motor_width+6, rail_height], center=true);
					}

					up((motor_length+1+printer_slop)/2) {
						difference() {
							// Clear motor volume
							cube(size=[motor_width+2*printer_slop, motor_width+2*printer_slop, motor_length+1+printer_slop+0.1], center=true);

							// Tabs to hold motor in
							down(motor_length/2) {
								yspread(motor_width+2*printer_slop) {
									cube(size=[10, 2.5, 2], center=true);
									cube(size=[10, 1, 8], center=true);
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
					up(rail_height/2) {
						zrot_copies([0,90]) {
							up(2/2) {
								cube(size=[motor_width+10, motor_width*0.5, rail_height-5-3], center=true);
							}
						}
						cylinder(d=plinth_diam, h=rail_height+1, center=true);
					}
				}

				// Motor cage supports
				support_len = cantilever_length - motor_length/2 - platform_thick/2 - 6;
				yspread(motor_width+2*3-5) {
					up(rail_height/2) {
						right(motor_width/2+3-0.05) {
							right_half() {
								trapezoid([(support_len+rail_height/2*sin(bridge_arch_angle))*2, 5], [(support_len-rail_height/2*sin(bridge_arch_angle))*2, 5], h=rail_height, center=true);
							}
						}
					}
				}

				// Guide sliders
				yflip_copy() {
					up(rail_height-slider_len/2) {
						back(z_joiner_spacing/2-joiner_width/2+guide_h/2+printer_slop+0.01) {
							right(slider_width/2) {
								zrot(90) yrot(90) {
									trapezoid(size1=[slider_len-2*guide_h, slider_width-2*guide_h], size2=[slider_len, slider_width], h=guide_h, center=true);
								}
								right((motor_width/2+support_len-slider_width)/2) {
									back(guide_h/2+5/2) {
										cube(size=[motor_width/2+support_len+0.1, 5, slider_len], center=true);
									}
								}
							}
						}
					}
				}
			}

			// Clear space for front joiners.
			right(cantilever_length+arch_offset-0.1) {
				up(rail_height/2) yrot(-bridge_arch_angle) {
					zrot(-90) joiner_pair_clear(spacing=z_joiner_spacing, h=rail_height, w=joiner_width, clearance=1, a=joiner_angle);
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
							zrot(-90) {
								xspread(z_joiner_spacing) {
									yrot(180) joiner(h=rail_height, w=joiner_width, l=10-0.1, a=joiner_angle);
								}
							}
						}
						down(rail_height) cube(size=[rail_width*2, rail_width*2, rail_height], center=true);
					}
				}
			}
		}
	}

	// Placeholder lifter screw
	//#down(lifter_screw_thick/2+3) cylinder(d=lifter_screw_diam, h=lifter_screw_thick, center=true);

	// Children
	right(cantilever_length+arch_offset+explode) {
		up(rail_height/2) {
			yrot(-bridge_arch_angle) children();
		}
	}
}
//!z_sled() cylinder(d=1, h=10);



module z_sled_parts() { // make me
	xrot(180) down(rail_height) z_sled();
}


z_sled_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
