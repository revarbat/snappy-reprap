include <config.scad>
use <GDMUtils.scad>
use <tslot.scad>


module support_leg(h=30, l=100, wall=3)
{
	ang = atan((h-10)/l);
	color("SandyBrown") union() {
		translate([0, 5/2, h/2])
			cube(size=[platform_length/2+6*wall, 5, h], center=true);
		grid_of(xa=[-platform_length/4, platform_length/4]) {
			lock_tab(h=h, wall=wall);
			translate([0, 0, h]) {
				difference() {
					translate([-wall, 0, -h])
						cube(size=[2*wall, l, h], center=false);
					xrot(-ang) translate([-wall*1.5, 0, 0])
						cube(size=[3*wall, l*sqrt(2), h], center=false);
				}
			}
		}
	}
}
//!support_leg();



module support_leg_part() { // make me
	support_leg();
}



support_leg_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

