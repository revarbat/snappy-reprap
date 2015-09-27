include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>


$fa = 2;
$fs = 2;

module lifter_lock_nut()
{
	height = 10;
	diam = ceil(lifter_rod_diam/5+2)*5;

	color("SpringGreen")
	difference () {
		cylinder(h=height, d=diam, center=true, $fn=6);
		acme_threaded_rod(
			d=lifter_rod_diam+2*printer_slop,
			l=height+0.1,
			pitch=lifter_rod_pitch,
			thread_depth=lifter_rod_pitch/4
		);
		zflip_copy() {
			down(10/2-1/2) {
				cylinder(h=1.05, d1=lifter_rod_diam+1, d2=lifter_rod_diam-lifter_rod_pitch/4, center=true);
			}
		}
	}
}
//!lifter_lock_nut();


module lifter_lock_nut_parts() { // make me
	yspread(30) up(10/2) lifter_lock_nut();
}


lifter_lock_nut_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
