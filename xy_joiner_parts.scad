include <config.scad>
use <GDMUtils.scad>
use <sliders.scad>
use <joiners.scad>


joiner_length = 20;
hardstop_offset = drive_gear_diam/2;


module xy_joiner()
{
	hoff = (platform_length*2-rail_width-4)/2;

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
				joiner_pair_clear(spacing=platform_width-joiner_width, h=platform_height+0.001, w=joiner_width, clearance=1, a=joiner_angle);
			}
		}

		// Snap-tab joiners.
		intersection() {
			union() {
				down(platform_height/2-0.05) {
					joiner_pair(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
				up(rail_height/4) {
					xspread(platform_width-joiner_width) {
						half_joiner2(h=rail_height/2, w=joiner_width, l=joiner_length, a=joiner_angle);
					}
				}
			}
			up(rail_height/2-(platform_height+rail_height/2)/2) {
				xspread(platform_width-joiner_width) {
					chamfcube(chamfer=3, size=[joiner_width, 90, platform_height+rail_height/2], chamfaxes=[1,1,1]);
				}
			}
		}

		// Top half-joiners.
		back(hoff) {
			up(rail_height/2/2) {
				difference() {
					xspread(side_mount_spacing) {
						chamfer(chamfer=3, size=[joiner_width, 2*(hoff+joiner_length), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
							half_joiner(h=rail_height/2, w=joiner_width, l=hoff+joiner_length, a=joiner_angle, slop=printer_slop);
						}
					}
					fwd((hoff+joiner_width)/2) {
						cube([side_mount_spacing+2*joiner_width, hoff*3/4, 10], center=true);
					}
				}
			}
		}

		// braces
		up(rail_height/2-platform_thick/2) {
			fwd(joiner_length-platform_thick*2+0.01) {
				xflip_copy() {
					left(side_mount_spacing/2) {
						right_half(200) {
							xrot(-90) trapezoid([hoff*1.2, platform_thick], [joiner_width/3, platform_thick], h=hoff+joiner_length-platform_thick*2-6, center=false);
						}
					}
				}
			}
		}

		// Connect top half-joiners.
		up(rail_height/2-platform_thick/2) {
			back(platform_thick-joiner_length) {
				cube(size=[platform_width-joiner_width, platform_thick*2, platform_thick], center=true);
			}
		}

		// Vertical support
		up(rail_height/2/2-platform_thick/2) {
			back(platform_thick-joiner_length) {
				cube(size=[platform_thick, platform_thick*2, rail_height/2], center=true);
			}
		}

		// Remove indents on attachment to main body
		fwd(joiner_length/2) {
			xspread(side_mount_spacing) {
				cube(size=[joiner_width, joiner_length, joiner_width], center=true);
			}
		}

		// Rack and pinion hard stop.
		endstop_h = platform_z - motor_top_z - 5 - 2;
		down(endstop_h/2-0.05) {
			fwd(joiner_length-(joiner_length-hardstop_offset)/2) {
				cube(size=[rail_spacing-joiner_width+1, joiner_length-hardstop_offset, endstop_h], center=true);
			}
		}

		// Horizontal Bracing
		down((rail_offset-3)/2-0.05) {
			fwd(joiner_length-(joiner_length-hardstop_offset)/2) {
				cube(size=[platform_width-2*joiner_width+1, joiner_length-hardstop_offset, rail_offset-3], center=true);
			}
		}
	}
}
//!xy_joiner();



module xy_joiner_parts() { // make me
	up(joiner_length) zrot(-90) xrot(90) xy_joiner();
}



xy_joiner_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

