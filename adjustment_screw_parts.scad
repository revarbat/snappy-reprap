include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>

$fa=2;
$fs=1;

module adjustment_screw(slop=0) {
	d = adjust_screw_diam+slop;
	h = adjust_screw_length;
	pitch = adjust_screw_pitch;
	pa = adjust_screw_angle;
	knob_h = adjust_screw_knob_h;
	knob_d = adjust_screw_knob_d;
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
			}
		}

		// Screw head
		down(h/2-knob_h/2) {
			difference() {
				cylinder(h=knob_h, d=knob_d, center=true);
				down(knob_h/2) cube([knob_d+1, slot_w, knob_h], center=true);
				//down(3) cylinder(h=knob_h, d=floor(knob_d*0.5)/cos(360/6/2), center=true, $fn=6);
			}
		}
	}
}
//!adjustment_screw();


module test_nut(slop=0) {
	d = adjust_screw_diam+slop;
	pitch = adjust_screw_pitch;
	nut_h = adjust_screw_diam;
	nut_d = 16/cos(360/6/2);
	difference() {
		cylinder(d=nut_d, h=nut_h, center=false, $fn=6);
		down(5+1) adjustment_screw(slop=slop);
		down(5+1+printer_slop) adjustment_screw(slop=slop);
		up(adjust_thread_depth/2) cylinder(d1=d+1, d2=d-2*adjust_thread_depth, h=adjust_thread_depth+1/2+0.05, center=true);
		up(nut_h-adjust_thread_depth/2) cylinder(d1=d-2*adjust_thread_depth, d2=d+1, h=adjust_thread_depth+1/2+0.05, center=true);
	}
}


module adjustment_screw_parts() { // make me
	adjustment_screw();
	//right(20) test_nut(slop=2*printer_slop);
}
adjustment_screw_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
