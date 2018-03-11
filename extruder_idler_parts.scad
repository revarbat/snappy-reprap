include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <acme_screw.scad>
use <joiners.scad>


$fa = 2;
$fs = 1;


width = extruder_shaft_len/2;
thick = 3.5;
topthick = 5;
frontside = 4;
backside = 20;


module extruder_idler()
{
	motor_width = nema_motor_width(17);
	botside = motor_width/2+5-thick;
	topside = motor_width*0.25+topthick;

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

		// Clearance for idler bearing
		back(extruder_idler_diam/2) {
			yrot(90) cylinder(d=extruder_idler_axle, h=extruder_idler_width+10, center=true, $fs=1);
			yrot(90) cylinder(d=extruder_idler_diam+2, h=extruder_idler_width+printer_slop, center=true, $fs=1);
			difference() {
				yrot(90) cylinder(d=extruder_idler_diam+2, h=extruder_idler_width+1, center=true, $fs=1);
				yrot(90) cylinder(d=extruder_idler_axle+4, h=extruder_idler_width+1.1, center=true, $fs=1);
			}
		}

		// Strengthening holes
		up(topside/2-3) {
			back(backside-thick/2) {
				zspread(3, n=6) {
					xspread(3, n=floor(width/3)-1) {
						xrot(90) cylinder(d=0.5, h=thick+1, center=true, $fn=3);
					}
				}
			}
		}
	}
}
//!extruder_idler();



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
				cylinder(h=width+printer_slop*2+2.5, d=extruder_idler_axle);
				up(width+printer_slop*2) {
					extruder_idler_axle_clip();
				}
			}
		}
	}
}
//!extruder_idler_axle();



module extruder_idler_axle_clip() {
	color("Tan") {
		difference() {
			cylinder(h=2, d=extruder_idler_axle+4);
			down(0.05) {
				cylinder(h=2.1, d1=extruder_idler_axle-2, d2=extruder_idler_axle);
				hull() {
					cylinder(h=2.1, d1=extruder_idler_axle-3, d2=extruder_idler_axle-0.5);
					left(5) cylinder(h=2.1, d1=extruder_idler_axle-3, d2=extruder_idler_axle-0.5);
				}
				left(extruder_idler_axle*1.5) cube(size=2*extruder_idler_axle, center=true);
			}
		}
	}
}
//!extruder_idler_axle_clip();


module extruder_idler_parts() { // make me
	up(backside) xrot(-90) extruder_idler();
	right(15) {
		fwd(10) extruder_idler_axle();
		back(10) extruder_idler_axle_clip();
	}
}


extruder_idler_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
