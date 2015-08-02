include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 1;
$fs = 1.5;

thick = extruder_thick;
inset = 3;
h = 6;


module fan_clip()
{
	color("violet")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Base
				up(h-inset+thick/2) {
					difference() {
						union() {
							chamfcube([extruder_fan_size+8, extruder_fan_size+8, thick], chamfer=5, chamfaxes=[0,0,1], center=true);
							cube([extruder_fan_size+3*joiner_width, extruder_fan_size/2, thick], center=true);
						}
						cylinder(d=extruder_fan_size, h=100, center=true);
						down(thick/2) {
							cube([extruder_fan_size+2*printer_slop, extruder_fan_size+2*printer_slop, inset*2], center=true);
						}
					}
					up(inset/2) {
						cylinder(d=extruder_fan_size/2.5, h=thick-inset, center=true);
						zring(n=8, r=extruder_fan_size/4) {
							cube([extruder_fan_size/2+1, 3, thick-inset], center=true);
						}
					}
				}
			}

			// Fan Shroud joiner clearance
			xspread(extruder_fan_size+2*joiner_width) {
				xrot(-90) half_joiner_clear(h=extruder_fan_size/2, w=joiner_width, a=joiner_angle, clearance=2);
			}
		}

		// Fan Shroud Joiners
		xspread(extruder_fan_size+2*joiner_width) {
			xrot(-90) half_joiner(h=extruder_fan_size/2, w=joiner_width, l=h+thick-inset, a=joiner_angle);
		}
	}
}



module fan_clip_parts() { // make me
	up(h+thick-inset) xrot(180) fan_clip();
}



fan_clip_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
