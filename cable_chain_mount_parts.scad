include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <cable_chain.scad>


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


module cable_chain_xy_mount()
{
	joiner_length=10;
	color("SpringGreen")
	union () {
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
		translate([(joiner_length+cable_chain_width/2-3), joiner_length, rail_height/4]) {
			half_joiner(h=rail_height/2, w=joiner_width, l=joiner_length, a=joiner_angle);
		}
	}
}
//!cable_chain_xy_mount();


module cable_chain_link_parts() { // make me
	translate([0, 12, 0]) {
		grid_of(count=2, spacing=32) {
			zrot(90) cable_chain_mount();
		}
	}
	translate([0, -18, 0]) {
		cable_chain_xy_mount();
	}
}


cable_chain_link_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

