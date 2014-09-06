include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <tslot.scad>


module xy_joiner()
{
	joiner_height=30;
	joiner_length=10;
	hoff = (platform_length*2-rail_width)/2-3*3+1;
	color("Sienna") union() {
		// Back Wall
		translate([0, -joiner_length*2+platform_thick/2, 10]) {
			zrot(90) thinning_wall(l=platform_width-joiner_width, h=joiner_height+3, thick=platform_thick, maxang=45, strut=5, max_bridge=999, bracing=false);
		}

		// Side walls
		grid_of(xa=[-(platform_width-joiner_width)/2, (platform_width-joiner_width)/2]) {
			translate([0, hoff/2-joiner_length/2-5, (joiner_height-3)/2]) {
				cube(size=[joiner_width, hoff+joiner_length+10, (joiner_height-3)], center=true);
			}
		}

		// Bottom
		translate([0, hoff/2-joiner_length/2-5, (joiner_height-3)-5/2]) {
			xrot(90) zrot(90) sparse_strut(l=platform_width, h=hoff+joiner_length+10, thick=5, maxang=45, strut=platform_thick, max_bridge=999);
		}

		// Snap-tab joiners.
		translate([0,0,-platform_height/2]) {
			joiner_pair(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, l=joiner_length*2, a=joiner_angle);
		}

		translate([0, hoff, 0]) {
			// tabs connector.
			translate([0, -platform_thick/2, (joiner_height-3)/2]) {
				cube(size=[(platform_width-joiner_width), platform_thick, (joiner_height-3)], center=true);
			}

			// Lock tabs
			grid_of(xa=[-platform_length/4, platform_length/4]) {
				zrot(180) lock_tab(h=joiner_height, wall=3);
			}
		}
	}
}
//!xy_joiner();



module xy_joiner_parts() { // make me
	joiner_height=30;

	translate([0, 0, (joiner_height-3)]) {
		zrot(90) xrot(180) xy_joiner();
	}
}



xy_joiner_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

