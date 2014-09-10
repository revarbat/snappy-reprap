include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module lifter_rod_coupler()
{
	h = 50;
	set_screw_rad = set_screw_size/2 + printer_slop;
	shaft = motor_shaft_size + printer_slop;

	color("Lavender") difference() {
		// Coupler cylinder.
		cylinder(h=h, r=12, center=true);

		translate([0, 0, -(h/4+1)]) {
			difference() {
				// Stepper shaft hole
				cylinder(h=h/2, r=shaft/2, center=true, $fn=16);

				if (motor_shaft_flatted == true) {
					// Shaft flat side.
					translate([1.4*shaft, 0, 0])
						cube(size=[shaft*2, shaft*2, h/2+1], center=true);
				}
			}

			//Stepper set screw
			translate([5/2+2, 0, -(h/4-7.5)]) {
				yrot(90) {
					// Nut Slot
					translate([0, 0, 1]) scale([1.1, 1.1, 1.1]) hull() {
						metric_nut(size=set_screw_size, hole=false);
						translate([10, 0, 0])
							metric_nut(size=set_screw_size, hole=false);
					}

					// Set screw hole.
					translate([0, 0, 2.5])
						cylinder(r=set_screw_rad, h=12, center=true, $fn=8);
				}
			}
		}

		translate([0, 0, (h/4+1)]) {
			// Lifter rod hole.
			cylinder(h=h/2, r=lifter_rod_diam/2+0.2, center=true, $fn=24);

			//Lifter rod set screw
			translate([5/2+3, 0, (h/4-7.5)]) {
				yrot(90) {
					// Nut Slot
					translate([0, 0, 1]) scale([1.1, 1.1, 1.1]) hull() {
						metric_nut(size=set_screw_size, hole=false);
						translate([-10, 0, 0])
							metric_nut(size=set_screw_size, hole=false);
					}

					// Set screw hole.
					translate([0, 0, 2.5])
						cylinder(r=set_screw_rad, h=10, center=true, $fn=8);
				}
			}
		}
	}
}
//!lifter_rod_coupler();



module lifter_rod_couple_parts() { // make me
	lifter_rod_coupler();
}



lifter_rod_couple_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

