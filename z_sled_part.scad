include <config.scad>
use <GDMUtils.scad>
use <slider_sled.scad>



module z_sled()
{
	nut_size=lifter_nut_size;
	nut_thick=lifter_nut_thick;

	color("DeepSkyBlue") union() {
		// Base slider sled.
		slider_sled(with_rack=false);

		// Length-wise bracing.
		translate([0,0,platform_thick/2]) {
			cube(size=[14,platform_length,platform_thick], center=true);
		}

		// Drive nut capture.
		grid_of(ya=[-roller_spacing/2, roller_spacing/2]) {
			difference() {
				// Outer shell.
				translate([0, 0, (nut_size+roller_base)/2])
					cube(size=[nut_size+6, nut_thick+6, nut_size+roller_base], center=true);

				// Nut slot.
				translate([0, 0, roller_base+roller_thick/2]) {
					hull() {
						grid_of(za=[0, 20]) {
							zrot(90) yrot(90) {
								cylinder(h=nut_thick, r=(0.125+nut_size/2)/cos(30), center=true, $fn=6);
							}
						}
					}
				}
				
				// Rod access.
				translate([0, 0, roller_base+roller_thick/2]) {
					hull() {
						grid_of(za=[0, 20]) {
							scale([0.8, 3, 0.8]) zrot(90) yrot(90) {
								cylinder(h=nut_thick, r=nut_size/2, center=true, $fn=24);
							}
						}
					}
				}
			}
		}
	}
}



module z_sled_rollers()
{
	slider_rollers();
}



module z_sled_part() { // make me
	zrot(90) z_sled();
}



z_sled_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

