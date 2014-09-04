include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>



module lifter_nut()
{
	nut_rad = 0.5*lifter_nut_size/cos(30);
	$fn=24;

	color("DeepSkyBlue") {
		union() {
			// ACME threaded nut.
			acme_threaded_nut(
				od=lifter_nut_size,
				id=lifter_rod_diam,
				h=lifter_nut_thick,
				threading=lifter_thread_size,
				thread_depth=0.5
			);

			// top end
			difference() {
				translate([nut_rad*3/4, 0, 0])
					cube(size=[nut_rad/2, lifter_nut_size, lifter_nut_thick], center=true);
				cylinder(r=lifter_rod_diam/2+2, h=lifter_nut_thick, center=true);
			}
		}

		// Snap ridges
		grid_of(
			xa=[nut_rad-3],
			ya=[-lifter_nut_size/2, lifter_nut_size/2]
		) {
			scale([2.0, 1.0, lifter_nut_thick/2])
				zrot(45) cube(size=1/sqrt(2), center=true);
		}
	}
}



module lifter_nut_part() { // make me
	grid_of(
		ya=[-15, 15],
		za=[lifter_nut_thick/2]
	) {
		lifter_nut();
	}
}



lifter_nut_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

