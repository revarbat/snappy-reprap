include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>

$fa=2;
$fs=2;

module lifter_screw(d=50, h=10, thread_depth=3, pitch=10, hole=30, pa=50) {
	up(h/2) {
		difference() {
			union() {
				acme_threaded_rod(d=d, l=h, thread_depth=thread_depth, pitch=pitch, thread_angle=pa);
				up(2/2) cylinder(h=h+2, d=motor_shaft_size+15, center=true);
			}
			difference() {
				cylinder(h=h+10, d=motor_shaft_size+2*printer_slop, center=true, $fn=24);
				if (motor_shaft_flatted) {
					left(motor_shaft_size-0.5) {
						cube(size=[motor_shaft_size, motor_shaft_size, h+10.05], center=true);
					}
				}
			}
			up(3) {
				difference() {
					cylinder(h=h+0.1, d=d-2*thread_depth-5, center=true);
					cylinder(h=h+0.1, d=motor_shaft_size+15, center=true);
				}
			}
			down(h/2-2/2) {
				cylinder(h=2+0.05, d1=motor_shaft_size+2, d2=motor_shaft_size, center=true);
			}
			up(h/2-1) {
				left(motor_shaft_size/2+2) {
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
				yrot(-90) cylinder(h=150, d=set_screw_size*1.05, center=false, $fn=12);
			}
		}
	}
}
//!lifter_screw(d=20, h=20, thread_depth=3, pitch=8);

module lifter_screw_parts() { // make me
	lifter_screw(
		d=lifter_gear_diam,
		h=lifter_gear_thick,
		thread_depth=lifter_gear_pitch/3.2,
		pitch=lifter_gear_pitch,
		pa=lifter_gear_angle
	);
}
lifter_screw_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
