include <config.scad>
use <GDMUtils.scad>
use <publicDomainGearV1.1.scad>


module drive_gear() {
	shaft = motor_shaft_size + printer_slop;

	color("Salmon")
	prerender(convexity=10)
	union() {
		difference() {
			// Herringbone gear
			zflip_copy() {
				up(rack_height/2/2) {
					gear (
						mm_per_tooth    = rack_tooth_size,
						number_of_teeth = 9,
						thickness       = rack_height/2,
						hole_diameter   = shaft,
						twist           = 15,
						teeth_to_hide   = 0,
						pressure_angle  = 20
					);
				}
			}

			// Bevel end of gear.
			tube(h=6, r1=20, r2=7.5, wall=4);
		}
		difference() {
			union() {
				// Fix up gear weirdness with solid center.
				cylinder(h=rack_height, r=shaft, center=true);

				// Base
				down((rack_height+10)/2)
					cylinder(h=gear_base, r=9, center=true);
			}

			difference() {
				// Shaft hole
				cylinder(h=(rack_height+gear_base)*3, r=shaft/2, center=true, $fn=16);

				if (motor_shaft_flatted) {
					// Shaft flat side.
					right(1.4*shaft)
						cube(size=[shaft*2, shaft*2, (rack_height+gear_base)*3], center=true);
				}
			}

			right(motor_shaft_size/2+1.5) {
				down(rack_height/2+gear_base/2) {
					yrot(90) {
						// Nut Slot
						scale([1.1, 1.1, 1.1]) hull() {
							metric_nut(size=set_screw_size, hole=false);
							right(gear_base/2) metric_nut(size=set_screw_size, hole=false);
						}

						// Set screw hole.
						up(2) cylinder(r=set_screw_size/2+printer_slop, h=9, center=true, $fn=8);
					}
				}
			}
		}
	}
}
//!drive_gear();


module drive_gear_parts() { // make me
	up(gear_base+rack_height/2) {
		yspread(30) drive_gear();
	}
}



drive_gear_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
