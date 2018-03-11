include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 2;
$fs = 1.5;


module jhead_barrel_fan_shroud()
{
	wall = 2;
	pip_diam = 5;
	pip_height = 2;
	duct_len = 30;
	w = extruder_fan_size + 2*wall;
	h = extruder_fan_thick + wall;
	heatsink_len = extruder_length/4-12;

	color("lightpink")
	union() {
		union() {
			// Fan holder
			difference() {
				upcube([w, w, h]);
				down(0.01) upcube([w-2*wall, w-2*wall, h-wall]);
				zrot(360/8/2) cylinder(d=(w-2*wall)/cos(360/8/2), h=4*h, center=false, $fn=8);
			}

			// Pips
			up(pip_diam/2+2) {
				yflip_copy() {
					fwd(w/2) {
						xrot(90) cylinder(d1=pip_diam+2*pip_height, d2=pip_diam, h=pip_height, center=false);
					}
				}
			}
		}

		// Duct
		up(h-0.01) {
			skew_xy(yang=atan2((w-jhead_heatsink_span)/2, duct_len)) {
				difference() {
					trapezoid([w, w], [jhead_heatsink_diam, jhead_heatsink_span], h=duct_len, center=false);
					down(0.01) trapezoid([w-2*wall, w-2*wall], [jhead_heatsink_diam-2*wall, jhead_heatsink_span-2*wall], h=duct_len+0.02, center=false);
				}
			}
		}
	}
	children();
}



module jhead_barrel_fan_shroud_parts() { // make me
	jhead_barrel_fan_shroud();
}



jhead_barrel_fan_shroud_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
