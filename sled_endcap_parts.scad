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
							cube(size=[platform_width, joiner_length, platform_thick], center=true);
						}

						// Clear for joiners.
						translate([0,0,-platform_height/2]) {
							joiner_pair_clear(spacing=platform_width-joiner_width, h=platform_height+0.001, clearance=5, w=joiner_width, a=joiner_angle);
						}
					}

					// Snap-tab joiners.
					translate([0,0,-platform_height/2]) {
						joiner_pair(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
					}
				}

				// Clear for Side joiners
				translate([0, -(joiner_length-joiner_width/2), -platform_height/2]) {
					yrot_copies([0,180]) {
						translate([platform_width/2, 0, 0]) {
							zrot(-90) joiner_clear(h=platform_height+0.001, w=joiner_width, clearance=5, l=joiner_width, a=joiner_angle);
						}
					}
				}
			}
							
			// Side joiners
			translate([0, -(joiner_length-joiner_width/2), -platform_height/2]) {
				yrot_copies([0,180]) {
					translate([platform_width/2, 0, 0]) {
						zrot(-90) joiner(h=platform_height, w=joiner_width, l=joiner_width, a=joiner_angle);
					}
				}
			}

			// Rack and pinion hard stop.
			translate([0, -joiner_length+(joiner_length-hardstop_offset)/2, -platform_thick-rail_offset/2]) {
				cube(size=[motor_mount_spacing+joiner_width+5, joiner_length-hardstop_offset, rail_offset], center=true);
			}

			// endstop trigger
			translate([0, -joiner_length/2, 0]) {
				mirror_copy([1, 0, 0]) {
					translate([motor_mount_spacing/2+joiner_width/2+2, 0, 0]) {
						translate([10/2, 0, -(platform_thick+rail_offset+groove_height/2+4)/2]) {
							xrot(90) chamfcube(chamfer=2, size=[10, platform_thick+rail_offset+groove_height/2+4, joiner_length], chamfaxes=[1,0,1], center=true);
						}
					}
				}
			}
		}
	}
}
//!sled_endcap();



module sled_endcap_parts() { // make me
	zrot_copies([90,270]) translate([0, 10, 0]) xrot(180) sled_endcap();
}


sled_endcap_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

