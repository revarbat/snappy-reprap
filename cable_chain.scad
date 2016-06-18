include <config.scad>
use <GDMUtils.scad>


module cable_chain_barrel()
{
	h = cable_chain_height;
	w = cable_chain_width;
	l = cable_chain_length;
	r = cable_chain_pivot/2;

	color("SpringGreen")
	union () {
		difference() {
			translate([0, 0, h/2])
				cube(size=[w, l-20, h], center=true);
			translate([0, 0, h/2])
				chamfcube(size=[w-4*cable_chain_wall, l, h-cable_chain_wall], chamfer=2, center=true);
			zrot(40)
				cube(size=[2, (l-15)/cos(40), 2*cable_chain_wall], center=true);
		}
	}
}
//!cable_chain_barrel();


module cable_chain_mount1()
{
	h = cable_chain_height;
	w = cable_chain_width;
	l = cable_chain_length;
	r = cable_chain_pivot/2;

	color("SpringGreen")
	union () {
		difference() {
			// Sides and tabs
			mirror_copy([1,0,0]) {
				translate([w/2-3*cable_chain_wall/2-printer_slop/2, -l/4, h/2]) {
					cube(size=[cable_chain_wall-printer_slop, l/2, h], center=true);
				}
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
				translate([(w-cable_chain_wall)/2, 0, h/2]) {
					translate([-cable_chain_wall/2-cable_chain_bump/2, -l/2+r+2.75-printer_slop, 0]) {
						yrot(90) cylinder(h=cable_chain_bump+0.05, r1=r, r2=r+cable_chain_bump, center=true, $fn=32);
					}
				}
			}
		}
	}
}
//!cable_chain_mount1();


module cable_chain_mount2()
{
	h = cable_chain_height;
	w = cable_chain_width;
	l = cable_chain_length;
	r = cable_chain_pivot/2;

	color("SpringGreen")
	union () {
		difference() {
			// Sides and tabs
			mirror_copy([1,0,0]) {
				translate([(w-cable_chain_wall)/2, 0, h/2]) {
					translate([0, l/4, 0])
						cube(size=[cable_chain_wall, l/2, h], center=true);

					translate([0, l/2-h/3, 0])
						yrot(90) cylinder(h=cable_chain_wall, r=cable_chain_pivot/2+1.333, center=true, $fn=64);

					// Pivot bump
					translate([-cable_chain_wall/2-cable_chain_bump/2, l/2-h/3, 0])
						yrot(90) cylinder(h=cable_chain_bump, r1=r, r2=r+cable_chain_bump, center=true, $fn=32);
				}
			}

			// Chamfer top back
			translate([0, l/2, h]) {
				for (ang = [5:10:45]) {
					scale([1, sin(ang), cos(ang)]) xrot(45) cube(size=[w+2, h/2*sqrt(2), h/2*sqrt(2)], center=true);
				}
			}
		}
	}
}
//!cable_chain_mount2();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

