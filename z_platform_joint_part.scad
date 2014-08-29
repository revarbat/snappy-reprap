include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module z_platform_joint()
{
	joiner_length=10;
	xrot(-90) union() {
		translate([0, 0, platform_height/2]) {
			yrot_copies([0, 180]) {
				translate([-(platform_width-joiner_width)/2, 0, 0]) {
					yrot(180) joiner(h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
			}
		}
		translate([0, -joiner_length/2, -joiner_length/2])
			cube(size=[platform_width, joiner_length, joiner_length], center=true);
		translate([0, rail_height/2-0.05, -joiner_length/2]) xrot(90) zrot(90) {
			thinning_wall(h=rail_height+0.05, l=rail_width-joiner_width*2+0.05, thick=joiner_length, strut=4);
		}
		translate([0, rail_height/2, -joiner_length]) {
			zrot_copies([0, 180]) {
				translate([-(rail_width-joiner_width)/2, 0, 0]) {
					xrot(-90) yrot(180) joiner(h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
			}
		}
	}
}
//!z_platform_joint();



module z_platform_joint_part() { // make me
	translate([0, 0, 10]) zrot(90) xrot(180) {
		z_platform_joint();
	}
}



z_platform_joint_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

