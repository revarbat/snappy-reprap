include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>


$fa = 2;
$fs = 2;

thick = 4;
motor_width = nema_motor_width(17);
motor_plinth_diam = nema_motor_plinth_diam(17);
motor_plinth_height = nema_motor_plinth_height(17);


module extruder_motor_clip()
{
	motor_mount_spacing = motor_width + 2*joiner_width;
	color("Turquoise")
	prerender(convexity=10)
	difference() {
		union() {
			up(10) upcube([motor_mount_spacing-joiner_width+0.01, rail_height, motor_width/2+thick-10]);

			// Joiners
			xrot(-90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=motor_width/2+thick, a=joiner_angle);
		}

		// Clear for motor.
		cube([motor_width+printer_slop, motor_length+printer_slop, motor_width], center=true);
		fwd(motor_length/2-0.01) xrot(90) cylinder(d=motor_plinth_diam, h=motor_length, center=false);

		// Top ventilation hole
		cube([motor_mount_spacing-joiner_width, motor_length/2, motor_width+50], center=true);
		cube([motor_width/2, rail_height-16, motor_width+50], center=true);

		// Chamfer top ventilation holes
		xspread(motor_width/2) {
			yspread(motor_length/2) {
				chamfer_mask_z(l=rail_height*2, chamfer=joiner_width/3);
			}
		}

		// Side ventilation holes
		up(8) {
			upcube([motor_mount_spacing+joiner_width+0.01, motor_length/2, motor_width/2-10]);
			down(thick) upcube([motor_width/2, rail_height+0.01, motor_width/2-10]);
		}

		// Clear for idler bearing axle
		yflip_copy() {
			fwd(rail_height/2) {
				xrot(90) trapezoid([motor_width*2, extruder_idler_axle+8], [motor_width*2, extruder_idler_axle+8+4*2], h=4, center=true);
			}
		}

		// Chamfer mount corners
		xspread(motor_width/2) {
			up(10) {
				chamfer_mask_y(l=rail_height*2, chamfer=5);
			}
		}

		// chamfer vertical edges
		xspread(motor_mount_spacing+joiner_width) {
			yspread(rail_height) {
				chamfer_mask_z(l=rail_height*2, chamfer=joiner_width/3);
			}
		}

		// chamfer horizontal edges
		up(motor_width/2+thick) {
			xspread(motor_mount_spacing+joiner_width) {
				chamfer_mask_y(l=rail_height, chamfer=joiner_width/3);
			}
			yspread(rail_height) {
				chamfer_mask_x(l=motor_mount_spacing+joiner_width, chamfer=joiner_width/3);
			}
		}
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
