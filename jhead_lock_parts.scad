include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>


$fa = 2;
$fs = 1;

motor_width = nema_motor_width(17);


module jhead_lock()
{
	motor_width = nema_motor_width(17);
	motor_plinth_diam = nema_motor_plinth_diam(17);
	motor_plinth_height = nema_motor_plinth_height(17);
	motor_mount_spacing = motor_width + 2*joiner_width;
	motor_z = 5 + motor_width/2;
	groove_thick = jhead_groove_thick;
	shaft = extruder_shaft_len;
	barrel = jhead_barrel_diam;
	slop = printer_slop;

	color("brown")
	prerender(convexity=10)
	difference() {
		union() {
			// Locking piece body
			fwd(shaft/2/2+motor_length/2.5/2-slop) {
				right(extruder_drive_diam/2-0.5-(barrel+5)/2) {
					upcube([motor_mount_spacing-joiner_width-barrel-5, motor_length/2.5, motor_z-extruder_drive_diam/2-1]);
				}
			}
		}

		// Extruder barrel clearance
		down(0.01) cylinder(d=barrel+slop*2, h=jhead_shelf_thick+jhead_cap_height+2, center=false);

		// Motor clearance
		up(motor_z) {
			left(0.5) {
				// Motor space
				right(extruder_drive_diam/2) {
					fwd(shaft/2) {
						fwd(motor_length/2) {
							cube([motor_width+slop*2, motor_length+slop*2, motor_width+slop*2], center=true);
						}
						xrot(-90) cylinder(d=motor_plinth_diam, h=motor_plinth_height, center=false);
					}
				}
			}
		}

		// Bottom motor cooling convection hole.
		fwd(motor_length/2+shaft/2) {
			right(extruder_drive_diam/2-0.5) {
				down(0.05) {
					cylinder(d=motor_width*0.75, h=motor_z+0.1, center=false);
				}
			}
		}
	}
}
//!jhead_lock();



module jhead_lock_parts() { // make me
	jhead_lock();
}


jhead_lock_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
