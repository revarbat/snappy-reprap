include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


joiner_length = 15;
hardstop_offset = 8;
descent = platform_length + joiner_length - 20;

module z_joiner()
{
	color("Sienna")
	prerender(convexity=10)
	union() {
		// Top joiners
		xrot(-90) {
			down(platform_height/2) {
				difference() {
					joiner_pair(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
					down(platform_height/2) {
						xspread(platform_width-joiner_width) {
							xspread(joiner_width) {
								xrot(90) chamfer_mask(h=joiner_length*3, r=3);
							}
						}
					}
				}
			}
		}

		up((joiner_length+hardstop_offset)/2) {
			fwd(platform_thick/2) {
				cube(size=[platform_width-0.05, platform_thick, joiner_length-hardstop_offset], center=true);
			}
		}

		// Rack and pinion hard stop.
		up((joiner_length+hardstop_offset)/2) {
			fwd(rail_offset/2+platform_thick) {
				cube(size=[motor_mount_spacing+joiner_width+5, rail_offset, joiner_length-hardstop_offset], center=true);
			}
		}

		// endstop trigger
		up(joiner_length/2) {
			xspread(motor_mount_spacing+joiner_width+4+10) {
				fwd((1+platform_thick/2+rail_offset+groove_height/2+3)/2) {
					xrot(90) chamfcube(chamfer=2, size=[10, joiner_length, platform_thick*1.5+rail_offset+groove_height/2+3], chamfaxes=[1,1,0], center=true);
				}
			}
		}

		difference() {
			union() {
				// Back wall
				desclen = descent - rail_height + joiner_length;
				down(desclen/2-joiner_length) {
					back(platform_thick/2-0.05) {
						zrot(90) {
							if (wall_style == "crossbeams")
								sparse_strut(h=desclen, l=platform_width, thick=platform_thick, strut=5);
							if (wall_style == "thinwall")
								thinning_wall(h=desclen, l=platform_width, thick=platform_thick, strut=joiner_width, bracing=false);
							if (wall_style == "corrugated")
								corrugated_wall(h=desclen, l=platform_width, thick=platform_thick, strut=joiner_width);
						}
					}
				}

				// Joiner supports and groove end blocks.
				down(descent-rail_height) {
					back(platform_thick/2-0.05) {
						xspread(rail_width-joiner_width) {
							xrot(-90) trapezoid([joiner_width, groove_height*2+cantilever_length*2], [joiner_width, groove_height*2], h=cantilever_length-platform_thick/2);
						}
					}
				}
			}

			// Clearance for front joiners
			down(descent-rail_height/2) {
				back(cantilever_length) {
					joiner_pair_clear(spacing=rail_width-joiner_width, h=rail_height, w=joiner_width, a=joiner_angle, clearance=3);
				}
			}
		}

		// Front joiners
		down(descent-rail_height/2) {
			back(cantilever_length) {
				joiner_pair(spacing=rail_width-joiner_width, h=rail_height, w=joiner_width, l=cantilever_length, a=joiner_angle);
			}
		}
	}

	// children
	down(descent-rail_height/2) {
		back(cantilever_length) {
			children();
		}
	}
}
//!z_joiner();



module z_joiner_parts() { // make me
	zrot(-90) xrot(180) down(joiner_length) z_joiner();
}



z_joiner_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

