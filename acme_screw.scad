include <config.scad>
use <GDMUtils.scad>


module acme_threaded_rod(
	d=10.5,
	l=100,
	threading=3.175,
	thread_depth=1
) {
	r = d/2;
	twists = l/threading;
	linear_extrude(
		height=l,
		convexity=20,
		twist=-360*twists,
		slices=12*twists,
		center=true
	) {
		union() {
			circle(r=r-thread_depth, center=true);
			difference() {
				circle(r=r, center=true);
				translate([r/2, 0]) {
					square([r, r*2], center=true);
				}
			}
		}
	}
}


module acme_threaded_nut(
	od=17.4,
	id=10.5,
	h=10,
	threading=3.175,
	thread_depth=1,
	slop=printer_slop
) {
	difference() {
		cylinder(r=od/2/cos(30), h=h, center=true, $fn=6);
		grid_of(za=[-slop/2,slop/2]) {
			acme_threaded_rod(d=id+2*slop, l=h+1, threading=threading, thread_depth=thread_depth);
		}
	}
}


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
