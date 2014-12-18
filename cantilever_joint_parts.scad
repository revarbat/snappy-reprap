include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module cantilever_joint()
{
	joiner_length = 20;
	hanger_strut = rail_height*2;

	color("Chocolate")
	//prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Top hanger joiners.
				translate([0, -platform_height/2+0.001, 0]) {
					xrot(-90) joiner_pair(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				}

				// Bottom strut
				translate([0, joiner_length/2, joiner_length/2])
					cube(size=[platform_width, joiner_length, joiner_length], center=true);

				// Front struts
				grid_of(
					xa=[-(platform_width-joiner_width)/2, (platform_width-joiner_width)/2],
					ya=[joiner_length/2],
					za=[-(hanger_strut-2*rail_height)/2]
				) {
					cube(size=[joiner_width, joiner_length, (hanger_strut-2*rail_height)], center=true);
				}

				// Front joiners.
				translate([0, joiner_length, -(hanger_strut-rail_height)]) {
					grid_of(count=[1,1,2], spacing=[1,1,rail_height]) {
						joiner_pair(spacing=platform_width-joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
					}
				}
			}

			// Clear for side joiners
			translate([0, joiner_width/2, joiner_length-rail_height/4-rail_height]) {
				circle_of(n=2, r=platform_width/2, rot=true) {
					zrot(-90) {
						half_joiner_clear(h=rail_height/2, w=joiner_width, l=10, a=joiner_angle);
					}
				}
			}
		}

		// Side joiners
		translate([0, joiner_width/2, joiner_length-rail_height/4-rail_height]) {
			circle_of(n=2, r=platform_width/2, rot=true) {
				zrot(-90) {
					half_joiner2(h=rail_height/2, w=joiner_width, l=10, a=joiner_angle);
				}
			}
		}
	}
}
//!cantilever_joint();



module cantilever_joint_parts() { // make me
	translate([0, 0, 15]) zrot(90) xrot(180) {
		cantilever_joint();
	}
}



cantilever_joint_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

