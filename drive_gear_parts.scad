include <config.scad>
use <GDMUtils.scad>
use <publicDomainGearV1.1.scad>


$fa = 2;
$fs = 2;

module drive_gear() {
	shaft = motor_shaft_size + printer_slop;
	rack_module = rack_tooth_size / pi;
	gear_pcd = gear_teeth * rack_module;
	addendum = rack_module;
	dedendum = rack_module * 1.25;
	gear_id = gear_pcd - 2*dedendum;
	gear_od = gear_pcd + 2*addendum;
	CA = 30;
	twist = 360*0.5*rack_height*tan(CA) / (gear_pcd * pi);
	base = gear_base - 1;

	color("Salmon")
	prerender(convexity=10)
	difference() {
		union() {
			up(base+rack_height/2-0.05) {
				difference() {
					// Herringbone gear
					zflip_copy() {
						up(rack_height/2/2) {
							gear (
								mm_per_tooth    = rack_tooth_size,
								number_of_teeth = gear_teeth,
								thickness       = rack_height/2,
								hole_diameter   = shaft/2,
								twist           = twist,
								teeth_to_hide   = 0,
								pressure_angle  = 20,
								backlash        = gear_backlash
							);
						}
					}

					// Bevel end of gear.
					up(rack_height/2) {
						zflip() {
							difference() {
								down(0.01) cylinder(h=1, d=gear_od+2, center=false);
								cylinder(h=1, d1=gear_id, d2=gear_od, center=false);
							}
						}
					}
				}
			}

			up(base/2) {
				difference() {
					// Gear Base
					cylinder(h=base, d=max(18,gear_od), center=true);

					right(motor_shaft_size/2+1.5) {
						yrot(90) {
							// Nut Slot
							scale([1.1, 1.1, 1.1]) hull() {
								metric_nut(size=set_screw_size, hole=false);
								right(base/2) metric_nut(size=set_screw_size, hole=false);
							}

							// Set screw hole.
							down(4) cylinder(d=set_screw_size+printer_slop, h=30, $fn=18);

							// Screw head clearance
							up(6) cylinder(d=set_screw_size*2+printer_slop, h=30, $fn=18);
						}
					}
				}
			}
		}


		down(0.01) {
			difference() {
				union() {
					// Shaft hole
					cylinder(h=rack_height+base, d=shaft, center=false, $fn=18);

					// chamfer bottom of shaft hole.
					down(0.01) {
						cylinder(h=2, d1=shaft+2, d2=shaft, center=false, $fn=18);
					}
				}

				// Shaft flat side.
				if (motor_shaft_flatted) {
					right(1.4*shaft)
						cube(size=[shaft*2, shaft*2, (rack_height+base)*3], center=true);
				}
			}
		}
	}
}
//!drive_gear();


module drive_gear_parts() { // make me
	drive_gear();
}



drive_gear_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
