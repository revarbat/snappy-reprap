include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>



$fa = 2;
$fs = 2;

module bridge_brace(explode=0, arrows=false)
{
	l = rail_length;
	union() {
		right(l/2) zrot(-90) yrot(90) joiner(h=rail_height, w=joiner_width, l=10, a=joiner_angle);
		left(l/2) zrot(90) yrot(90) joiner(h=rail_height, w=joiner_width, l=10, a=joiner_angle);
		xrot(90) zrot(90) sparse_strut(h=rail_height, l=l-2*8+0.1, thick=joiner_width, strut=5);
	}
}



module bridge_brace_parts() { // make me
	up(rail_height/2) xrot(90) bridge_brace();
}


bridge_brace_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
