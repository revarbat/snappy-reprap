include <config.scad>
use <GDMUtils.scad>

module cable_chain_link()
{
	h = 13;
	w = 22;
	l = 26;
	r = 3;
	bump = 1;
	thick = 3;
	joiner_length=5;

	color("SpringGreen")
	union () {
		// Bottom and top struts
		difference() {
			translate([0, 0, h/2])
				cube(size=[w-2*thick, l-20, h], center=true);
			translate([0, 0, h/2])
				chamfcube(size=[w-3*thick, l, h-thick], chamfer=3, center=true);
		}

		difference() {
			// Sides and tabs
			mirror_copy([1,0,0]) {
				translate([(w-thick)/2, 0, h/2]) {
					translate([-thick, -10/2, 0])
						cube(size=[thick, l-10, h], center=true);
					translate([0, 10/2, 0])
						cube(size=[thick, l-10, h], center=true);

					// Pivot bump
					translate([-thick/2-bump/2, l/2-h/3, 0])
						yrot(90) cylinder(h=bump, r1=r, r2=r+bump, center=true, $fn=32);
				}
			}

			// Chamfer top back
			translate([0, l/2, h]) {
				xrot(45) cube(size=[w+2, h/3*sqrt(2), h/3*sqrt(2)], center=true);
				scale([1, tan(20), 1]) xrot(45) cube(size=[w+2, h/2*sqrt(2), h/2*sqrt(2)], center=true);
			}

			// Chamfer Bottom Front
			translate([0, -l/2, 0]) {
				scale([1, tan(30), 1]) xrot(45) cube(size=[w+2, h/2*sqrt(2), h/2*sqrt(2)], center=true);
			}

			// Round out top front.
			translate([0, -l/2, h]) {
				difference() {
					cube(size=[w+2, h, h], center=true);
					translate([0, h/2, -h/2]) {
						yrot(90) cylinder(h=w+3, r=h/2, center=true, $fn=32);
					}
				}
			}

			// Pivot Divot
			mirror_copy([1,0,0]) {
				translate([(w-thick)/2, 0, h/2]) {
					translate([-thick/2-bump/2, -l/2+r+2.75, 0]) {
						yrot(90) cylinder(h=bump+0.05, r1=r, r2=r+bump, center=true, $fn=32);
					}
				}
			}
		}
	}
}
//!cable_chain_link();


module cable_chain_link_parts() { // make me
	xcount = 4;
	ycount = 4;
	xspacing=25;
	yspacing=30;
	grid_of(
	    xa=[-xspacing*(xcount-1)/2 : xspacing : xspacing*(xcount-1)/2],
	    ya=[-yspacing*(ycount-1)/2 : yspacing : yspacing*(ycount-1)/2]
	) {
		cable_chain_link();
	}
}


cable_chain_link_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

