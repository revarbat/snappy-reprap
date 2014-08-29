include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rails_end()
{
	joiner_length=10;
	base_height = rail_height+roller_thick;
	difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0, -(joiner_length+rail_thick)/2, rail_thick/2])
						cube(size=[rail_width, joiner_length+rail_thick, rail_thick], center=true);

					// Back.
					translate([0, -joiner_length-rail_thick/2+0.05, base_height/2]) zrot(90)
						thinning_wall(h=base_height, l=rail_width, thick=rail_thick, strut=5);
				}

				// Clear space out near front clips.
				grid_of(
					xa=[-(rail_spacing+joiner_width)/2, (rail_spacing+joiner_width)/2],
					za=[(base_height)/4, (base_height)*3/4]
				) {
					scale([1, tan(joiner_angle), 1]) xrot(45)
						cube(size=base_height/2/sqrt(2), center=true);
				}
			}

			// Corner pieces.
			grid_of(
				xa=[-(rail_spacing+joiner_width)/2, (rail_spacing+joiner_width)/2],
				za=[base_height]
			) {
				translate([0, -(base_height-rail_height)/2-0.05, -(base_height-rail_height)/2-0.05])
					cube(size=[joiner_width, (base_height-rail_height-0.05), (base_height-rail_height+0.05)], center=true);
			}

			// Joiner clips.
			translate([0, 0, base_height/2-(base_height-rail_height)/2]) {
				yrot_copies([0,180]) {
					translate([rail_spacing/2+joiner_width/2, 0, 0]) {
						joiner(h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
					}
				}
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

