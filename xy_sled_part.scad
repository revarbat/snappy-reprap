include <config.scad>
use <GDMUtils.scad>
use <slider_sled.scad>


module xy_sled(show_rollers=false)
{
	slider_sled(show_rollers=show_rollers, with_rack=true);
}



module xy_sled_part() { // make me
	zrot(90) xy_sled();
}


xy_sled_part();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

