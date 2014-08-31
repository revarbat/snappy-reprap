include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <tslot.scad>


module xy_joiner()
{
	joiner_length=10;
	hoff = (platform_length*2-rail_width)/2-3*3+1;
	union() {
		// Joiners
		translate([0, 0, -platform_height/2]) {
			yrot_copies([0, 180]) {
				translate([(platform_width-joiner_width)/2, 0, 0]) {
					joiner(h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
			}
		}

		//Vertical brace bars.
		grid_of(
			xa=[-(platform_width-joiner_width)/2, (platform_width-joiner_width)/2],
			ya=[-(joiner_length*1.5-0.05)],
			za=[-platform_height/2+22/2]
		) {
			cube(size=[joiner_width, joiner_length+0.05, platform_height+22], center=true);
		}

		translate([0, hoff, 0]) {
			// tabs connector.
			translate([0, -platform_thick/2, 22/2]) {
				cube(size=[(platform_width-joiner_width), platform_thick, 22], center=true);
			}

			// Lock tabs
			grid_of(
				xa=[-(motor_rail_length/2-joiner_length-5), (motor_rail_length/2-joiner_length-5)]
			) {
				zrot(180) lock_tab(h=25, wall=3);
			}
		}

		// Bottom
		translate([0, hoff/2-joiner_length/2-5, 22-5/2]) {
			xrot(90) zrot(90) sparse_strut(l=platform_width, h=hoff+joiner_length+10, thick=5, maxang=45, strut=platform_thick, max_bridge=999);
		}

		// Side walls
		grid_of(xa=[-(platform_width-joiner_width)/2, (platform_width-joiner_width)/2]) {
			translate([0, hoff/2-joiner_length/2-5, 22/2]) {
				cube(size=[joiner_width, hoff+joiner_length+10, 22], center=true);
			}
		}
		// Back Wall
		translate([0, -joiner_length*2+platform_thick/2, 7]) {
			zrot(90) thinning_wall(l=platform_width-joiner_width, h=30, thick=platform_thick, maxang=45, strut=5, max_bridge=999, bracing=false);
		}
	}
}
//!xy_joiner();



module xy_joiner_parts() { // make me
	translate([0, 0, 22]) {
		zrot(90) xrot(180) xy_joiner();
	}
}



xy_joiner_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

