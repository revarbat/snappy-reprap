include <config.scad>
use <GDMUtils.scad>


module joiner(h=40, w=10, l=10, a=30, screwsize=3, guides=true)
{
	dmnd_height = h/2;
	dmnd_width = dmnd_height*tan(a);
	guide_size = w/3;
	tip_off = 2+dmnd_width/2-guide_size*tan(a);

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
							// Guide ridge.
							scale([0.75, 1, 2]) yrot(45)
								cube(size=[guide_size/sqrt(2), dmnd_width, guide_size/sqrt(2)], center=true);

							// Snap ridge.
							scale([0.25, 0.5, 1]) zrot(45)
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
			translate([0,tip_off,0])
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
						// Guide slot
						scale([0.75, 1, 2]) yrot(45)
							cube(size=[guide_size/sqrt(2), dmnd_width*1.1, guide_size/sqrt(2)], center=true);

						// Snap hole
						scale([0.25, 0.5, 1]) zrot(45)
							cube(size=[guide_size/sqrt(2), guide_size/sqrt(2), dmnd_width], center=true);
					}
				}
			}
		}

		// Blunt point of slot.
		translate([0,-tip_off,0])
			cube(size=[w,4,h], center=true);
	}
}
//joiner(screwsize=3);



module joiner_clear(h=40, w=10, a=30)
{
	dmnd_height = h/2;
	dmnd_width = dmnd_height*tan(a);
	guide_size = w/3;
	tip_off = 2+dmnd_width/2-guide_size*tan(a);

	difference() {
		// Diamonds.
		grid_of(za=[-h/4,h/4]) {
			scale([w+10, dmnd_width/2, dmnd_height/2]) {
				xrot(45) cube(size=[1,sqrt(2),sqrt(2)], center=true);
			}
		}
		// Blunt point of tab.
		grid_of(ya=[-tip_off, tip_off]) {
			cube(size=[w+10+1, 4, h], center=true);
		}
	}
}
//joiner_clear();



module joiner_pair(spacing=100, h=40, w=10, l=10, a=30, screwsize=3, guides=true)
{
	yrot_copies([0,180]) {
		translate([spacing/2, 0, 0]) {
			joiner(h=h, w=w, l=l, a=a, screwsize=screwsize, guides=guides);
		}
	}
}



module joiner_pair_clear(spacing=100, h=40, w=10, a=30)
{
	yrot_copies([0,180]) {
		translate([spacing/2, 0, 0]) {
			joiner_clear(h=h, w=w, a=a);
		}
	}
}



module joiner_quad(xspacing=100, yspacing=50, h=40, w=10, l=10, a=30, screwsize=3, guides=true)
{
	zrot_copies([0,180]) {
		translate([0, yspacing/2, 0]) {
			joiner_pair(spacing=xspacing, h=h, w=w, l=l, a=a, screwsize=screwsize, guides=guides);
		}
	}
}



module joiner_quad_clear(xspacing=100, yspacing=50, h=40, w=10, a=30)
{
	zrot_copies([0,180]) {
		translate([0, yspacing/2, 0]) {
			joiner_pair_clear(spacing=xspacing, h=h, w=w, a=a);
		}
	}
}



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

