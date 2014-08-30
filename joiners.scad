include <config.scad>
use <GDMUtils.scad>

module joiner(h=40, w=9, l=10, a=30, screwsize=undef, guides=true)
{
	dmnd_height = h/2;
	dmnd_width = dmnd_height*tan(a);
	guide_size = w/3;

	render(convexity=4) union() {
		difference() {
			union() {
				// Make base.
				difference() {
					union() {
						translate([0,-l/2,0]) cube(size=[w, l, h], center=true);
						translate([0,0,-h/4])
							scale([w, dmnd_width/2, dmnd_height/2])
								xrot(45) cube(size=[1,sqrt(2),sqrt(2)], center=true);
					}
					translate([0,0,h/4])
						scale([w*1.1, dmnd_width/2, dmnd_height/2])
							xrot(45) cube(size=[1,sqrt(2),sqrt(2)], center=true);
				}

				// Make tab
				translate([0,0,dmnd_height/2]) {
					translate([0, -dmnd_width/4, 0])
						cube(size=[w/3, dmnd_width/2, dmnd_height], center=true);
					scale([w/3, dmnd_width/2, dmnd_height/2]) xrot(45)
						cube(size=[1,sqrt(2),sqrt(2)], center=true);
				}

				// Guide ridges.
				if (guides == true) {
					translate([0,0,dmnd_height/2]) {
						grid_of(xa=[-w/6,w/6]) {
							scale([1,1,2]) yrot(45)
								cube(size=[guide_size/sqrt(2), dmnd_width, guide_size/sqrt(2)], center=true);
						}
					}
				}
			}

			// Make slot
			translate([0, 0, -dmnd_height/2]) {
				translate([0, dmnd_width/4, 0])
					cube(size=[w/3+joiner_slop, dmnd_width/2, dmnd_height], center=true);
				scale([w/3+joiner_slop, dmnd_width/2, dmnd_height/2]) xrot(45)
					cube(size=[1,sqrt(2),sqrt(2)], center=true);
			}

			// Blunt point of tab.
			translate([0,(2+dmnd_width/2-guide_size*tan(a)),0])
				cube(size=[w*1.1,4,h], center=true);

			// Make screwholes, if needed.
			if (screwsize != undef) {
				xrot_copies([0, 180])
					translate([0, 0, dmnd_height/2])
						yrot(90) cylinder(r=screwsize*1.1/2, h=w+1, center=true, $fn=12);
			}

			// Guide slots.
			if (guides == true) {
				translate([0,0,-dmnd_height/2]) {
					grid_of(xa=[-(w/6+joiner_slop/2),(w/6+joiner_slop/2)]) {
						scale([1,1,2]) yrot(45)
							cube(size=[guide_size/sqrt(2), dmnd_width*1.1, guide_size/sqrt(2)], center=true);
					}
				}
			}
		}

		// Blunt point of slot.
		translate([0,-(2+dmnd_width/2-guide_size*tan(a)),0])
			cube(size=[w,4,h], center=true);
	}
}
//!joiner(screwsize=3);



module lock_tab(h=30, wall=3, slop=0.0)
{
	s1 = 2*wall-slop/2;
	s2 = wall-slop/2;
	ang = atan(((s1-s2)/2)/(h-2));
	translate([0, -(1.5*wall), 0]) union () {
		intersection() {
			yrot( ang) translate([0,0,(h+5)/2]) cube(size=[s1*2, wall-slop, h+10], center=true);
			yrot(-ang) translate([0,0,(h+5)/2]) cube(size=[s1*2, wall-slop, h+10], center=true);
			translate([0,0,(h-wall-slop)/2]) cube(size=[s1*2, wall-slop, h-wall-slop+0.05], center=true);
		}
	}
	translate([0, -(wall+slop/2)/2-0.05, (h-wall-slop)/2]) cube(size=[wall-slop, wall+slop/2+0.1, h-wall-slop+0.05], center=true);
}
//lock_tab(h=30, wall=2, slop=-0.9);



module lock_slot(h=30, wall=3, backing=0, slop=0.2)
{
	s1 = 2*wall+slop/2;
	s2 = wall+slop/2;
	w = 2*s1+2*wall;
	d = wall*3+slop;
	ang = atan(((s1-s2)/2)/(h-2));
	translate([0, (d+backing)/2, 0]) difference() {
		intersection() {
			yrot( ang) translate([0, 0, (h+5)/2]) cube(size=[w, d+backing, h+10], center=true);
			yrot(-ang) translate([0, 0, (h+5)/2]) cube(size=[w, d+backing, h+10], center=true);
			translate([0, 0, h/2]) cube(size=[w, d+backing, h], center=true);
		}
		translate([0, (d+backing)/2+0.05, -0.05]) lock_tab(h=h, wall=wall, slop=-slop);
	}
}
//!lock_slot(h=30, wall=2, slop=0.1);



module cap(r=roller_axle/2-3, h=10, wall=3, cap=2, lip=2)
{
	difference() {
		union() {
			translate([0,0,-cap/2])
				cylinder(r=r+lip+wall, h=cap, center=true, $fn=32);
			translate([0,0,h*3/8])
				cylinder(r1=r-0.5, r2=r, h=h*3/4, center=true, $fn=32);
			translate([0,0,h*7/8])
				cylinder(r1=r, r2=r-wall/2, h=h*1/4, center=true, $fn=32);
		}
		translate([0,0,h/2+1])
			cylinder(r=r-wall, h=h+1, center=true, $fn=12);
		zrot_copies([0,90]) translate([0,0,h*5/8])
			cube(size=[1,r*2,h],center=true);
	}
}
//cap();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

