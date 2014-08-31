include <config.scad>
use <GDMUtils.scad>



module cap(r=roller_axle/2-3, h=10, wall=3, cap=2, lip=1.5)
{
	difference() {
		union() {
			translate([0,0,-cap/2])
				cylinder(r=r+lip+wall, h=cap, center=true, $fn=32);
			translate([0,0,h*3/8])
				cylinder(r1=r-0.5, r2=r, h=h*3/4, center=true, $fn=32);
			translate([0,0,h*7/8])
				cylinder(r1=r, r2=r-wall/2, h=h*1/4, center=true, $fn=32);
		}
		translate([0,0,h/2+1])
			cylinder(r=r-wall, h=h+1, center=true, $fn=12);
		zrot_copies([0,90]) translate([0,0,h*5/8])
			cube(size=[1,r*2,h],center=true);
	}
}
//cap();



module cap_parts() { // make me
	num_x = 4;
	num_y = 5;
	spacing = 25;
	render(convexity=4) grid_of(
		xa=[-spacing*(num_x-1)/2:spacing:spacing*(num_x-1)/2],
		ya=[-spacing*(num_y-1)/2:spacing:spacing*(num_y-1)/2],
		za=[2]
	) cap(r=roller_axle/2-3, h=10, lip=2, wall=3);
}


cap_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

