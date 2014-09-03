include <config.scad>
use <GDMUtils.scad>
use <z_nut_cap_part.scad>
use <nut_capture.scad>



module test_part() { // make me
	translate([-15, 0, 0])
		zrot(90)
			nut_capture(
				nut_size=lifter_nut_size,
				nut_thick=lifter_nut_thick,
				offset=roller_base+roller_thick/2
			);
	translate([ 15, 0, 2]) yrot(180) zrot(90) z_nut_cap();
}



test_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

