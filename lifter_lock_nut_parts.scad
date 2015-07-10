include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>


$fa = 1;
$fs = 1;

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
	}
}
//!lifter_lock_nut();


module lifter_lock_nut_parts() { // make me
	yspread(30) up(10/2) lifter_lock_nut();
}


lifter_lock_nut_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
