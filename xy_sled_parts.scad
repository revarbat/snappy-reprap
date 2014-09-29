include <config.scad>
use <GDMUtils.scad>
use <publicDomainGearV1.1.scad>
use <slider_sled.scad>


module herringbone_rack(l=100, h=10, w=10, tooth_size=5, CA=30)
{
	render(convexity=10) translate([-(rack_tooth_size/2), 0, 0]) {
		mirror_copy([0,0,1]) {
			skew_along_z(xang=CA) {
				intersection() {
					translate([-(l/2-rack_tooth_size/2), 0, h/4]) {
						rack(
							mm_per_tooth=rack_tooth_size,
							number_of_teeth=floor(l/rack_tooth_size),
							thickness=h/2,
							height=w,
							pressure_angle=20,
							backlash=0
						);
					}
					cube(size=[l, h*3, h*3], center=true);
				} 
			}
		}
	}
}
//!herringbone_rack(l=100, h=10, tooth_size=5, CA=30);



module xy_sled()
{
	color("MediumSlateBlue") union() {
		// Base slider sled.
		slider_sled();

		// Length-wise bracing.
		translate([0,0,platform_thick/2]) {
			translate([-10, 0, 1])
				cube(size=[14,platform_length,platform_thick+2], center=true);
		}

		// Drive rack
		translate([-8, 0, platform_thick+2+5]) {
			zrot(-90) herringbone_rack(l=platform_length, h=10, tooth_size=rack_tooth_size, CA=30);
		}
	}
}



module xy_sled_parts() { // make me
	zrot(90) xy_sled();
}


xy_sled_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

