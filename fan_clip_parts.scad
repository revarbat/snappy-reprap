include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 1;
$fs = 1.5;

thick = extruder_thick;
h = 6;


module fan_clip()
{
	color("violet")
	prerender(convexity=10)
	union() {
		// Base
		up(h-1+thick/2) {
			difference() {
				union() {
					chamfcube([extruder_fan_size+8, extruder_fan_size+8, thick], chamfer=5, chamfaxes=[0,0,1], center=true);
					cube([extruder_fan_size+3*joiner_width, extruder_fan_size/2, thick], center=true);
				}
				cylinder(d=extruder_fan_size, h=100, center=true);
				down(thick/2) {
					cube([extruder_fan_size+2*printer_slop, extruder_fan_size+2*printer_slop, 2], center=true);
				}
			}
			up(1/2) {
				cylinder(d=extruder_fan_size/2.5, h=thick-1, center=true);
				zring(n=12, r=extruder_fan_size/4) {
					cube([extruder_fan_size/2+1, 2, thick-1], center=true);
				}
			}
		}

		// Fan Shroud Joiners
		xspread(extruder_fan_size+2*joiner_width) {
			xrot(-90) half_joiner(h=extruder_fan_size/2, w=joiner_width, l=h+thick-1, a=joiner_angle);
		}
	}
}



module fan_clip_parts() { // make me
	up(h+thick-1) xrot(180) fan_clip();
}



fan_clip_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
