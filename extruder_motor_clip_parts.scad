include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>


$fa = 2;
$fs = 2;

thick = 6;
motor_width = nema_motor_width(17);


module extruder_motor_clip()
{
	color("Turquoise")
	prerender(convexity=10)
	difference() {
		union() {
			up(motor_width/2+5+thick/2) {
				cube(size=[motor_mount_spacing+joiner_width, rail_height, thick], center=true);
				xspread(motor_width) {
					yspread(motor_length-5) {
						down(15/2) {
							cube([15,15,15], center=true);
						}
					}
				}
			}

			// Joiners
			xrot(-90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=motor_width/2+5+1, a=joiner_angle);
		}

		// Clear for motor.
		cube([motor_width+printer_slop, motor_length+printer_slop, motor_width], center=true);

		// Ventilation hole
		cylinder(h=100, d=motor_width*0.75, center=true);
	}
}
//!extruder_motor_clip();



module extruder_motor_clip_parts() { // make me
	up(motor_width/2+5+6/2) {
		zrot(90) yrot(180) extruder_motor_clip();
	}
}



extruder_motor_clip_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
