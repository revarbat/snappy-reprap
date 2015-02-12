include <config.scad>
use <GDMUtils.scad>


module lifter_rod_coupler()
{
	diam = 30;
	height = 30;
	color("SpringGreen")
	translate([0,0,height/2])
	difference () {
		cylinder(h=height, d=diam, center=true);
		translate([0, 0, -height/4])
			cylinder(h=height/2+0.1, d=motor_shaft_size+printer_slop*2, center=true, $fn=24);
		translate([0, 0, height/4])
			cylinder(h=height/2+0.1, d=lifter_rod_diam+printer_slop*2, center=true, $fn=24);
		translate([diam/4, 0, 0]) {
			cube(size=[diam/2+0.1, 1, height+0.1], center=true);
		}
		translate([(diam+lifter_rod_diam)/2/2, 0, 0]) {
			mirror_copy([0,0,1]) {
				translate([0, 0, height/2-set_screw_size-2]) {
					xrot(90) cylinder(h=diam+0.1, d=set_screw_size*1.1, center=true, $fn=24);
					translate([0, -(diam/4+3), 0]) {
						xrot(90) cylinder(d=set_screw_size*2, h=diam/2, center=true, $fn=24);
					}
					translate([0, 5, height/8]) {
						hull() {
							grid_of(count=[1,1,2], spacing=height/4) {
								xrot(90) zrot(90) metric_nut(size=3, hole=false);
							}
						}
					}
				}
			}
		}
	}
}
!lifter_rod_coupler();


module lifter_rod_coupler_parts() { // make me
	lifter_rod_coupler();
}


lifter_rod_coupler_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

