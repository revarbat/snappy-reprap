include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>

$fa=2;
$fs=1.5;


module lifter_tang(d, h, inset=0) {
	m = 1/sqrt(2);
	a = atan2(inset/2,h);
	difference() {
		zrot(45) trapezoid([d*m, d*m], [d*m-inset, d*m-inset], h=h);
		fwd(d*m*0.45) xrot(-a) fwd(d*m/2) cube([d*m, d*m, h*10], center=true);
	}
}


// Child 0: Top of rod.
// Child 1: Bottom of rod.
module lifter_rod() {
	d = lifter_rod_diam;
	h = ceil(lifter_rod_length/lifter_rod_pitch)*lifter_rod_pitch-printer_slop;
	thread_depth = lifter_rod_pitch/3.2;
	pitch = lifter_rod_pitch;
	pa = lifter_rod_angle;
	up(h/2) {
		difference() {
			union() {
				// Threads and body.
				acme_threaded_rod(d=d, l=h, thread_depth=thread_depth, pitch=pitch, thread_angle=pa);

				up(h/2-0.01) {
					difference() {
						// Top tang
						lifter_tang(d=d-thread_depth*2-6.25, h=lifter_tang_length);

						// Strengthening cleavage.
						lifter_tang(d=d-thread_depth*2-12.25, h=lifter_tang_length+0.01);
					}
				}
			}

			// Bottom socket
			down(h/2+0.01) lifter_tang(d=d-thread_depth*2-6+2*printer_slop, h=lifter_tang_length+1);

			// Bevel bottom tang socket
			down(h/2+0.01) lifter_tang(d=d-thread_depth*2-4+2*printer_slop, h=2, inset=2.25);

			// Hollow out body for strength
			up(lifter_tang_length/2-3/2-0.01) cylinder(d=d-thread_depth*2-4, h=h-3-lifter_tang_length, center=true);
		}
	}
	if ($children > 0) up(h) children(0);
	if ($children > 1) children(1);
}
//!lifter_rod(d=20, h=20, thread_depth=3, pitch=8);


module lifter_rod_parts() { // make me
	lifter_rod();
}
lifter_rod_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
