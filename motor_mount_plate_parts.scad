include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>


module motor_mount_plate(thick=4, l=15)
{
	color("Teal")
	difference() {
		union() {
			translate([0, 0, l-thick/2]) {
				difference() {
					rrect(size=[motor_mount_spacing+joiner_width, rail_height+10, 4], r=5, center=true);
					zrot(90) nema17_mount_holes(depth=thick+1, l=5);
				}
			}

			// Joiners
			xrot(-90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=l, a=joiner_angle);

			zrot_copies([0, 180]) {
				grid_of(
					xa=[motor_mount_spacing/2+joiner_width/2+endstop_standoff/2],
					ya=[-endstop_hole_spacing/2-endstop_hole_hoff, endstop_hole_spacing/2-endstop_hole_hoff],
					za=[l-endstop_hole_inset]
				) {
					yrot(90) zrot(30) cylinder(r1=endstop_hole_inset/cos(30), r2=endstop_screw_size*1.1/2/cos(30)+0.5, h=endstop_standoff, center=true, $fn=6);
					translate([0, 0, endstop_hole_inset/2]) {
						cube(size=[endstop_standoff, endstop_screw_size*1.1/cos(30)+1, endstop_hole_inset], center=true);
					}
				}
			}
		}

		zrot_copies([0, 180]) {
			grid_of(
				xa=[motor_mount_spacing/2+endstop_standoff/2],
				ya=[-endstop_hole_spacing/2-endstop_hole_hoff, endstop_hole_spacing/2-endstop_hole_hoff],
				za=[l-endstop_hole_inset]
			) {
				yrot(90) cylinder(r=endstop_screw_size*1.1/2, h=joiner_width+endstop_standoff+0.05, center=true, $fn=12);
				scale([1.1, 1.1, 1.1]) {
					hull() {
						yrot(90) metric_nut(size=endstop_screw_size);
						translate([0, 0, endstop_hole_inset])
							yrot(90) metric_nut(size=endstop_screw_size);
					}
				}
			}
		}
	}
}
//!motor_mount_plate();



module motor_mount_plate_parts() { // make me
	n = 1;
	spacing = 55;
	grid_of(ya=[-((n-1)*spacing)/2 : spacing : ((n-1)*spacing)/2])
		yrot(180) motor_mount_plate();
}



motor_mount_plate_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

