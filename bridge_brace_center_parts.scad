include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>



$fa = 2;
$fs = 2;

module bridge_brace_center(explode=0, arrows=false)
{
	l = motor_rail_length;
	hole_diam = 5;
	difference() {
		union() {
			right(l/2) zrot(-90) yrot(90) joiner(h=rail_height, w=joiner_width, l=10, a=joiner_angle);
			xrot(90) zrot(90) sparse_strut(h=rail_height, l=l-2*8+0.1, thick=joiner_width, strut=5);
			left(l/2) zrot(90) yrot(90) joiner(h=rail_height, w=joiner_width, l=10, a=joiner_angle);
			xspread(15,n=3) cylinder(d=hole_diam+joiner_width*1.5, h=joiner_width, center=true);
			cube([hole_diam+joiner_width*1.5+30, hole_diam+joiner_width*1.5, joiner_width], center=true);
		}
		xspread(15, n=3) {
			cylinder(d=hole_diam, h=joiner_width+0.1, center=true);
			zflip_copy() {
				up(joiner_width/2) {
					fillet_hole_mask(r=hole_diam/2, fillet=joiner_width/2+0.01, $fn=24);
				}
			}
		}
	}
}



module bridge_brace_center_parts() { // make me
	up(rail_height/2) xrot(90) bridge_brace_center();
}


bridge_brace_center_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
