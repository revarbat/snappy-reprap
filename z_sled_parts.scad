include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>
use <sliders.scad>



$fa = 2;
$fs = 2;

module z_sled(explode=0, arrows=false)
{
	slider_len = 20;
	slider_wall = 5;
	cantlen = cantilever_length - slider_wall - groove_height/2;
	motor_width = nema_motor_width(17);
	plinth_diam = nema_motor_plinth_diam(17);
	motor_joiner_h = motor_length * 0.75;
	motor_joiner_x = motor_width - joiner_width;

	color("MediumSlateBlue")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Back
				up((rail_height+groove_height)/2) {
					right(cantilever_length - platform_thick/2 ) {
						sparse_strut(l=rail_spacing+1, h=rail_height+groove_height, thick=platform_thick, strut=8, maxang=45, max_bridge=999);
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

							// Snap tabs to hold motor in
							down(motor_length/2) {
								yspread(motor_width+2*printer_slop) {
									cube(size=[5, 2, 2], center=true);
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
				support_len = cantilever_length - motor_length/2 - 2 - printer_slop;
				yspread(motor_width+2*3-5) {
					up((rail_height+groove_height)/2) {
						right(cantilever_length-support_len/2) {
							cube(size=[support_len, 5, rail_height+groove_height], center=true);
						}
					}
				}

				// sliders
				up(rail_height+groove_height-platform_length/2) {
					yflip_copy() {
						fwd((rail_spacing+joiner_width)/2) {
							difference() {
								// Slider block
								right(slider_wall/2) {
									chamfcube(chamfer=2, size=[groove_height+2+slider_wall, joiner_width+2+2*slider_wall, platform_length], chamfaxes=[0, 0, 1], center=true);
								}

								// Slider groove
								left(slider_wall) {
									cube(size=[groove_height+2+2*slider_wall, joiner_width+2, platform_length+1], center=true);
								}
							}

							// Slider ridges
							zspread(platform_length-slider_len, n=2) {
								zrot(90) xrot(90) {
									down(groove_height/2) {
										left_half() slider(l=slider_len, base=0, slop=2*printer_slop);
									}
								}
							}
						}
					}
				}
			}

			// Clear space for front joiners.
			right(cantilever_length+0.05) {
				up(rail_height/2) {
					zrot(-90) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height+0.001, w=joiner_width, clearance=5, a=joiner_angle);
				}
			}
		}

		right(cantilever_length) {
			up(rail_height/2) {
				// Snap-tab front joiners.
				zrot(-90) joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=cantlen+0.1, a=joiner_angle);

				// Rail top corners
				left(cantlen/2) {
					up(rail_height/2+groove_height/2) {
						yspread(rail_spacing+joiner_width) {
							cube([cantlen+0.05, joiner_width, groove_height+0.05], center=true);
						}
					}
				}
			}
		}
	}

	// Placeholder lifter screw
	//#up(rail_height+groove_height/2) cylinder(d=lifter_screw_diam, h=16, center=true);

	// Children
	right(cantilever_length+explode) {
		up(rail_height/2) {
			children();
		}
	}
}
//!z_sled() sphere(1);



module z_sled_parts() { // make me
	xrot(180) down(rail_height+groove_height) z_sled();
}


z_sled_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
