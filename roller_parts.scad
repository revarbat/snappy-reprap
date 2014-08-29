include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module roller()
{
	render(convexity=2) difference() {
		union() {
			translate([0,0,-roller_thick/4])
				cylinder(h=roller_thick/2, r1=roller_diam/2, r2=roller_diam/2+(roller_thick/2)*tan(roller_angle), center=true, $fn=48);
			cylinder(h=0.05, r=roller_diam/2+(roller_thick/2)*tan(roller_angle), center=true, $fn=48);
			translate([0,0,roller_thick/4])
				cylinder(h=roller_thick/2, r2=roller_diam/2, r1=roller_diam/2+(roller_thick/2)*tan(roller_angle), center=true, $fn=48);
		}
		cylinder(h=roller_thick+2.1, r=roller_axle/2, center=true, $fn=32);
	}
}
//!roller();



module roller_parts() { // make me
	num_x = 3;
	num_y = 4;
	spacing = 40;
	grid_of(
		xa=[-spacing*(num_x-1)/2:spacing:spacing*(num_x-1)/2],
		ya=[-spacing*(num_y-1)/2:spacing:spacing*(num_y-1)/2],
		za=[roller_thick/2]
	) roller();
}



roller_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

