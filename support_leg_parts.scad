include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>

module support_leg(h=rail_height, l=75)
{
	ang = atan((h-10)/l);
	joiner_length=5;

	color("SandyBrown")
	union() {
		difference() {
			union() {
				// Back wall.
				translate([0, platform_thick/2, h/2]) {
					cube(size=[platform_length/2+joiner_width, platform_thick, h], center=true);
				}

				// Legs.
				grid_of(xa=[-platform_length/4, platform_length/4]) {
					translate([0, l/2, 0.75*h/2]) {
						thinning_triangle(h=0.75*h, l=l, thick=platform_thick);
					}
				}
			}
			// Clear for side joiners.
			translate([0, -joiner_length, rail_height/2]) {
				zrot(180) joiner_pair_clear(spacing=platform_length/2, h=rail_height, w=joiner_width, a=joiner_angle);
			}
		}

		// Side joiners.
		translate([0, -joiner_length, rail_height/2]) {
			zrot(180) joiner_pair(spacing=platform_length/2, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
		}
	}
}
//!support_leg();



module support_leg_parts() { // make me
	translate([0, -75/2, 0]) support_leg();
}



support_leg_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

