include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module xy_joiner()
{
	joiner_length=10;
	hardstop_offset=8;
	hoff = (platform_length*2-rail_width-20)/2;

	color("Sienna")
	prerender(convexity=10)
	union() {
		difference() {
			// Bottom
			translate([0, -joiner_length/2, -platform_thick/2]) {
				cube(size=[platform_width-joiner_width, joiner_length, platform_thick], center=true);
			}

			// Clear for joiners.
			translate([0,0,-platform_height/2]) {
				joiner_pair_clear(spacing=platform_width-joiner_width, h=platform_height+0.001, w=joiner_width, clearance=5, a=joiner_angle);
			}
		}

		// Snap-tab joiners.
		intersection() {
			union() {
				translate([0,0,-platform_height/2]) {
					joiner_pair(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
				translate([0,0,rail_height/4]) {
					grid_of(count=2, spacing=platform_width-joiner_width) {
						half_joiner2(h=rail_height/2, w=joiner_width, l=joiner_length, a=joiner_angle);
					}
				}
			}
			translate([0, 0, -(platform_height+rail_height/2)/2+rail_height/2]) {
				grid_of(count=2, spacing=platform_width-joiner_width) {
					chamfcube(chamfer=3, size=[joiner_width, 90, platform_height+rail_height/2], chamfaxes=[1,1,1]);
				}
			}
		}

		// Top half-joiners.
		translate([0, hoff, 0]) {
			translate([0, 0, rail_height/2/2]) {
				translate([side_mount_spacing/2, 0, 0]) {
					chamfer(chamfer=3, size=[joiner_width, 2*(hoff+joiner_length), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
						half_joiner(h=rail_height/2, w=joiner_width, l=hoff+joiner_length, a=joiner_angle);
					}
				}
				translate([-side_mount_spacing/2, 0, 0]) {
					chamfer(chamfer=3, size=[joiner_width, 2*(hoff+joiner_length), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
						half_joiner2(h=rail_height/2, w=joiner_width, l=hoff+joiner_length, a=joiner_angle, slop=printer_slop);
					}
				}
			}
		}

		// Connect top half-joiners.
		translate([0, platform_thick/2-joiner_length, rail_height/2-platform_thick/2])
			xrot(90) cube(size=[platform_width-joiner_width, platform_thick, platform_thick], center=true);

		// Remove indents on attachment to main body
		translate([0, -joiner_length/2, 0]) {
			grid_of(count=2, spacing=side_mount_spacing) {
				cube(size=[joiner_width, joiner_length, joiner_width], center=true);
			}
		}

		// Rack and pinion hard stop.
		translate([0, -joiner_length+(joiner_length-hardstop_offset)/2, -platform_thick-rail_offset/2]) {
			cube(size=[motor_mount_spacing+joiner_width+5, joiner_length-hardstop_offset, rail_offset], center=true);
		}

		// endstop trigger
		translate([0, -joiner_length/2, 0]) {
			mirror_copy([1, 0, 0]) {
				translate([motor_mount_spacing/2+joiner_width/2+2, 0, 0]) {
					translate([10/2, 0, -(platform_thick+rail_offset+groove_height/2+3)/2]) {
						xrot(90) rrect(r=10/3, size=[10, platform_thick+rail_offset+groove_height/2+3, joiner_length], center=true);
					}
				}
			}
		}
	}
}
//!xy_joiner();



module xy_joiner_parts() { // make me
	zrot(90) xrot(90) xy_joiner();
}



xy_joiner_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

