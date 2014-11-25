include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>

cable_chain_height = 13;  // mm
cable_chain_width  = 22;  // mm
cable_chain_length = 26;  // mm
cable_chain_pivot   = 6;  // mm
cable_chain_bump    = 1;  // mm
cable_chain_wall    = 3;  // mm

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
				translate([w/2-3*cable_chain_wall/2-printer_slop, -l/4, h/2]) {
					cube(size=[cable_chain_wall, l/2, h], center=true);
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

					// Pivot bump
					translate([-cable_chain_wall/2-cable_chain_bump/2, l/2-h/3, 0])
						yrot(90) cylinder(h=cable_chain_bump, r1=r, r2=r+cable_chain_bump, center=true, $fn=32);
				}
			}

			// Chamfer top back
			translate([0, l/2, h]) {
				xrot(45) cube(size=[w+2, h/3*sqrt(2), h/3*sqrt(2)], center=true);
				scale([1, tan(20), 1]) xrot(45) cube(size=[w+2, h/2*sqrt(2), h/2*sqrt(2)], center=true);
			}
		}
	}
}
//!cable_chain_mount2();


module cable_chain_link()
{
	color("SpringGreen")
	union () {
		cable_chain_mount1();
		cable_chain_barrel();
		cable_chain_mount2();
	}
}
//!cable_chain_link();


module cable_chain_mount()
{
	joiner_length=10;
	color("SpringGreen")
	union () {
		translate([0, -2, 0]) {
			cable_chain_mount1();
			cable_chain_barrel();
		}
		translate([0, 2, 0]) {
			cable_chain_barrel();
			cable_chain_mount2();
		}
		translate([(joiner_length+cable_chain_width/2-3), 0, rail_height/4]) {
			zrot(-90) {
				half_joiner(h=rail_height/2, w=joiner_width, l=joiner_length, a=joiner_angle);
			}
		}
	}
}
//!cable_chain_mount();


module cable_chain_link_parts() { // make me
	translate([0, -20, 0]) {
		grid_of(count=[5, 4], spacing=[23, 27]) {
			cable_chain_link();
		}
	}
	translate([12, 40, 0]) {
		grid_of(count=2, spacing=46) {
			zrot(180) cable_chain_mount();
		}
	}
}


cable_chain_link_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

