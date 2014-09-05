include <config.scad>
use <GDMUtils.scad>
use <slider_sled.scad>
use <nut_capture.scad>
use <lifter_nut_part.scad>



module z_sled()
{
	// Quantize nut housing spacing to the thread lift size.
	nut_spacing = floor((platform_length-20)/lifter_thread_size) * lifter_thread_size;

	color("DeepSkyBlue") union() {
		// Base slider sled.
		slider_sled(with_rack=false);

		// Length-wise bracing.
		translate([0,0,platform_thick/2]) {
			cube(size=[14,platform_length,platform_thick], center=true);
		}

		// Drive nut capture
		grid_of(ya=[-nut_spacing/2, nut_spacing/2]) {
			nut_capture(
				nut_size=lifter_nut_size,
				nut_thick=lifter_nut_thick,
				offset=roller_base+roller_thick/2
			);
		}
	}
}



module z_sled_rollers()
{
	slider_rollers();
}



module z_sled_nuts()
{
	// Quantize nut housing spacing to the thread lift size.
	nut_spacing = floor((platform_length-20)/lifter_thread_size) * lifter_thread_size;

	// Drive nut capture
	grid_of(
		ya=[-nut_spacing/2, nut_spacing/2],
		za=[(roller_base+roller_thick/2)]
	) {
		zrot(90) yrot(-90) lifter_nut();
	}
}



module z_sled_part() { // make me
	zrot(90) z_sled();
}



z_sled_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

