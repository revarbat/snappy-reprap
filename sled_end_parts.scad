include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module sled_end()
{
	snap_width = 15;
	color("DodgerBlue") union() {
		difference() {
			union() {
				// Base.
				translate([0,-(snap_width/2),platform_thick/2])
					cube(size=[platform_width, snap_width, platform_thick], center=true);

				// Back wall.
				translate([0,-(snap_width-platform_thick/2),platform_height/2])
					cube(size=[platform_width, platform_thick, platform_height], center=true);
			}

			// Remove bits of back wall that would hit rails.
			translate([0, -snap_width/2, platform_height/2+roller_base-2]) {
				cube(size=[rail_spacing+joiner_width*2+5, snap_width+platform_thick+10, platform_height], center=true);
			}

			// Remove bits from platform so snap tabs have freedom.
			grid_of(
				xa=[-(platform_width-joiner_width/2-5)/2, (platform_width-joiner_width/2-5)/2]
			) {
				xrot(joiner_angle) translate([-(joiner_width+10)/2,0,-1])
					cube(size=[joiner_width+10,platform_thick,platform_thick*1.5], center=false);
			}
		}

		// Joiner tabs.
		translate([0,0,platform_height/2]) {
			yrot_copies([0,180]) {
				translate([platform_width/2-joiner_width/2, 0, 0]) {
					joiner(h=platform_height, w=joiner_width, l=10, a=joiner_angle);
				}
			}
		}

		// Rack endstop block.
		translate([0, -snap_width/2, (platform_thick+3+10)/2])
			cube(size=[15,snap_width,(platform_thick+3+10)], center=true);
	}
}
//!sled_end();



module sled_end_part() { // make me
	zrot_copies([90,270]) translate([0,20,0]) sled_end();
}


sled_end_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

