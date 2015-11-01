include <config.scad>
use <GDMUtils.scad>
use <publicDomainGearV1.1.scad>


$fa = 2;
$fs = 2;

module drive_gear() {
	pi = 3.1415926535;
	shaft = motor_shaft_size + printer_slop;
	rack_module = rack_tooth_size / pi;
	gear_pcd = gear_teeth * rack_module;
	addendum = rack_module;
	dedendum = (2.4*rack_module) - addendum;
	gear_id = gear_pcd - 2*dedendum;
	gear_od = gear_pcd + 2*addendum;
	CA = 30;
	twist = 360*0.5*rack_height*tan(CA) / (gear_pcd * pi);

	color("Salmon")
	prerender(convexity=10)
	union() {
		difference() {
			// Herringbone gear
			zflip_copy() {
				up(rack_height/2/2) {
					gear (
						mm_per_tooth    = rack_tooth_size,
						number_of_teeth = gear_teeth,
						thickness       = rack_height/2,
						hole_diameter   = shaft,
						twist           = twist,
						teeth_to_hide   = 0,
						pressure_angle  = 20,
						backlash        = gear_backlash
					);
				}
			}

			// Bevel end of gear.
			up(rack_height/2) {
				difference() {
					down(3/2-1) cylinder(h=3, d=gear_od+2, center=true);
					down(2/2) cylinder(h=2+0.05, d1=gear_od, d2=gear_id, center=true);
				}
			}
		}
		difference() {
			union() {
				// Fix up gear weirdness with solid center.
				cylinder(h=rack_height, d=gear_id, center=true);

				// Base
				down((rack_height+10)/2)
					cylinder(h=gear_base, d=max(18,gear_od), center=true);
			}

			difference() {
				// Shaft hole
				cylinder(h=(rack_height+gear_base)*3, r=shaft/2, center=true, $fn=24);

				if (motor_shaft_flatted) {
					// Shaft flat side.
					right(1.4*shaft)
						cube(size=[shaft*2, shaft*2, (rack_height+gear_base)*3], center=true);
				}
			}

			// chamfer bottom of shaft hole.
			down(rack_height/2+10) {
				cylinder(h=4, d1=shaft+3, d2=shaft-1, center=true);
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
						down(4) zrot(10) cylinder(r=set_screw_size/2+printer_slop, h=30, $fn=16);
					}
				}
			}
		}
	}
}
//!drive_gear();


module drive_gear_parts() { // make me
	up(gear_base+rack_height/2) {
		xspread(30) drive_gear();
	}
}



drive_gear_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
