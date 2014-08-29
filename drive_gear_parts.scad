include <config.scad>
use <GDMUtils.scad>
use <publicDomainGearV1.1.scad>


module drive_gear() {
	h = 10;
	render(convexity=10) union() {
		difference() {
			mirror_copy([0, 0, 1]) {
				translate([0, 0, h/4]) {
					gear (
						mm_per_tooth    = 5,
						number_of_teeth = 9,
						thickness       = h/2,
						hole_diameter   = 5,
						twist           = 15,
						teeth_to_hide   = 0,
						pressure_angle  = 20
					);
				}
			}
			tube(h=6, r1=20, r2=7.5, wall=4);
		}
		difference() {
			union() {
				cylinder(h=h, r=5.5, center=true);
				translate([0, 0, -(h+7)/2])
					cylinder(h=7, r=9, center=true);
			}
			cylinder(h=(h+5)*3, r=5.1/2, center=true, $fn=16);
			translate([5/2+1, 0, -(h/2+12)/2]) {
				yrot(90) {
					scale([1.1, 1.1, 1.1]) hull() {
						metric_nut(size=3, hole=false);
						translate([5, 0, 0])
							metric_nut(size=3, hole=false);
					}
					translate([0, 0, 2])
						cylinder(r=3.2/2, h=9, center=true, $fn=8);
				}
			}
		}
	}
}
//!drive_gear();


module drive_gear_parts() { // make me
	translate([0, 0, 5+7])
		circle_of(r=15, n=2)
			drive_gear();
}



drive_gear_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

