include <config.scad>
use <GDMUtils.scad>



module capture_nut_cap()
{
	nut_rad = lifter_nut_size/cos(30)/2;

	color("DeepSkyBlue") union() {
		// cap
		translate([0, 0, 2/2])
			cube(size=[lifter_nut_size+6, lifter_nut_thick+6, 2], center=true);

		difference() {
			// Plug
			translate([0, 0, -lifter_nut_size/3/2])
				cube(size=[lifter_nut_size+0.75, lifter_nut_thick, lifter_nut_size/3], center=true);

			// Remove nut area.
			translate([0, 0, roller_base+roller_thick/2-lifter_nut_size-roller_thick]) {
				zrot(90) yrot(90) {
					cylinder(h=lifter_nut_thick+2, r=nut_rad+0.5, center=true, $fn=6);
				}
			}
		}

		// Snap ridges
		grid_of(xa=[-(lifter_nut_size+0.75)/2, (lifter_nut_size+0.75)/2]) {
			translate([0, 0, -3])
				scale([0.5, 1, 1]) yrot(45) cube(size=[1, 5, 1], center=true);
		}
	}
}



module capture_nut_cap_part() { // make me
	grid_of(ya=[-15, 15]) {
		translate([0, 0, 2])
			yrot(180) capture_nut_cap();
	}
}



capture_nut_cap_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

