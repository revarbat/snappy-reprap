include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module sled_endcap()
{
	joiner_length = 15;
	color("DodgerBlue") union() {
		difference() {
			union() {
				// Base.
				translate([0,-(joiner_length/2),platform_thick/2])
					cube(size=[platform_width, joiner_length, platform_thick], center=true);

				// Back wall.
				translate([0,-(joiner_length-platform_thick/2),platform_height/2])
					cube(size=[platform_width, platform_thick, platform_height], center=true);
			}

			// Remove bits of back wall that would hit rails.
			translate([0, -joiner_length/2, platform_height/2+rail_offset-2]) {
				cube(size=[rail_spacing+joiner_width*2+5, joiner_length+platform_thick+10, platform_height], center=true);
			}

			// Clear space for joiners.
			translate([0,0,platform_height/2]) {
				joiner_pair_clear(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width+5, a=joiner_angle);
			}
		}

		// Snap-tab joiners.
		translate([0,0,platform_height/2]) {
			joiner_pair(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
		}

		// Rack endstop block.
		translate([0, -joiner_length/2, (platform_thick+3+10)/2])
			cube(size=[15,joiner_length,(platform_thick+3+10)], center=true);
	}
}
//!sled_endcap();



module sled_endcap_parts() { // make me
	zrot_copies([90,270]) translate([0,20,0]) sled_endcap();
}


sled_endcap_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

