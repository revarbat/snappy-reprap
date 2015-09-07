include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <cable_chain.scad>



module platform_support1()
{
	joiner_length=10;
	w=20;
	l=(max(glass_width,hbp_width)-platform_width)/2;
	h=3;
	hole_xoff = (hbp_hole_length/2 - platform_length - 20.5 + joiner_width/2);
	hole_yoff = -(hbp_hole_width - platform_width)/2;

	color("Chocolate")
	prerender(convexity=10)
	difference() {
		union() {
			// Side support strut
			translate([-(joiner_width-0.1)/2, -joiner_length*3/4, h-20/2-0.1]) {
				left_half() {
					trapezoid([0.1, joiner_length/2], [w*2, joiner_length/2], h=20, center=true);
				}
			}

			// Side strut
			translate([-(w-joiner_width)/2, -joiner_length/2, h/2]) {
				cube(size=[w, joiner_length, h], center=true);
			}

			// Clip platform
			translate([(hole_xoff+3-w/2), -l/2, h/2]) {
				cube(size=[w, l, h], center=true);
			}

			// joiners.
			down(platform_height/2-0.05) {
				chamfer(chamfer=joiner_width/3, size=[joiner_width, 2*joiner_length, platform_height], edges=[[0,0,0,0], [0,0,1,1], [0,0,0,0]]) {
					joiner(h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
			}
		}
		translate([hole_xoff, hole_yoff, 0])
			cylinder(h=h*3, d=hbp_screwsize*1.1, center=true, $fn=8);
	}
}
//!platform_support1();



module platform_support2()
{
	joiner_length=10;
	w=20;
	l=(max(glass_width,hbp_width)-platform_width)/2;
	h=3;
	hole_xoff = -(hbp_hole_length/2 - platform_length - 20 + joiner_width/2);
	hole_yoff = -(hbp_hole_width - platform_width)/2;

	color("Chocolate")
	prerender(convexity=10)
	difference() {
		union() {
			// Side support strut
			translate([(joiner_width-0.1)/2, -joiner_length*3/4, h-20/2-0.1]) {
				right_half() {
					trapezoid([0.1, joiner_length/2], [w*2, joiner_length/2], h=20, center=true);
				}
			}

			// Side strut
			translate([(w-joiner_width)/2, -joiner_length/2, h/2]) {
				cube(size=[w, joiner_length, h], center=true);
			}

			// Clip platform
			translate([(hole_xoff-3+w/2), -l/2, h/2]) {
				cube(size=[w, l, h], center=true);
			}

			// joiners.
			down(platform_height/2-0.05) {
				chamfer(chamfer=joiner_width/3, size=[joiner_width, 2*joiner_length, platform_height], edges=[[0,0,0,0], [0,0,1,1], [0,0,0,0]]) {
					yrot(180) joiner(h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
			}
		}
		translate([hole_xoff, hole_yoff, 0])
			cylinder(h=h*3, d=hbp_screwsize*1.1, center=true, $fn=8);
	}
}
//!platform_support2();



module platform_support3()
{
	joiner_length=10;
	w=20;
	l=(max(glass_width,hbp_width)-platform_width)/2;
	h=3;
	hole_xoff = (hbp_hole_length/2 - platform_length - 20.5 + joiner_width/2);
	hole_yoff = -(hbp_hole_width - platform_width)/2;

	color("Chocolate")
	prerender(convexity=10)
	difference() {
		union() {
			// Side support strut
			translate([-(joiner_width-0.1)/2, -joiner_length*3/4, h-20/2-0.1]) {
				left_half() {
					trapezoid([0.1, joiner_length/2], [w*2, joiner_length/2], h=20, center=true);
				}
			}

			// Side strut
			translate([-(w-joiner_width)/2, -joiner_length/2, h/2]) {
				cube(size=[w, joiner_length, h], center=true);
			}

			// Clip platform
			translate([(hole_xoff+3-w/2), -l/2, h/2]) {
				cube(size=[w, l, h], center=true);
			}

			// joiners.
			down(platform_height/2-0.05) {
				chamfer(chamfer=joiner_width/3, size=[joiner_width, 2*joiner_length, platform_height], edges=[[0,0,0,0], [0,0,1,1], [0,0,0,0]]) {
					joiner(h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
			}

			// cable chain mount
			fwd(cable_chain_width/2+5) {
				right(8-0.05) {
					up(3) {
						zrot(90) xrot(180) {
							cable_chain_mount2();
							cable_chain_barrel();
						}
					}
				}
			}
		}
		translate([hole_xoff, hole_yoff, 0])
			cylinder(h=h*3, d=hbp_screwsize*1.1, center=true, $fn=8);
	}
}
//!platform_support3();



module platform_support_parts() { // make me
	zring(n=2) {
		up(3) {
			back(8) {
				left(30) xrot(180) platform_support2();
				right(30) xrot(180) platform_support1();
			}
		}
	}
	up(3) back(50) xrot(180) platform_support3();
}



platform_support_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

