include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module sled_endcap()
{
	joiner_length = 20;
	hardstop_offset=8;

	color("DodgerBlue")
	prerender(convexity=10)
	difference() {
		union() {
			difference() {
				union() {
					difference() {
						// Bottom
						translate([0, -joiner_length/2, -platform_thick/2]) {
							cube(size=[platform_width-joiner_width, joiner_length, platform_thick], center=true);
						}

						// Clear for joiners.
						down(platform_height/2) {
							fwd(0.05) {
								joiner_pair_clear(spacing=platform_width-joiner_width, h=platform_height, clearance=5, w=joiner_width, a=joiner_angle);
							}
						}
					}

					// Snap-tab joiners.
					translate([0,0,-platform_height/2]) {
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
				translate([0, -(joiner_length-joiner_width/2), -platform_height/2]) {
					xspread(platform_width+0.1) {
						zrot(-90) joiner_clear(h=platform_height, w=joiner_width, clearance=5, l=joiner_width, a=joiner_angle);
					}
				}
			}

			// Side joiners
			translate([0, -(joiner_length-joiner_width/2), -platform_height/2]) {
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

			// Rack and pinion hard stop.
			translate([0, -joiner_length+(joiner_length-hardstop_offset)/2, -platform_thick-rail_offset/2+0.05]) {
				cube(size=[motor_mount_spacing+joiner_width+10, joiner_length-hardstop_offset, rail_offset], center=true);
			}

			// endstop trigger
			translate([0, -joiner_length/2, 0]) {
				mirror_copy([1, 0, 0]) {
					translate([motor_mount_spacing/2+joiner_width/2+2, 0, 0]) {
						translate([10/2, 0, -(platform_thick+rail_offset+groove_height/2+3+0.01)/2]) {
							xrot(90) chamfcube(chamfer=2, size=[10, platform_thick+rail_offset+groove_height/2+3, joiner_length], chamfaxes=[1,0,1], center=true);
						}
					}
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

