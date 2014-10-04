include <config.scad>
use <GDMUtils.scad>



module lock_tab(h=30, wall=3, slop=0.0)
{
	s1 = 2*wall-slop/2;
	s2 = wall-slop/2;
	ang = atan(((s1-s2)/2)/(h-2));
	translate([0, -(1.5*wall), 0]) union () {
		intersection() {
			yrot( ang) translate([0,0,(h+5)/2])
				cube(size=[s1*2, wall-2*slop, h+10], center=true);
			yrot(-ang) translate([0,0,(h+5)/2])
				cube(size=[s1*2, wall-2*slop, h+10], center=true);
			translate([0,0,(h-wall-slop)/2])
				cube(size=[s1*2, wall-2*slop, h-wall-slop+0.05], center=true);
		}
	}
	translate([0, -(wall+slop/2)/2-0.05, (h-wall-slop)/2])
		cube(size=[wall-2*slop, wall+slop/2+0.1, h-wall-slop+0.05], center=true);
}
//lock_tab(h=30, wall=2, slop=-0.9);



module lock_slot(h=30, wall=3, backing=0, slop=printer_slop)
{
	s1 = 2*wall+slop/2;
	s2 = wall+slop/2;
	w = 2*s1+2*wall;
	d = wall*3+slop;
	ang = atan(((s1-s2)/2)/(h-2));
	translate([0, (d+backing)/2, 0]) {
		difference() {
			intersection() {
				yrot( ang) translate([0, 0, (h+5)/2])
					cube(size=[w, d+backing, h+10], center=true);
				yrot(-ang) translate([0, 0, (h+5)/2])
					cube(size=[w, d+backing, h+10], center=true);
				translate([0, 0, h/2])
					cube(size=[w, d+backing, h], center=true);
			}
			translate([0, (d+backing)/2+0.05, -0.05]) {
				lock_tab(h=h, wall=wall, slop=-slop);
			}
			translate([0, (d+backing-wall*0.75)/2, 0]) {
				scale([1,1,2]) {
					yrot(45) cube(size=[wall*3, wall*1.1, wall*3], center=true);
				}
			}
		}
	}
}
//!lock_slot(h=30, wall=2, slop=0.5);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

