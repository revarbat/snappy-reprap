include <config.scad>
use <GDMUtils.scad>
use <slider_sled.scad>



module z_sled_part() { // make me
	zrot(90) slider_sled(with_rack=false, nut_size=lifter_nut_size, nut_thick=lifter_nut_thick);
}



z_sled_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

