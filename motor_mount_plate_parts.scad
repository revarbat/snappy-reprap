include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>


$fa=1;
$fs=1;


module motor_mount_plate()
{
	l = motor_length/2;
	thick = 4;
	motor_width = nema_motor_width(17)+printer_slop*2;

	color("Teal")
	prerender(convexity=10)
	difference() {
		union() {
			up(l) {
				difference() {
					cube(size=[motor_mount_spacing+joiner_width, rail_height, thick], center=true);
					zrot(90) nema17_mount_holes(depth=thick+1, l=0, slop=printer_slop);
					down(l) cube([motor_width, motor_width, motor_length], center=true);
				}
			}

			// Joiners
			xrot(-90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=l, a=joiner_angle);

			// Standoffs
			zrot_copies([0, 180]) {
				right(motor_mount_spacing/2+joiner_width/2+endstop_standoff/2-0.05) {
					up(l+thick/2-endstop_hole_inset) {
						fwd(endstop_hole_hoff) {
							yspread(endstop_hole_spacing) {
								difference() {
									yrot(90) {
										cylinder(
											r1=endstop_screw_size*1.1/2/cos(30)+1+endstop_standoff,
											r2=endstop_screw_size*1.1/2/cos(30)+1,
											h=endstop_standoff+0.05,
											center=true,
											$fn=24
										);
									}
									up(endstop_hole_inset+endstop_screw_size) {
										cube(size=[endstop_standoff+2, endstop_screw_size*4, endstop_screw_size*2], center=true);
									}
								}
							}
						}
					}
				}
			}
		}

		zrot_copies([0, 180]) {
			right(motor_mount_spacing/2+endstop_standoff/2-0.05) {
				up(l+thick/2-endstop_hole_inset) {
					fwd(endstop_hole_hoff) {
						yspread(endstop_hole_spacing) {
							yrot(90) cylinder(r=endstop_screw_size*1.1/2, h=joiner_width+endstop_standoff+0.1, center=true, $fn=18);
							left(joiner_width/2+1.1) {
								scale([1.1, 1.1, 1.1]) {
									yrot(90) zrot(90) metric_nut(size=endstop_screw_size, hole=false);
								}
							}
						}
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
