include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>


$fa = 2;
$fs = 1.5;

width = extruder_shaft_len/2;
thick = 3.5;
topthick = 5;
motor_width = nema_motor_width(17);
frontside = (jhead_barrel_diam+8)/2+4;
backside = (jhead_barrel_diam+8)/2+8;
topside = motor_width*0.25+topthick;
botside = motor_width/2+jhead_shelf_thick-thick;


module extruder_idler()
{
	color("Tan")
	prerender(convexity=10)
	difference() {
		union() {
			// Top bar
			up(topside-topthick/2) {
				back((frontside+backside)/2-frontside) {
					cube([width, frontside+backside, topthick], center=true);
				}
			}

			// Vertical bar
			back(backside-thick/2) {
				up((topside+botside+5)/2-botside) {
					cube([width, thick, topside+botside+5], center=true);
				}
			}

			// bearing supports
			back((backside-extruder_idler_diam/2+extruder_idler_axle/3)/2+(extruder_idler_diam/2-extruder_idler_axle/3)) {
				up(topside/4) {
					difference() {
						cube([width, backside-extruder_idler_diam/2+extruder_idler_axle/3+0.05, extruder_idler_diam*2/3/2+topside], center=true);
						down((extruder_idler_diam*2/3/2+topside)/2) {
							fwd((backside-extruder_idler_diam/2+extruder_idler_axle/3)/2) {
								xrot(45) cube([width+0.05, extruder_idler_diam/6, extruder_idler_diam/6], center=true);
							}
						}
					}
				}
			}

			// Bottom clip
			down(botside) {
				back(backside-thick) {
					difference() {
						xrot(-45) {
							union() {
								yrot(90) cylinder(r=thick, h=width, center=true, $fs=1);
								up(thick) cube([width, thick*2, thick*2], center=true);
							}
						}
						back(3*thick) cube([width+1, 4*thick, 4*thick], center=true);
					}
				}
			}
		}

		// Filament hole
		cylinder(d=filament_diam*2, h=100, $fn=12);

		// spring/rubber-band mount hole
		fwd(frontside-6) {
			cube([width-5, 6, 100], center=true);
		}

		// Clearance for idler bearing
		back(extruder_idler_diam/2) {
			yrot(90) cylinder(d=extruder_idler_axle, h=extruder_idler_width+10, center=true, $fs=1);
			yrot(90) cylinder(d=extruder_idler_diam+2, h=extruder_idler_width+printer_slop, center=true, $fs=1);
			difference() {
				yrot(90) cylinder(d=extruder_idler_diam+2, h=extruder_idler_width+1, center=true, $fs=1);
				yrot(90) cylinder(d=extruder_idler_axle+4, h=extruder_idler_width+1.1, center=true, $fs=1);
			}
		}
	}
}
//!extruder_idler();


module extruder_latch()
{
	color([0.6, 0.4, 0.0])
	prerender(convexity=10)
	difference() {
		union() {
			// Top bar
			up(topside+topthick/2-1) {
				fwd(backside-10/2) {
					cube([width, 10, topthick], center=true);
					down(topthick/2+1/2-0.05) {
						back(10/2) {
							front_half() {
								trapezoid([width-6, 2], [width-6, 6], h=1, center=true);
							}
						}
					}
				}
			}

			// Vertical bar
			fwd(backside-thick/2) {
				up((topside+botside+5)/2-botside) {
					cube([width, thick, topside+botside+5], center=true);
				}
			}

			// Bottom clip
			down(botside) {
				fwd(backside-thick) {
					difference() {
						xrot(45) {
							union() {
								yrot(90) cylinder(r=thick, h=width, center=true, $fs=1);
								up(thick) cube([width, thick*2, thick*2], center=true);
							}
						}
						fwd(3*thick) cube([width+1, 4*thick, 4*thick], center=true);
					}
				}
			}
		}
	}
}
//!extruder_latch();


module idler_bearing()
{
	difference() {
		union() {
			color("silver") {
				difference() {
					yrot(90) cylinder(d=extruder_idler_diam, h=extruder_idler_width, center=true);
					yrot(90) cylinder(d=extruder_idler_diam-2, h=extruder_idler_width+1, center=true);
				}
			}
			color("darkgray") {
				yrot(90) cylinder(d=extruder_idler_diam-0.5, h=extruder_idler_width-0.5, center=true);
			}
			color("silver") {
				yrot(90) cylinder(d=extruder_idler_axle+2, h=extruder_idler_width, center=true);
			}
		}
		color("silver") {
			yrot(90) cylinder(d=extruder_idler_axle, h=extruder_idler_width+10, center=true);
		}
	}
}
//!idler_bearing();


module extruder_idler_axle() {
	color("Tan") {
		cylinder(h=1, d=extruder_idler_axle+2);
		up(1-0.05) {
			difference() {
				cylinder(h=width+0.05, d=extruder_idler_axle);
				up(width*3/4) {
					cylinder(h=width+0.1, d1=extruder_idler_axle-2.5, d2=extruder_idler_axle-2, $fn=8);
				}
				cylinder(h=width+2, d=2);
			}
		}
	}
}
//!extruder_idler_axle();



module extruder_idler_axle_cap() {
	color("Tan") {
		cylinder(h=1, d=extruder_idler_axle+2);
		up(1-0.1) cylinder(h=width/4, d1=extruder_idler_axle-2, d2=extruder_idler_axle-2.5, $fn=8);
	}
}
//!extruder_idler_axle_cap();



module extruder_idler_parts() { // make me
	up(backside) {
		right(10) xrot(-90) extruder_idler();
		left(10) xrot(90) extruder_latch();
	}
	left(30) extruder_idler_axle();
	right(30) extruder_idler_axle_cap();
}



extruder_idler_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
