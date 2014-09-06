include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rails_end()
{
	joiner_length=15;
	base_height = rail_height+roller_thick;
	color("YellowGreen") difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0, -(joiner_length+rail_thick)/2, rail_thick/2])
						cube(size=[rail_width, joiner_length+rail_thick, rail_thick], center=true);

					// Back.
					translate([0, -joiner_length-rail_thick/2+0.05, base_height/2]) zrot(90)
						thinning_wall(h=base_height, l=rail_width, thick=rail_thick, strut=joiner_width, bracing=false);
				}

				// Clear space for joiners.
				translate([0, 0, base_height/2-(base_height-rail_height)/2]) {
					joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, a=joiner_angle);
				}
			}

			// Corner pieces.
			grid_of(
				xa=[-(rail_spacing+joiner_width)/2, (rail_spacing+joiner_width)/2],
				za=[base_height]
			) {
				translate([0, -joiner_length/2, -(base_height-rail_height)/2])
					cube(size=[joiner_width, joiner_length, (base_height-rail_height)], center=true);
			}

			// Joiner clips.
			translate([0, 0, base_height/2-(base_height-rail_height)/2]) {
				joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}
		}
	}
}
//!rails_end();



module rails_end_part() { // make me
	zrot(90) rails_end();
}


rails_end_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

