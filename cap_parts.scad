include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module cap_parts() { // make me
	num_x = 4;
	num_y = 5;
	spacing = 25;
	render(convexity=4) grid_of(
		xa=[-spacing*(num_x-1)/2:spacing:spacing*(num_x-1)/2],
		ya=[-spacing*(num_y-1)/2:spacing:spacing*(num_y-1)/2],
		za=[2]
	) cap(r=roller_axle/2-3, h=10, lip=2, wall=3);
}


cap_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

