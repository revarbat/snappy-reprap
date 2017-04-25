include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rail_z_endcap()
{
	joiner_length=40;
	w = z_joiner_spacing + joiner_width;

	color("YellowGreen")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Bottom.
				translate([0, -joiner_length/2, rail_thick/2])
					cube(size=[w, joiner_length, rail_thick], center=true);

				// Back.
				translate([0, -joiner_length+rail_thick/2, rail_height/2]) zrot(90) {
					if (wall_style == "crossbeams")
						sparse_strut(h=rail_height, l=w-0.1, thick=rail_thick, strut=5);
					if (wall_style == "thinwall")
						thinning_wall(h=rail_height, l=w-0.1, thick=rail_thick, strut=5);
					if (wall_style == "corrugated")
						corrugated_wall(h=rail_height, l=w-0.1, thick=rail_thick, strut=5);
				}

				// Endstop clip
				fwd((endstop_depth+2)/2) {
					left((z_joiner_spacing-joiner_width-endstop_thick-2+0.05)/2-5) {
						up(rail_height-(endstop_length+2*2)/2) {
							difference() {
								left(5/2) cube([endstop_thick+2+5, endstop_depth+2, endstop_length+2*2], center=true);
								left(2/2) back(2/2) {
									cube([endstop_thick+2*printer_slop+0.05, endstop_depth+0.05, endstop_length+2*printer_slop], center=true);
									cube([endstop_thick+2*printer_slop-2, endstop_depth+10, endstop_length+2*printer_slop-1], center=true);
								}
							}
							down(endstop_length/2+2+endstop_thick*2/2+5/2-0.05) {
								left((endstop_thick+2)/2+5) {
									right_half() trapezoid([0.05, 0.05], [2*(endstop_thick+2+5), endstop_depth+2], h=endstop_thick*2+5, center=true);
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

			// Clear space for joiners.
			up(rail_height/2-0.05) {
				joiner_pair_clear(spacing=z_joiner_spacing, h=rail_height, w=joiner_width, a=joiner_angle, clearance=1);
			}
		}

		// Joiner clips.
		up(rail_height/2) {
			xspread(z_joiner_spacing) {
				joiner(h=rail_height, w=joiner_width, l=joiner_length-5/2, a=joiner_angle);
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

