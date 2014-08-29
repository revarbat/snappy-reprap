include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module motor_mount_plate(thick=4, l=15)
{
	union() {
		translate([0, 0, l-thick/2]) {
			difference() {
				cube(size=[43+joiner_width+10, rail_height, 4], center=true);
				zrot(90) nema17_mount_holes(depth=thick+1, l=5);
			}
		}

		// Joiners
		zrot_copies([0, 180]) {
			translate([(43+joiner_width+10)/2, 0, 0]) {
				xrot(-90) {
					joiner(h=rail_height, w=joiner_width, l=l, a=joiner_angle);
				}
			}
		}
	}
}
//!motor_mount_plate();



module motor_mount_plate_parts() { // make me
	spacing = 55;
	grid_of(ya=[-spacing/2, spacing/2])
		yrot(180) motor_mount_plate();
}



motor_mount_plate_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

