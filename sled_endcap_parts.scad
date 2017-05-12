include <config.scad>
use <GDMUtils.scad>
use <sliders.scad>
use <joiners.scad>


module sled_endcap()
{
	joiner_length = 20;
	hardstop_offset = drive_gear_diam/2;

	color("DodgerBlue")
	prerender(convexity=10)
	difference() {
		union() {
			difference() {
				union() {
					difference() {
						// Bottom
						fwd(joiner_length/2) {
							down(platform_thick/2) {
								cube(size=[platform_width-joiner_width*2+0.1, joiner_length-0.05, platform_thick], center=true);
							}
						}

						// Clear for joiners.
						down(platform_height/2-0.05) {
							fwd(0.01) {
								joiner_pair_clear(spacing=platform_width-joiner_width, h=platform_height, clearance=-0.01, w=joiner_width, a=joiner_angle);
							}
						}
					}

					// Snap-tab joiners.
					down(platform_height/2) {
						difference() {
							joiner_pair(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, l=joiner_length-joiner_width/2, a=joiner_angle);
							down(platform_height/2) {
								xspread(platform_width-joiner_width) {
									xspread(joiner_width) {
										xrot(90) chamfer_mask(r=3, h=2*joiner_length);
									}
								}
							}
						}
					}
				}

				// Clear for Side joiners
				down(platform_height/2) {
					fwd(joiner_length-joiner_width/2) {
						xspread(platform_width+0.1) {
							zrot(-90) joiner_clear(h=platform_height, w=joiner_width, clearance=5, l=joiner_width, a=joiner_angle);
						}
					}
				}
			}

			// Side joiners
			down(platform_height/2) {
				fwd(joiner_length-joiner_width/2) {
					difference() {
						yrot_copies([0,180]) {
							translate([platform_width/2, 0, 0]) {
								zrot(-90) joiner(h=platform_height, w=joiner_width, l=joiner_width, a=joiner_angle);
							}
						}
						down(platform_height/2) {
							yspread(joiner_width) {
								yrot(90) chamfer_mask(r=3, h=2*joiner_length+platform_width);
							}
							xspread(platform_width-2*joiner_width) {
								xrot(90) chamfer_mask(r=3, h=2*joiner_length+platform_width);
							}
						}
					}
				}
			}

			// Rack and pinion hard stop.
			endstop_h = platform_z - motor_top_z - 5 - 2;
			down(endstop_h/2-0.05) {
				fwd(joiner_length-(joiner_length-hardstop_offset)/2) {
					cube(size=[rail_spacing-joiner_width+1, joiner_length-hardstop_offset, endstop_h], center=true);
				}
			}
		}
	}
}
//!sled_endcap();



module sled_endcap_parts() { // make me
	zrot(90) xrot(180) sled_endcap();
}


sled_endcap_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

