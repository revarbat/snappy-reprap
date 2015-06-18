include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>


module motor_mount_plate(thick=4, l=20)
{
	color("Teal")
	prerender(convexity=10)
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

			// Standoff
			zrot_copies([0, 180]) {
				grid_of(
					xa=[motor_mount_spacing/2+joiner_width/2+endstop_standoff/2],
					ya=[-endstop_hole_spacing/2-endstop_hole_hoff, endstop_hole_spacing/2-endstop_hole_hoff],
					za=[l-endstop_hole_inset]
				) {
					difference() {
						hull() {
							grid_of(za=[0, endstop_hole_inset]) {
								yrot(90) {
									cylinder(
										r1=endstop_screw_size*1.1/2/cos(30)+0.5+endstop_standoff,
										r2=endstop_screw_size*1.1/2/cos(30)+0.5,
										h=endstop_standoff,
										center=true,
										$fn=24
									);
								}
							}
						}
						translate([0, 0, (endstop_hole_inset+endstop_screw_size)]) {
							cube(size=[endstop_standoff+2, endstop_screw_size*4, endstop_screw_size*2], center=true);
						}
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
	yspread(65, n=1) {
		yrot(180) motor_mount_plate();
	}
}



motor_mount_plate_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

