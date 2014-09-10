include <config.scad>
use <GDMUtils.scad>



module roller_cap(r=5.0, h=10, wall=3, cap=2, lip=1.5, shelf=2.4, slop=printer_slop)
{
	$fn = 16;
	color("Pink") difference() {
		union() {
			translate([0,0,-cap/2])
				cylinder(r=r+lip+wall, h=cap, center=true);
			translate([0,0,0.3/2])
				cylinder(r=r+shelf, h=0.3, center=true);
			translate([0,0,h*3/8])
				cylinder(r1=r-slop, r2=r-slop, h=h*3/4, center=true);
			translate([0,0,h*7/8])
				cylinder(r1=r-slop+0.6, r2=r-wall/2, h=h*1/4, center=true);
		}
		translate([0,0,h/2+1])
			cylinder(r=r-wall, h=h+1, center=true, $fn=8);
		zrot_copies([0,90]) translate([0,0,h*5/8])
			cube(size=[1,r*3,h],center=true);
	}
}
//roller_cap();



module roller_cap_parts() { // make me
	num_x = 4;
	num_y = 5;
	spacing = 25;
	render(convexity=4) grid_of(
		xa=[-spacing*(num_x-1)/2:spacing:spacing*(num_x-1)/2],
		ya=[-spacing*(num_y-1)/2:spacing:spacing*(num_y-1)/2],
		za=[2]
	) roller_cap(r=roller_axle/2-2.5-0.2, h=10, wall=3, lip=1.5, shelf=2.5);
}


roller_cap_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

