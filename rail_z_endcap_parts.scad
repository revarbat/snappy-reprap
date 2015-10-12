include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rail_z_endcap()
{
	joiner_length=40;
	base_height = rail_height+groove_height;

	color("YellowGreen")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Bottom.
				translate([0, -joiner_length/2, rail_thick/2])
					cube(size=[rail_width, joiner_length, rail_thick], center=true);

				// Back.
				translate([0, -joiner_length+rail_thick/2, base_height/2]) zrot(90) {
					if (wall_style == "crossbeams")
						sparse_strut(h=base_height, l=rail_width-2*5, thick=rail_thick, strut=5);
					if (wall_style == "thinwall")
						thinning_wall(h=base_height, l=rail_width-joiner_width, thick=rail_thick, strut=joiner_width, bracing=false);
					if (wall_style == "corrugated")
						corrugated_wall(h=base_height, l=rail_width, thick=rail_thick, strut=joiner_width);
				}

				// Corner pieces.
				up(base_height-groove_height/2-0.01) {
					fwd(joiner_length/2) {
						xspread(rail_spacing+joiner_width) {
							cube(size=[joiner_width, joiner_length, groove_height+0.01], center=true);
						}
					}
				}
			}

			// Clear space for joiners.
			translate([0, 0, base_height/2-(base_height-rail_height)/2-0.05]) {
				joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, a=joiner_angle, clearance=5);
			}
		}

		// Joiner clips.
		translate([0, 0, base_height/2-(base_height-rail_height)/2]) {
			joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
		}

		// Endstop clip
		fwd((endstop_depth+2)/2) {
			left((rail_width-2*joiner_width-endstop_thick-2+0.05)/2) {
				up(rail_height+groove_height-(endstop_length+2*2)/2) {
					difference() {
						cube([endstop_thick+2, endstop_depth+2, endstop_length+2*2], center=true);
						left(2/2) back(2/2) {
							cube([endstop_thick+2*printer_slop+0.05, endstop_depth+0.05, endstop_length+2*printer_slop], center=true);
							cube([endstop_thick+2*printer_slop-2, endstop_depth+10, endstop_length+2*printer_slop-1], center=true);
						}
					}
					down(endstop_length/2+2+endstop_thick*2/2-0.05) {
						left((endstop_thick+2)/2) {
							right_half() trapezoid([0.05, 0.05], [2*(endstop_thick+2), endstop_depth+2], h=endstop_thick*2, center=true);
						}
					}
					zspread(endstop_hole_spacing) {
						right(endstop_thick/2-1.5/2+0.05) {
							back(endstop_depth/2+2/2-endstop_hole_inset) {
								scale([0.5, 1, 1]) {
									sphere(d=endstop_screw_size, center=true, $fn=8);
								}
							}
						}
					}
				}
			}
		}
	}
}
//!rail_z_endcap();



module rail_z_endcap_parts() { // make me
	zrot(-90) rail_z_endcap();
}


rail_z_endcap_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

