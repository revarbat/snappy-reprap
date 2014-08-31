include <config.scad>
use <GDMUtils.scad>


module joiner(h=40, w=10, l=10, a=30, screwsize=3, guides=true)
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
						cube(size=[w/3-joiner_slop, dmnd_width/2, dmnd_height], center=true);
					scale([w/3-joiner_slop, dmnd_width/2, dmnd_height/2]) xrot(45)
						cube(size=[1,sqrt(2),sqrt(2)], center=true);
				}

				// Guide ridges.
				if (guides == true) {
					translate([0,0,dmnd_height/2]) {
						grid_of(xa=[-(w/6-joiner_slop/2), (w/6-joiner_slop/2)]) {
							scale([0.75, 1, 2]) yrot(45)
								cube(size=[guide_size/sqrt(2), dmnd_width, guide_size/sqrt(2)], center=true);
							scale([0.5, 0.5, 1]) zrot(45)
								cube(size=[guide_size/sqrt(2), guide_size/sqrt(2), dmnd_width], center=true);
						}
					}
				}
			}

			// Make slot
			translate([0, 0, -dmnd_height/2]) {
				translate([0, dmnd_width/4, 0])
					cube(size=[w/3, dmnd_width/2, dmnd_height], center=true);
				scale([w/3, dmnd_width/2, dmnd_height/2]) xrot(45)
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
					grid_of(xa=[-(w/6),(w/6)]) {
						scale([0.75, 1, 2]) yrot(45)
							cube(size=[guide_size/sqrt(2), dmnd_width*1.1, guide_size/sqrt(2)], center=true);
						scale([0.5, 0.5, 1]) zrot(45)
							cube(size=[guide_size/sqrt(2), guide_size/sqrt(2), dmnd_width], center=true);
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



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

