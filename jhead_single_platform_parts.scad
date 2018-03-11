include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>
use <extruder_mount.scad>


$fa = 2;
$fs = 1;



module jhead_single_platform()
{
	motor_width = nema_motor_width(17);

	difference() {
		union() {
			extruder_platform(
				l=extruder_length,
				w=motor_width + extruder_drive_diam + 4*joiner_width + 5,
				h=rail_height,
				thick=jhead_groove_thick
			);

			// Extruder mount
			zrot(-90)
			render(convexity=10)
			extruder_additive(
				groove_thick=jhead_groove_thick,
				groove_diam=jhead_groove_diam,
				shelf=jhead_shelf_thick,
				cap=jhead_cap_height,
				barrel=jhead_barrel_diam,
				filament=filament_diam,
				drive_gear=extruder_drive_diam,
				shaft=extruder_shaft_len,
				idler=extruder_idler_diam,
				slop=printer_slop
			);
		}

		// Subtractive extruder parts
		zrot(-90)
		render(convexity=10)
		extruder_subtractive(
			groove_thick=jhead_groove_thick,
			groove_diam=jhead_groove_diam,
			shelf=jhead_shelf_thick,
			cap=jhead_cap_height,
			barrel=jhead_barrel_diam,
			filament=filament_diam,
			drive_gear=extruder_drive_diam,
			shaft=extruder_shaft_len,
			idler=extruder_idler_diam,
			slop=printer_slop
		);
	}
}



module jhead_single_platform_parts() { // make me
	jhead_single_platform();
}



jhead_single_platform_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
