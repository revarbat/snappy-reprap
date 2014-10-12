include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module sled_endcap()
{
	joiner_length = 15;
	hardstop_offset=8;

	color("DodgerBlue")
	render(convexity=10)
	difference() {
		union() {
			difference() {
				// Bottom
				translate([0, -joiner_length/2, -platform_thick/2]) {
					cube(size=[platform_width-joiner_width, joiner_length, platform_thick], center=true);
				}

				// Clear for joiners.
				translate([0,0,-platform_height/2]) {
					joiner_pair_clear(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, a=joiner_angle);
				}
			}

			// Snap-tab joiners.
			translate([0,0,-platform_height/2]) {
				intersection() {
					joiner_pair(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
					grid_of(xa=[-(platform_width-joiner_width)/2, (platform_width-joiner_width)/2]) {
						xrot(90) rrect(r=joiner_width/3, size=[joiner_width, platform_height, joiner_length*2], center=true);
					}
				}
			}

			// Rack and pinion hard stop.
			translate([0, -joiner_length+(joiner_length-hardstop_offset)/2, -platform_thick-rail_offset/2]) {
				cube(size=[motor_mount_spacing+joiner_width+5, joiner_length-hardstop_offset, rail_offset], center=true);
			}


			// endstop trigger
			translate([0, -15/2, 0]) {
				mirror_copy([1, 0, 0]) {
					translate([motor_mount_spacing/2+joiner_width/2+2, 0, 0]) {
						translate([10/2, 0, -(platform_thick+rail_offset+groove_height/2+4)/2]) {
							xrot(90) rrect(r=10/3, size=[10, platform_thick+rail_offset+groove_height/2+4, 15], center=true);
						}
					}
				}
			}
		}
	}
}
//!sled_endcap();



module sled_endcap_parts() { // make me
	zrot_copies([90,270]) translate([0, 5, 15]) xrot(90) sled_endcap();
}


sled_endcap_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

