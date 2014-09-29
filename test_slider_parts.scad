use <GDMUtils.scad>



module hourglass_rail(w=10, l=100, h=15, rail=10, ang=30)
{
	difference() {
		translate([0, 0, (h-rail)/2])
			cube(size=[w, l, h], center=true);
		grid_of(xa=[-w/2, w/2]) {
			scale([tan(ang),1,1]) {
				yrot(45) cube(size=[rail/sqrt(2), l+1, rail/sqrt(2)], center=true);
			}
		}
	}
}



module hourglass_slider(w=10, l=100, h=20, rail=10, ang=30, wall=4, slop=0.25)
{
	difference() {
		translate([0,0,-wall/2])
			cube(size=[w+2*wall, l, rail+wall], center=true);
		hourglass_rail(w=w+2*slop, l=l+2, h=h, rail=rail, ang=ang);
		translate([0, 0, -(rail/2+slop-0.05)])
			cube(size=[w+2*slop, l+2, slop*2], center=true);
	}
}



module test_slider_parts()
{
	grid_of(xa=[-20, 20]) {
		translate([0, 0, 1.5]) {
			cube(size=[20, 100, 3], center=true);
		}
		translate([-10, 0, 10]) {
			yrot(180) hourglass_rail();
		}
		translate([10, 0, 5+4]) {
			hourglass_slider();
		}
	}
}
test_slider_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

