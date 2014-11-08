include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module cantilever_joint()
{
	joiner_length=15;

	color("Chocolate")
	prerender(convexity=10)
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
			za=[-(platform_length-rail_height)/4]
		) {
			cube(size=[joiner_width, joiner_length, (platform_length-rail_height)/2], center=true);
		}

		// Front joiners.
		translate([0, joiner_length, -platform_length/2]) {
			joiner_pair(spacing=platform_width-joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
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

