include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>



module lifter_nut()
{
	$fn=24;
	color("DeepSkyBlue") {
		acme_threaded_nut(
			od=lifter_nut_size,
			id=lifter_rod_diam,
			h=lifter_nut_thick,
			threading=lifter_thread_size,
			thread_depth=0.5
		);
	}
}



module lifter_nut_part() { // make me
	grid_of(
		ya=[-15, 15],
		za=[lifter_nut_thick/2]
	) {
		yrot(180) lifter_nut();
	}
}



lifter_nut_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

