include <config.scad>
use <GDMUtils.scad>
use <publicDomainGearV1.1.scad>


module drive_gear() {
	h = 10;
	shaft = motor_shaft_size + 2 * printer_slop;

	color("Salmon") render(convexity=10) union() {
		difference() {
			// Herringbone gear
			mirror_copy([0, 0, 1]) {
				translate([0, 0, h/4]) {
					gear (
						mm_per_tooth    = rack_tooth_size,
						number_of_teeth = 9,
						thickness       = h/2,
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
				cylinder(h=h, r=shaft, center=true);

				// Base
				translate([0, 0, -(h+11)/2])
					cylinder(h=11, r=9, center=true);
			}

			difference() {
				// Shaft hole
				cylinder(h=(h+5)*3, r=shaft/2, center=true, $fn=16);

				if (motor_shaft_flatted) {
					// Shaft flat side.
					translate([1.4*shaft, 0, 0])
						cube(size=[shaft*2, shaft*2, (h+6)*3], center=true);
				}
			}

			translate([motor_shaft_size/2+1.5, 0, -(h/2+5+11)/2]) {
				yrot(90) {
					// Nut Slot
					scale([1.1, 1.1, 1.1]) hull() {
						metric_nut(size=set_screw_size, hole=false);
						translate([5, 0, 0])
							metric_nut(size=set_screw_size, hole=false);
					}

					// Set screw hole.
					translate([0, 0, 2])
						cylinder(r=(set_screw_size+printer_slop)/2, h=9, center=true, $fn=8);
				}
			}
		}
	}
}
//!drive_gear();


module drive_gear_parts() { // make me
	translate([0, 0, 5+7])
		circle_of(r=15, n=2)
			drive_gear();
}



drive_gear_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

