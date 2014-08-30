include <config.scad>
use <GDMUtils.scad>
use <tslot.scad>


module testslot(h=30, l=100, wall=3)
{
	ang = atan((h-10)/l);
	union() {
		translate([0, -1, h/2])
			cube(size=[platform_length/2+6*wall, 5, h], center=true);
		grid_of(xa=[-platform_length/4, platform_length/4]) {
			lock_slot(h=h, wall=wall);
		}
	}
}
//!testslot();



module testslot_part() { // make me
	testslot();
}



testslot_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

