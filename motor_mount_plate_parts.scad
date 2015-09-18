include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>


$fa = 2;
$fs = 2;


module motor_mount_plate()
{
	l = motor_length/2;
	thick = 6;
	motor_width = nema_motor_width(17);
	clip_wall = 2;

	color("Teal")
	prerender(convexity=10)
	difference() {
		union() {
			up(l) {
				difference() {
					down(thick/2-2) {
						cube(size=[motor_mount_spacing+joiner_width, rail_height, thick], center=true);
					}
					zrot(90) nema17_mount_holes(depth=thick+1, l=0, slop=printer_slop);
					down(l) cube([motor_width, motor_width, motor_length], center=true);
				}
			}

			// Joiners
			xrot(-90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=l, a=joiner_angle);

			zrot_copies([0, 180]) {
				right((motor_mount_spacing+joiner_width)/2) {
					up(l+thick/2-2/2) {
						fwd(endstop_hole_hoff) {

							// limit switch clips
							down(endstop_depth/2) {
								right(endstop_standoff/2-0.05) {
									cube([endstop_standoff+0.05, endstop_length+2*clip_wall, endstop_depth], center=true);
									down(endstop_depth/2+clip_wall/2-0.05) {
										trapezoid([2, endstop_length+2*clip_wall], [endstop_standoff+3, endstop_length+2*clip_wall], h=clip_wall+0.05, center=true);
									}
								}
								right(endstop_standoff-0.05) {
									right((endstop_thick+clip_wall-0.05)/2) {
										yflip_copy() {
											fwd((endstop_length+clip_wall)/2) {
												cube([endstop_thick+clip_wall+0.05, clip_wall, endstop_depth], center=true);

												// Clip ridge
												right(endstop_thick/2+0.05) {
													back_half() {
														yrot(90) trapezoid([endstop_depth, clip_wall+1], [endstop_depth, clip_wall], h=clip_wall, center=true);
													}
												}
											}
										}
									}
								}
							}

							// limit switch snap bumps
							down(endstop_hole_inset) {
								right(endstop_standoff) {
									yspread(endstop_hole_spacing) {
										scale([0.5, 1, 1]) sphere(d=endstop_screw_size, center=true, $fn=12);
									}
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
	up(motor_length/2+2) {
		zrot(90) yrot(180) motor_mount_plate();
	}
}



motor_mount_plate_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
