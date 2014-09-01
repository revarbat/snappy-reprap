include <config.scad>
use <GDMUtils.scad>
use <slider_sled.scad>



module z_sled(show_rollers=false)
{
	slider_sled(show_rollers=show_rollers, with_rack=false, nut_size=lifter_nut_size, nut_thick=lifter_nut_thick);
}



module z_sled_part() { // make me
	zrot(90) z_sled();
}



z_sled_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

