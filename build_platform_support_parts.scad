include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>



module build_platform_support1()
{
	joiner_length=10;
	w=40;
	l=(max(glass_width,hbp_width)-platform_width)/2;
	h=3;
	hole_xoff = (hbp_hole_length/2 - platform_length - 20 + joiner_width/2);
	hole_yoff = -(hbp_hole_width - platform_width)/2;

	color("Chocolate")
	prerender(convexity=10)
	difference() {
		union() {
			// Clip platform
			translate([-(w-joiner_width)/2, -l/2, h/2]) {
				cube(size=[w, l, h], center=true);
			}

			// joiners.
			translate([0, 0, -platform_height/2]) {
				joiner(h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}
		}
		translate([hole_xoff, hole_yoff, 0])
			cylinder(h=h*3, d=hbp_screwsize*1.1, center=true, $fn=8);
	}
}
//!build_platform_support1();



module build_platform_support2()
{
	joiner_length=10;
	w=40;
	l=(max(glass_width,hbp_width)-platform_width)/2;
	h=3;
	hole_xoff = -(hbp_hole_length/2 - platform_length - 20 + joiner_width/2);
	hole_yoff = -(hbp_hole_width - platform_width)/2;

	color("Chocolate")
	prerender(convexity=10)
	difference() {
		union() {
			// Clip platform
			translate([(w-joiner_width)/2, -l/2, h/2]) {
				cube(size=[w, l, h], center=true);
			}

			// Front joiners.
			translate([0, 0, -platform_height/2]) {
				yrot(180) joiner(h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}
		}
		translate([hole_xoff, hole_yoff, 0])
			cylinder(h=h*3, d=hbp_screwsize*1.1, center=true, $fn=8);
	}
}
//!build_platform_support2();



module build_platform_support_parts() { // make me
	zrot_copies([0, 180]) {
		translate([0, 10, 3]) {
			translate([-10, 0, 0])
				xrot(180) build_platform_support1();
			translate([10, 0, 0])
				xrot(180) build_platform_support2();
		}
	}
}



build_platform_support_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

