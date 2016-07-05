include <config.scad>
include <GDMUtils.scad>
include <wiring.scad>


$fa = 2;
$fs = 2;


module arrow(size=10, headpart=0.4) {
	color("orange")
	yrot(90) {
		down(size/2)
		union() {
			up(size*headpart/2) cylinder(d1=0, d2=size/2, h=size*headpart, center=true, $fn=18);
			up(size/2+size*headpart/2) cylinder(d=size/6, h=size*(1-headpart), center=true, $fn=18);
		}
	}
}
//!arrow(size=200);


module jhead_hotend()
{
	jhead_length = 40; // mm
	jhead_block_size = [18.7, 16, 9.6];
	jhead_block_off = 7; //mm

	block_h = jhead_block_size[2];
	down(jhead_length/2-jhead_groove_thick-jhead_shelf_thick) {
		color([0.3, 0.3, 0.3])
		difference() {
			cylinder(h=jhead_length, d=jhead_barrel_diam-0.05, center=true);
			cylinder(h=jhead_length+1, d=2, center=true, $fn=12);
			up(4*4/2-jhead_length/2+0.5*25.4) {
				zring(n=4, r=jhead_barrel_diam/2-0.05) {
					zspread(4, n=4) {
						yspread(6) {
							yrot(90) cylinder(h=4*2, d=3, center=true, $fn=12);
						}
						cube([4*2, 6, 3], center=true);
					}
				}
			}
			up(jhead_length/2-jhead_shelf_thick-jhead_groove_thick/2) {
				difference() {
					cylinder(h=jhead_groove_thick, d=jhead_barrel_diam+1, center=true);
					cylinder(h=jhead_groove_thick+1, d=jhead_groove_diam, center=true);
				}
			}
		}
		color("silver")
		down((jhead_length+block_h)/2) {
			difference() {
				left(jhead_block_off/2) {
					cube(jhead_block_size, center=true);
				}
				left(jhead_block_off) {
					xrot(90) cylinder(h=100, d=6.0, center=true);
				}
				cylinder(h=100, d=2, center=true, $fn=12);
			}
			difference() {
				down((block_h+3)/2) {
					cylinder(h=3, r=4, center=true);
					down((3+1.2)/2) {
						cylinder(h=1.2, r1=1, r2=4, center=true);
					}
				}
				cylinder(h=50, d=0.4, center=true, $fn=8);
			}
		}
		color("goldenrod")
		down((jhead_length+block_h)/2) {
			left(jhead_block_off) {
				xrot(90) cylinder(h=jhead_block_size[0]+1, d=6, center=true);
			}
		}
		down((jhead_length+block_h)/2) {
			left(jhead_block_off+1) {
				wiring([
					[0, jhead_block_size[0]/2-2, 0],
					[0, jhead_block_size[0]/2+5, 0],
					[24, jhead_block_size[0]+12, jhead_length-10],
					[24.01, jhead_block_size[0]+12, jhead_length],
				], 2, fillet=8);
			}
			wiring([
				[0, jhead_block_size[0]/2-2, 0],
				[0, jhead_block_size[0]/2+5, 0],
				[18, jhead_block_size[0]+12, jhead_length-10],
				[18.01, jhead_block_size[0]+12, jhead_length],
			], 2, fillet=8, wirenum=2);
		}
		wiring([
			[16.01, 30, 15],
			[16, 30, 20],
			[0, rail_width/3, 20],
			[-extruder_length/2-10, rail_width/3, 20],
		], 4, fillet=5);
	}
	color("silver")
	up(jhead_groove_thick+jhead_shelf_thick) {
		difference() {
			cylinder(h=jhead_cap_height, d=jhead_cap_diam, $fn=6);
			down(0.5) cylinder(h=jhead_cap_height+1, d=2, $fn=12);
		}
	}
}
//!jhead_hotend();



module extruder_drive_gear()
{
	color("silver") {
		difference() {
			cylinder(h=12, d=extruder_drive_diam, $fn=24);
			up(12-3.5) {
				zring(r=(extruder_drive_diam+3)/2, n=40) {
					scale([1, 0.4, 1]) sphere(d=5, $fn=24);
				}
			}
			down(1) cylinder(h=15, d=motor_shaft_size, $fn=18);
			up(3.5) yrot(90) cylinder(h=extruder_drive_diam/2+1, d=3, $fn=18);
		}
	}
}
//!extruder_drive_gear();



module cooling_fan()
{
	up(extruder_fan_thick/2)
	color([0.4, 0.4, 0.4]) {
		difference() {
			chamfcube(size=[extruder_fan_size, extruder_fan_size, extruder_fan_thick], chamfer=3, chamfaxes=[0,0,1], center=true);
			cylinder(h=extruder_fan_thick+1, d=extruder_fan_size-2, center=true);
			xspread(extruder_fan_size-3-3) {
				yspread(extruder_fan_size-3-3) {
					cylinder(h=extruder_fan_thick+1, d=3, center=true, $fn=12);
				}
			}
		}
		up((2-0.1)/2) {
			linear_extrude(height=extruder_fan_thick-2, twist=30, slices=4, center=true, convexity=10) {
				circle(r=extruder_fan_size/4, center=true);
				zring(r=(extruder_fan_size-3)/4, n=8) {
					square([(extruder_fan_size-3)/2, 1], center=true);
				}
			}
		}
		cylinder(h=extruder_fan_thick, d=extruder_fan_size/2-3, center=true);
		down(extruder_fan_thick/2-1/2) {
			cube([extruder_fan_size, 3, 1], center=true);
			cube([3, extruder_fan_size, 1], center=true);
		}
	}
}
//!cooling_fan();



module microswitch()
{
	color([0.3, 0.3, 0.3]) {
		difference() {
			// Body
			cube([endstop_thick, endstop_length, endstop_depth], center=true);

			// Bevel
			xrot(-5) {
				up(endstop_depth) {
					cube([endstop_thick+1, endstop_length, endstop_depth], center=true);
				}
			}

			// Screwholes
			down(endstop_hole_inset/2-endstop_click_voff/2) {
				yspread(endstop_hole_spacing) {
					yrot(90) cylinder(h=endstop_thick+1, d=endstop_screw_size, center=true, $fn=12);
				}
			}
		}
	}
	up(endstop_depth/2) {
		// Switch bump
		color([0.3, 0.3, 0.3]) {
			yrot(90) cylinder(h=endstop_thick*0.75, d=1, center=true, $fn=12);
		}

		// Lever arm
		color("silver") {
			fwd(endstop_length*0.9/2) xrot(5) back(endstop_length*0.9/2) {
				cube([endstop_thick, endstop_length*0.9, 0.1], center=true);
				back(endstop_length*0.9/2+1) {
					top_half() {
						yrot(90) {
							difference() {
								cylinder(h=endstop_thick, r=1, center=true, $fn=12);
								cylinder(h=endstop_thick+1, r=0.8, center=true, $fn=12);
							}
						}
					}
				}
			}
		}

		// Terminals
		color("silver") {
			grid_of(ya=[-endstop_length/2+2, -endstop_length/8, endstop_length/2-2]) {
				down(endstop_depth+7/2) {
					cube([0.2, endstop_thick*0.5, 7], center=true);
				}
			}
		}
	}
}
//!microswitch();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
