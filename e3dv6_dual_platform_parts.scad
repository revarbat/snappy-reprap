include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <extruder_mount.scad>


$fa = 2;
$fs = 1;


module e3dv6_dual_platform()
{
	extruder_spread = 30;

	color("cornflowerblue")
	difference() {
		union() {
			extruder_platform(
				l=extruder_length,
				w=2*motor_length + extruder_shaft_len + 3*joiner_width,
				h=rail_height,
				thick=e3dv6_groove_thick
			);

			// Extruder mount
			zrot_copies([0, 180])
			left(extruder_spread/2)
			//render(convexity=10)
			extruder_additive(
				groove_thick=e3dv6_groove_thick,
				groove_diam=e3dv6_groove_diam,
				shelf=e3dv6_shelf_thick,
				cap=e3dv6_cap_height,
				barrel=e3dv6_barrel_diam,
				filament=filament_diam,
				drive_gear=extruder_drive_diam,
				shaft=extruder_shaft_len,
				idler=extruder_idler_diam,
				slop=printer_slop
			);
		}

		// Subtractive extruder parts
		zrot_copies([0, 180])
		left(extruder_spread/2)
		//render(convexity=10)
		extruder_subtractive(
			groove_thick=e3dv6_groove_thick,
			groove_diam=e3dv6_groove_diam,
			shelf=e3dv6_shelf_thick,
			cap=e3dv6_cap_height,
			barrel=e3dv6_barrel_diam,
			filament=filament_diam,
			drive_gear=extruder_drive_diam,
			shaft=extruder_shaft_len,
			idler=extruder_idler_diam,
			slop=printer_slop
		);
	}
}



module e3dv6_dual_platform_parts() { // make me
	e3dv6_dual_platform();
}



e3dv6_dual_platform_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
