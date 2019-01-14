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
			wiring([
				[-(jhead_block_off+1), jhead_block_size[0]/2-2, 0],
				[-(jhead_block_off+1), jhead_block_size[0]/2+5, 0],
				[-extruder_length/4, -1, jhead_length+4],
				[-extruder_length/2, -1, jhead_length+4],
			], 2, fillet=8);
			wiring([
				[0, jhead_block_size[0]/2-2, 0],
				[0, jhead_block_size[0]/2+5, 0],
				[-extruder_length/4, -3, jhead_length+5],
				[-extruder_length/2, -3, jhead_length+5],
			], 2, fillet=8, wirenum=2);
		}
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


module dncyl(d=1, r=undef, r1=undef, r2=undef, d1=undef, d2=undef, h=1)
{
    brad = r1!=undef? r1 : (d1!=undef? d1/2 : (r!=undef? r : d/2));
    trad = r2!=undef? r2 : (d2!=undef? d2/2 : (r!=undef? r : d/2));
	down(h) cylinder(r1=brad, r2=trad, h=h, center=false);
}


module e3dv6_barrel_fan()
{
	fan_size = 30;
	screw_size = 2.5;
	fwd(e3dv6_heatsink_diam/2+5) {
		// Cooling Fan
		fwd(0.01) xrot(90) cooling_fan(fan_size=fan_size, fan_thick=10, screw_size=screw_size);

		// Fan screws
		color("silver")
		fwd(10.02) {
			zspread(30-screw_size-3) {
				xspread(30-screw_size-3) {
					front_half(5.1) {
						difference() {
							yscale(0.67) sphere(d=5, $fn=12);
							fwd(0.5+6/2) cube([6, 6, 1], center=true);
						}
					}
					xrot(-90) cylinder(d=screw_size, h=15, center=false, $fn=8);
				}
			}
		}

		// Shroud
		color("darkred") {
			difference() {
				union() {
					xrot(-90) trapezoid([fan_size, fan_size], [e3dv6_heatsink_diam+2*2, fan_size], h=e3dv6_heatsink_diam/2+5, center=false);
					back(e3dv6_heatsink_diam/2+5) cylinder(d=e3dv6_heatsink_diam+2*2, h=fan_size, center=true);
				}
				back(e3dv6_heatsink_diam/2+5) {
					cylinder(d=e3dv6_heatsink_diam+0.01, h=fan_size+1, center=true);
					back(e3dv6_heatsink_diam/2) cylinder(d=e3dv6_heatsink_diam, h=fan_size+1, center=true);
					up(fan_size/2+0.01) zflip() trapezoid([fan_size, e3dv6_heatsink_diam+2*5], [fan_size, e3dv6_heatsink_diam], h=5);
					difference() {
						xrot(90) cylinder(d1=e3dv6_heatsink_diam, d2=fan_size-4, h=e3dv6_heatsink_diam/2+5.02, center=false);
						up(fan_size/2) cube([fan_size, fan_size, 2*6], center=true);
					}
					zspread(fan_size) xspread(fan_size) chamfer_mask_y(l=fan_size*2, chamfer=screw_size);
				}
			}
		}
	}
}
//!e3dv6_barrel_fan();


module e3dv6_hotend()
{
	$fa = 1;
	$fs = 1;

	e3dv6_length = 44; // mm
	e3dv6_block_size = [18.7, 16, 9.6];
	e3dv6_block_off = 7; //mm
	e3dv6_heatsink_id = 6.0; // mm
	fin_spacing = 3;
	fin_count = 9;

	block_h = e3dv6_block_size[2];
	down(e3dv6_length/2-e3dv6_groove_thick-e3dv6_shelf_thick) {
		color("silver")
		difference() {
			union() {
				cylinder(h=e3dv6_length, d=e3dv6_heatsink_id, center=true);
				up(e3dv6_length/2) {
					dncyl(d=e3dv6_barrel_diam, h=e3dv6_shelf_thick);
					down(e3dv6_shelf_thick) {
						dncyl(d=e3dv6_groove_diam, h=e3dv6_groove_thick);
						down(e3dv6_groove_thick) {
							dncyl(d=e3dv6_barrel_diam, h=3);
							down(3+fin_spacing/2) {
								dncyl(d=e3dv6_barrel_diam, h=1);
								up(fin_spacing) dncyl(d=e3dv6_groove_diam-2, h=fin_spacing*2);
								down(fin_spacing+fin_spacing*(fin_count-1)/2) {
									zspread(fin_spacing,n=9) dncyl(d=e3dv6_heatsink_diam, h=1);
									up(fin_spacing/2) cylinder(d=e3dv6_barrel_diam*0.9, h=fin_spacing, center=true);
								}
							}
						}
					}
				}
			}
			cylinder(h=e3dv6_length+1, d=2, center=true, $fn=12);
		}
		down((e3dv6_length+block_h)/2) {
			color([0.9, 0.9, 0.9])
			difference() {
				left(e3dv6_block_off/2) {
					cube(e3dv6_block_size, center=true);
				}
				left(e3dv6_block_off) {
					xrot(90) cylinder(h=100, d=6.0, center=true);
				}
				cylinder(h=100, d=2, center=true, $fn=12);
			}
			color("goldenrod")
			difference() {
				down((block_h+3)/2) {
					intersection() {
						union() {
							cylinder(h=3, r=4, center=true);
							down((3+3.0)/2) {
								cylinder(h=3.0, r1=1, r2=4, center=true);
							}
						}
						cylinder(h=20, r=4, center=true, $fn=6);
					}
				}
				cylinder(h=50, d=0.4, center=true, $fn=8);
			}
		}
		color("goldenrod")
		down((e3dv6_length+block_h)/2) {
			left(e3dv6_block_off) {
				xrot(90) cylinder(h=e3dv6_block_size[0]+1, d=6, center=true);
			}
		}
		down((e3dv6_length+block_h)/2) {
			wiring([
				[-(e3dv6_block_off+1), e3dv6_block_size[0]/2-2, 0],
				[-(e3dv6_block_off+1), e3dv6_block_size[0]/2+5, 0],
				[-extruder_length/4, -1, e3dv6_length+2],
				[-extruder_length/2, -1, e3dv6_length+2],
			], 2, fillet=8, wirenum=4);
			wiring([
				[0, e3dv6_block_size[0]/2-2, 0],
				[0, e3dv6_block_size[0]/2+5, 0],
				[-extruder_length/4, -3, e3dv6_length+4],
				[-extruder_length/2, -3, e3dv6_length+4],
			], 2, fillet=8, wirenum=2);
			wiring([
				[-15, -e3dv6_heatsink_diam/2-10, e3dv6_length-block_h-5],
				[-17, -e3dv6_heatsink_diam/2-10, e3dv6_length-block_h-5],
				[-extruder_length/4, -5, e3dv6_length-block_h-2],
				[-extruder_length/4, -5, e3dv6_length-block_h+12],
				[-extruder_length/2, -5, e3dv6_length-block_h+12],
			], 2, fillet=8, wirenum=0);
		}
	}
	color([0.4, 0.4, 0.4])
	up(e3dv6_groove_thick+e3dv6_shelf_thick) {
		difference() {
			cylinder(h=e3dv6_cap_height, d=e3dv6_cap_diam);
			down(0.5) cylinder(h=e3dv6_cap_height+1, d=2, $fn=12);
		}
	}
	down(4+fin_spacing*fin_count/2-0.01) {
		e3dv6_barrel_fan();
	}
}
//!e3dv6_hotend();



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



module cooling_fan(fan_size=extruder_fan_size, fan_thick=extruder_fan_thick, screw_size=3)
{
	up(fan_thick/2)
	color([0.4, 0.4, 0.4]) {
		difference() {
			chamfcube(size=[fan_size, fan_size, fan_thick], chamfer=3, chamfaxes=[0,0,1], center=true);
			cylinder(h=fan_thick+1, d=fan_size-2, center=true);
			xspread(fan_size-screw_size-3) {
				yspread(fan_size-screw_size-3) {
					cylinder(h=fan_thick+1, d=screw_size, center=true, $fn=12);
				}
			}
		}
		up((2-0.1)/2) {
			linear_extrude(height=fan_thick-2, twist=30, slices=4, center=true, convexity=10) {
				circle(r=fan_size/4, center=true);
				zring(r=(fan_size-3)/4, n=8) {
					square([(fan_size-3)/2, 1], center=true);
				}
			}
		}
		cylinder(h=fan_thick, d=fan_size/2-3, center=true);
		down(fan_thick/2-1/2) {
			cube([fan_size, 3, 1], center=true);
			cube([3, fan_size, 1], center=true);
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
			yrot(90) cylinder(h=endstop_thick*0.75, d=2, center=true, $fn=12);
		}

		// Lever arm
		color("silver") {
			fwd(endstop_length*0.9/2) xrot(10) back(endstop_length*0.9/2) {
				cube([endstop_thick, endstop_length*0.9, 0.5], center=true);
				back(endstop_length*0.9/2+1) {
					top_half() {
						yrot(90) {
							difference() {
								cylinder(h=endstop_thick, r=1.5, center=true, $fn=12);
								cylinder(h=endstop_thick+1, r=1.0, center=true, $fn=12);
							}
						}
					}
				}
			}
		}

		// Terminals
		color("silver") {
			tab_width = 3;
			tab_length = 6;
			grid_of(ya=[-endstop_length/2+2, -endstop_length/8, endstop_length/2-2]) {
				down(endstop_depth+tab_length/2) {
					difference() {
						cube([0.2, tab_width, tab_length], center=true);
						down(tab_length/2-2) yrot(90) cylinder(h=1, d=1, center=true, $fn=8);
						down(tab_length/2) yspread(tab_width) chamfer_mask_x(l=1, chamfer=1);
					}
				}
			}
		}
	}
}
//!microswitch();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
