include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <cable_chain.scad>


module cable_chain_horiz_mount()
{
	joiner_length=10;
	color("SpringGreen")
	prerender(convexity=10)
	union () {
		translate([-(joiner_length+cable_chain_width/2-3), 0, 0]) {
			translate([0, -2, 0]) {
				cable_chain_mount1();
				cable_chain_barrel();
			}
			translate([0, 2, 0]) {
				cable_chain_barrel();
				cable_chain_mount2();
			}
		}
		translate([0, 0, rail_height/4]) {
			chamfer(chamfer=3, size=[joiner_length*2, joiner_width, rail_height/2], edges=[[1,1,0,0], [0,0,0,0], [0,0,0,0]]) {
				zrot(-90) {
					half_joiner2(h=rail_height/2, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
			}
		}
	}
}
//!cable_chain_horiz_mount();


module cable_chain_vert_mount()
{
	joiner_length=10;
	color("SpringGreen")
	prerender(convexity=10)
	union () {
		translate([-(cable_chain_width/2+joiner_length-6), cable_chain_height+joiner_width/2, 3]) {
			zrot(180) xrot(-90) {
				cable_chain_mount1();
				cable_chain_barrel();
			}
		}
		translate([0, 0, rail_height/4]) {
			chamfer(chamfer=3, size=[joiner_length*2, joiner_width, rail_height/2], edges=[[1,1,0,0], [0,0,0,0], [0,0,0,0]]) {
				zrot(-90) {
					half_joiner(h=rail_height/2, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
			}
		}
	}
}
//!cable_chain_vert_mount();


module cable_chain_xy_mount()
{
	joiner_length=10;
	color("SpringGreen")
	prerender(convexity=10)
	union () {
		translate([-(joiner_length+cable_chain_width/2-3), -joiner_length, 0]) {
			translate([0, 3, 0]) {
				cable_chain_barrel();
				zrot(180) cable_chain_mount1();
			}
			translate([-8, -5, 0]) {
				zrot(-90) {
					cable_chain_mount1();
					cable_chain_barrel();
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
		translate([0, 0, rail_height/4]) {
			chamfer(chamfer=3, size=[joiner_width, joiner_length*2, rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
				half_joiner(h=rail_height/2, w=joiner_width, l=joiner_length, a=joiner_angle);
			}
		}
	}
}
//!cable_chain_xy_mount();


module cable_chain_mount_parts() { // make me
	translate([0, 35, 0]) {
		grid_of(count=2, spacing=35) {
			zrot(90) cable_chain_horiz_mount();
		}
	}
	translate([15, -10, 0]) {
		cable_chain_xy_mount();
	}
	translate([25, -45, 0]) {
		cable_chain_vert_mount();
	}
}


cable_chain_mount_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

