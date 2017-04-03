include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>

$fa=2;
$fs=2;

module lifter_screw() {
	d = lifter_screw_diam;
	h = lifter_screw_thick;
	thread_depth = lifter_screw_pitch/3.2;
	pitch = lifter_screw_pitch;
	pa = lifter_screw_angle;
	up(h/2) {
		difference() {
			// Threads and body.
			union() {
				acme_threaded_rod(d=d, l=h, thread_depth=thread_depth, pitch=pitch, thread_angle=pa);
				up(2/2) cylinder(h=h+2, d=motor_shaft_size+15, center=true);
			}

			// Motor shaft hole.
			difference() {
				cylinder(h=h+10, d=motor_shaft_size+2*printer_slop, center=true, $fn=24);
				if (motor_shaft_flatted) {
					left(motor_shaft_size-0.5) {
						cube(size=[motor_shaft_size, motor_shaft_size, h+10.05], center=true);
					}
				}
			}

			// Bevel motor shaft bottom.
			down(h/2-2/2) cylinder(h=2+0.05, d1=motor_shaft_size+2, d2=motor_shaft_size, center=true);

			// Bevel motor shaft top.
			up(h/2+2-2/2) {
				difference() {
					cylinder(h=2+0.05, d1=motor_shaft_size, d2=motor_shaft_size+2, center=true);
					left(motor_shaft_size-0.5) {
						cube(size=[motor_shaft_size, 2*motor_shaft_size, h+10.05], center=true);
					}
				}
			}

			// Hollow out body.
			up(3) {
				difference() {
					cylinder(h=h+0.1, d=d-2*thread_depth-5, center=true);
					cylinder(h=h+0.1, d=motor_shaft_size+12, center=true);
				}
			}

			// Ring of finger-grip holes.
			hole_diam = (d-2*thread_depth-5-(motor_shaft_size+12))/2 - 2;
			down(h/2-3/2) {
				zrot(360/5/2) {
					zring(r=(d-2*thread_depth-5+motor_shaft_size+12)/2/2, n=5) {
						cylinder(d=hole_diam, h=3.1, center=true);
						zflip_copy() down(3/2+0.05) cylinder(d1=hole_diam+2, d2=hole_diam, h=1, center=false);
					}
				}
			}

			up(h/2-1) {
				// Clear space for optional nut holder.
				left(motor_shaft_size/2+1) {
					hull() {
						up(h/4/2) {
							zspread(h/4) {
								scale([1.1, 1.1, 1.1]) {
									zrot(180) yrot(90) metric_nut(size=set_screw_size, hole=false);
								}
							}
						}
					}
				}

				// Clear space for optional screw.
				yrot(-90) cylinder(h=150, d=set_screw_size*1.05, center=false, $fn=12);
			}

			// Bevel thread ends.
			zflip_copy() {
				down(h/2+0.05) {
					difference() {
						cylinder(d=d+1, h=2, center=false);
						down(0.05) cylinder(d1=d-4, d2=d, h=2.1, center=false);
					}
				}
			}
		}
	}
}
//!lifter_screw(d=20, h=20, thread_depth=3, pitch=8);

module lifter_screw_parts() { // make me
	lifter_screw();
}
lifter_screw_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
