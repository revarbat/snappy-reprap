include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>

$fa = 2;
$fs = 2;


module lifter_rod_coupler()
{
	diam = 30;
	height = 30;

	color("SpringGreen")
	difference () {
		cylinder(h=height, d=diam, center=true);
		down(height/4) {
			difference() {
				cylinder(h=height/2+0.1, d=motor_shaft_size, center=true, $fn=24);
				if (motor_shaft_flatted) {
					left(motor_shaft_size-0.5) {
						cube(size=[motor_shaft_size, motor_shaft_size, height/2], center=true);
					}
				}
			}
		}
		up(height/2-2/2) {
			cylinder(h=2+0.05, d1=lifter_rod_diam-lifter_rod_pitch/4, d2=lifter_rod_diam+2, center=true);
		}
		down(height/2-2/2) {
			cylinder(h=2+0.05, d1=motor_shaft_size+2, d2=motor_shaft_size, center=true);
		}
		up(height/4) {
			acme_threaded_rod(
				d=lifter_rod_diam+2*printer_slop,
				l=height/2+0.1,
				pitch=lifter_rod_pitch,
				thread_depth=lifter_rod_pitch/4,
				$fn=32
			);
		}
		right(diam/4)
			cube(size=[diam/2+0.1, 2, height+0.1], center=true);
		right((diam+lifter_rod_diam)/2/2-1) {
			mirror_copy([0,0,1]) {
				up(height/2-set_screw_size-2) {
					xrot(90) cylinder(h=diam+0.1, d=set_screw_size*1.1, center=true, $fn=24);
					fwd(diam/4+4)
						xrot(90) cylinder(d=set_screw_size*2, h=diam/2, center=true, $fn=24);
					translate([0, 6, height/8]) {
						hull() {
							zspread(height/4) {
								xrot(90) zrot(90) {
									scale([1.05,1.05,1.05]) {
										metric_nut(size=set_screw_size, hole=false);
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
//!lifter_rod_coupler();


module lifter_rod_coupler_parts() { // make me
	yspread(50) up(30/2) lifter_rod_coupler();
}


lifter_rod_coupler_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
