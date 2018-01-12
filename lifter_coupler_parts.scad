include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>
use <lifter_rod_parts.scad>

$fa=2;
$fs=1.5;


// Child 0: Top of coupler.
// Child 1: Nut slot
// Child 2: Bolt hole
module lifter_coupler() {
	h = lifter_coupler_len;
	d = lifter_rod_diam;
	shaft = motor_shaft_size;
	thread_depth = lifter_rod_pitch/3.2;
	difference() {
		union() {
			// Body
			cylinder(d=d, h=h, center=false);

			// Top tang
			up(h-0.01) zrot(90) lifter_tang(d=d-thread_depth*2-6, w=lifter_tang_width, h=lifter_tang_length);
		}

		down(0.01) {
			difference() {
				union() {
					// Shaft hole
					cylinder(h=2*h+0.02, d=shaft, center=false, $fn=18);

					// chamfer bottom of shaft hole.
					down(0.01) {
						cylinder(h=2, d1=shaft+2, d2=shaft, center=false, $fn=18);
					}
				}

				// Shaft flat side.
				if (motor_shaft_flatted) {
					right(1.4*shaft) {
						cube(size=[shaft*2, shaft*2, h*5], center=true);
					}
				}
			}
		}

		up(5) {
			right(motor_shaft_size/2+1.5) {
				// Nut Slot
				scale([1.1, 1.04, 1.04]) hull() {
					yrot(90) metric_nut(size=set_screw_size, hole=false);
					down(h/2) yrot(90) metric_nut(size=set_screw_size, hole=false);
				}

				// Set screw hole.
				left(4) yrot(90) cylinder(d=set_screw_size+printer_slop, h=30, center=false, $fn=18);

				// Screw head clearance
				right(6) yrot(90) cylinder(d=set_screw_size*2+printer_slop, h=30, center=false, $fn=18);
			}
		}
	}
	if ($children > 0) up(h) zrot(90) children(0);
	if ($children > 1) up(5) right(motor_shaft_size/2+1.5) children(1);
	if ($children > 2) up(5) right(motor_shaft_size/2+1.5+6) children(2);
}


module lifter_coupler_parts() { // make me
	lifter_coupler();
}
lifter_coupler_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
