include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 2;
$fs = 2;

h = 6;
thick = 8;
inset = thick-2.5;


module extruder_fan_clip()
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
					up((inset+1)/2) {
						cylinder(d=extruder_fan_size/2, h=thick-inset-1, center=true);
						zring(n=8, r=extruder_fan_size/4) {
							cube([extruder_fan_size/2+1, 3, thick-inset-1], center=true);
						}
					}
				}
			}

			// Fan clip joiner clearance
			xspread(extruder_fan_size+2*joiner_width) {
				xrot(-90) half_joiner_clear(h=extruder_fan_size/2, w=joiner_width, a=joiner_angle, clearance=2);
			}
		}

		// Fan clip Joiners
		xspread(extruder_fan_size+2*joiner_width) {
			xrot(-90) half_joiner(h=extruder_fan_size/2, w=joiner_width, l=h+thick-inset, a=joiner_angle);
		}
	}
}



module extruder_fan_clip_parts() { // make me
	up(h+thick-inset) xrot(180) extruder_fan_clip();
}



extruder_fan_clip_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
