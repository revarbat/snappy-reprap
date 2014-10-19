use <GDMUtils.scad>



module vee_rail(w=10, l=100, h=15, rail=10, ang=30)
{
	ang2 = 75.0;
	prerender(convexity=4)
	difference() {
		translate([0, 0, (h-rail)/2])
			cube(size=[w, l, h], center=true);
		grid_of(xa=[-w/2, w/2]) {
			scale([tan(ang),1,1]) {
				difference() {
					yrot(45) {
						chamfcube(size=[rail/sqrt(2), l+2, rail/sqrt(2)], chamfer=1, chamfaxes=[1,0,1], center=true);
					}
					translate([0,0,rail/4]) {
						cube(size=[rail, l+2, rail/2], center=true);
					}
				}
			}
			scale([1,1,tan(90-ang2)]) {
				yrot(45) {
					chamfcube(size=[tan(ang)*rail/sqrt(2), l+2, tan(ang)*rail/sqrt(2)], chamfer=1, chamfaxes=[1,0,1], center=true);
				}
			}
		}
	}
}



module vee_slider(w=10, l=100, h=20, rail=10, ang=30, wall=4, slop=0.25)
{
	ang2 = 75.0;
	prerender(convexity=4)
	union() {
		difference() {
			translate([0,0,-(rail/2+wall)/2+(rail*tan(ang)*tan(90-ang2))/4])
				cube(size=[w+wall*2, l, rail/2+(rail*tan(ang)*tan(90-ang2))/2+wall], center=true);
			cube(size=[w+slop*2, l, rail+slop*3], center=true);
		}
		grid_of(xa=[-(w/2+slop), (w/2+slop)]) {
			difference() {
				union() {
					scale([tan(ang),1,1]) {
						difference() {
							yrot(45) {
								cube(size=[rail/sqrt(2), l, rail/sqrt(2)], center=true);
							}
							translate([0,0,rail/4]) {
								cube(size=[rail, l, rail/2], center=true);
							}
						}
					}
					scale([1,1,tan(90-ang2)]) {
						yrot(45) {
							cube(size=[tan(ang)*rail/sqrt(2), l, tan(ang)*rail/sqrt(2)], center=true);
						}
					}
				}
				grid_of(ya=[-l/2, l/2]) {
					translate([0,0,-rail/2]) {
						yrot_copies([-ang,ang]) {
							translate([0,0,rail/4])
								zrot(45) cube(size=[1/sqrt(2), 1/sqrt(2), rail], center=true);
						}
					}
					translate([0,0,tan(ang)*tan(90-ang2)*rail/2]) {
						yrot_copies([-ang2,ang2]) {
							translate([0,0,-rail/4])
								zrot(45) cube(size=[1/sqrt(2), 1/sqrt(2), rail], center=true);
						}
					}
				}
			}
		}
	}
}



module test_slider_parts()
{
	translate([-20, 0, 0]) {
		translate([0, 0, 1.5]) {
			cube(size=[20, 100, 3], center=true);
		}
		translate([0, 0, 10]) {
			circle_of(n=2, rot=true, r=10) {
				zrot(180) yrot(180) vee_rail();
			}
		}
	}
	translate([20, 0, 0]) {
		translate([0, 0, 1.5]) {
			cube(size=[20, 100, 3], center=true);
		}
		translate([0, 0, 5+4]) {
			circle_of(n=2, rot=true, r=10) {
				vee_slider();
			}
		}
	}
}
test_slider_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

