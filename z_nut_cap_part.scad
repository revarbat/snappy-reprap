include <config.scad>
use <GDMUtils.scad>
use <nut_capture.scad>



module z_nut_cap()
{
	color("DeepSkyBlue") {
		nut_capture_cap(
			nut_size=lifter_nut_size,
			nut_thick=lifter_nut_thick,
			wall=3,
			cap_thick=2
		);
	}
}



module z_nut_cap_part() { // make me
	grid_of(ya=[-15, 15]) {
		translate([0, 0, 2])
			yrot(180) z_nut_cap();
	}
}



z_nut_cap_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

