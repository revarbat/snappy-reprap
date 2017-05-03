include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>

$fa = 2;
$fs = 1.5;


module snappy_logo() {
	up(3/2) {
		xrot(180) {
			difference() {
				cube([rail_length-8, rail_height, 3], center=true);
				linear_extrude(height=4, convexity=10) {
					xscale(0.92) text(text="Snappy v1.5", font="Marker Felt:style=Thin", size=19, halign="center", valign="center");
				}
				xspread(rail_length-8) {
					yspread(rail_height) {
						yscale(1.5) chamfer_mask_z(l=5, chamfer=8);
					}
				}
			}
		}
	}
	zrot(bridge_arch_angle) {
		up(10) {
			xspread(rail_length-2*printer_slop-2*joiner_width-1) {
				difference() {
					xrot(90) half_joiner(h=rail_height/2, w=joiner_width, l=8, a=joiner_angle);
					xspread(joiner_width) {
						yspread(rail_height/2) {
							chamfer_mask_z(l=30, chamfer=joiner_width/3);
						}
					}
				}
			}
		}
	}
}


module snappy_logo_parts() { // make me
	snappy_logo();
}


snappy_logo_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

