include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <cable_chain.scad>


$fa = 2;
$fs = 2;


module cable_chain_joiner_mount()
{
	joiner_length=15;
	color([1.0, 1.0, 1.0])
	prerender(convexity=10)
	union () {
		left(joiner_length+cable_chain_width/2-0.05) {
			fwd(2) cable_chain_mount1();
			scale([1, (cable_chain_length-20+4)/(cable_chain_length-20), 1]) {
				cable_chain_barrel();
			}
			back(2) cable_chain_mount2();
		}
		up(rail_height/4) {
			chamfer(chamfer=3, size=[joiner_length*2, joiner_width, rail_height/2], edges=[[1,1,0,0], [1,1,0,0], [0,0,0,0]]) {
				zrot(-90) {
					half_joiner(h=rail_height/2, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
			}
		}
	}
}
//!cable_chain_joiner_mount();


module cable_chain_joiner_vertical_mount()
{
	joiner_length=10;
	color([1.0, 1.0, 1.0])
	prerender(convexity=10)
	union () {
		left(joiner_length+cable_chain_width/2+5-0.05) {
			up(3+2) {
				fwd(cable_chain_height/2) {
					xrot(-90) {
						fwd(4) cable_chain_mount1();
						scale([1, (cable_chain_length-20+4)/(cable_chain_length-20), 1]) {
							cable_chain_barrel();
						}
					}
				}
			}
		}
		up(10/2) {
			left(joiner_length+5/2) {
				cube([5+1, joiner_width, 10], center=true);
			}
		}
		up(rail_height/4) {
			chamfer(chamfer=3, size=[joiner_length*2, joiner_width, rail_height/2], edges=[[1,1,0,0], [1,1,0,0], [0,0,0,0]]) {
				zrot(-90) {
					half_joiner(h=rail_height/2, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
			}
		}
	}
}
//!cable_chain_joiner_vertical_mount();


module cable_chain_xy_joiner_mount()
{
	joiner_length=10;
	color([1.0, 1.0, 1.0])
	prerender(convexity=10)
	union () {
		translate([-(joiner_length+cable_chain_width/2-3), -joiner_length, 0]) {
			back(3) {
				cable_chain_barrel();
				zrot(180) cable_chain_mount1();
			}
			left(cable_chain_width/2-cable_chain_length/8+0.5) {
				fwd(cable_chain_width/2-cable_chain_width/4+0.5) {
					zrot(-90) {
						cable_chain_mount1();
						cable_chain_barrel();
					}
				}
			}
			difference() {
				translate([cable_chain_width/2+1, 6/2, cable_chain_height/2])
					cube(size=[3, 6, cable_chain_height], center=true);
				translate([(joiner_length+cable_chain_width/2-3), joiner_length, rail_height/4]) {
					half_joiner_clear(h=rail_height/2, w=joiner_width, l=joiner_length, clearance=2, a=joiner_angle);
				}
			}
		}
		up(rail_height/4) {
			chamfer(chamfer=3, size=[joiner_width, joiner_length*2, rail_height/2], edges=[[1,1,0,0], [1,1,0,0], [0,0,0,0]]) {
				half_joiner(h=rail_height/2, w=joiner_width, l=joiner_length, a=joiner_angle);
			}
		}
	}
}
//!cable_chain_xy_joiner_mount();


module cable_chain_x_sled_mount()
{
	joiner_length=10;
	color([1.0, 1.0, 1.0])
	prerender(convexity=10)
	union () {
		translate([-(joiner_length+cable_chain_width/2-3), -joiner_length, 0]) {
			back(3) {
				cable_chain_barrel();
				zrot(180) cable_chain_mount1();
			}
			difference() {
				translate([cable_chain_width/2+1, 6/2, cable_chain_height/2])
					cube(size=[3, 6, cable_chain_height], center=true);
				translate([(joiner_length+cable_chain_width/2-3), joiner_length, rail_height/4]) {
					half_joiner_clear(h=rail_height/2, w=joiner_width, l=joiner_length, clearance=2, a=joiner_angle);
				}
			}
		}
		up(rail_height/4) {
			chamfer(chamfer=3, size=[joiner_width, joiner_length*2, rail_height/2], edges=[[1,1,0,0], [1,1,0,0], [0,0,0,0]]) {
				half_joiner(h=rail_height/2, w=joiner_width, l=joiner_length, a=joiner_angle);
			}
		}
	}
}
//!cable_chain_x_sled_mount();


module cable_chain_mount_parts() { // make me
	back(45) {
		left(35/2) {
			xspread(35) {
				zrot(90) cable_chain_joiner_mount();
			}
		}
		right(35) {
			zrot(90) cable_chain_joiner_vertical_mount();
		}
	}
	translate([35, -10, 0]) {
		cable_chain_xy_joiner_mount();
	}
	translate([-20, -10, 0]) {
		cable_chain_x_sled_mount();
	}
}


cable_chain_mount_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

