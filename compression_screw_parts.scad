include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>

$fa=2;
$fs=1;

module compression_screw(slop=0) {
	d = adjust_screw_diam+slop;
	h = adjust_screw_length;
	pitch = adjust_screw_pitch;
	pa = adjust_screw_angle;
	knob_h = adjust_screw_knob_h;
	knob_d = 20;
	slot_w = 2;
	up(h/2) {
		up(knob_h) {
			difference() {
				// Threads
				down(0.05) acme_threaded_rod(d=d, l=h+0.1, thread_depth=adjust_thread_depth, pitch=pitch, thread_angle=pa);

				// Bevel thread ends.
				up(h/2-2+0.05) {
					difference() {
						cylinder(d=d+1, h=2, center=false);
						down(0.05) cylinder(d1=d, d2=d-4, h=2.1, center=false);
					}
				}

				// Strengthening hole
				cylinder(h=2*h, d=0.5, center=true, $fn=3);
			}
		}

		// Screw head
		down(h/2-knob_h/2) {
			difference() {
				cylinder(h=knob_h, d=knob_d, center=true);
				zring(r=knob_d/2+5/4, n=8) cylinder(d=5, h=knob_h*3, center=true);
			}
		}
	}
}
//!compression_screw();


module compression_screw_parts() { // make me
	compression_screw();
}
compression_screw_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
