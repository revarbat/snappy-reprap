include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rail_structure()
{
	color("Lavender") difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0,0,rail_thick/2]) yrot(90)
						sparse_strut(h=rail_width, l=rail_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);

					// Walls.
					grid_of(xa=[-(rail_spacing/2+joiner_width/2), (rail_spacing/2+joiner_width/2)], za=[(rail_height+3)/2]) {
						thinning_wall(h=rail_height+3, l=rail_length-10*2, thick=joiner_width, strut=rail_thick);
					}
				}

				// Clear space out near clips.
				grid_of(
					xa=[-(rail_spacing+joiner_width)/2, (rail_spacing+joiner_width)/2],
					ya=[-rail_length/2, rail_length/2],
					za=[(rail_height)/4, (rail_height)*3/4]
				) {
					scale([1, tan(joiner_angle), 1]) xrot(45)
						cube(size=rail_height/2/sqrt(2), center=true);
				}
			}

			// Rail backing.
			grid_of([-(rail_spacing/2+joiner_width/2), (rail_spacing/2+joiner_width/2)])
				translate([0,0,rail_height+roller_thick/2])
					cube(size=[joiner_width, rail_length, roller_thick], center=true);

			// Joiner clips.
			translate([0,0,rail_height/2]) {
				zrot_copies([0,180]) {
					yrot_copies([0,180]) {
						translate([rail_spacing/2+joiner_width/2, rail_length/2, 0]) {
							joiner(h=rail_height, w=joiner_width, l=13, a=joiner_angle);
						}
					}
				}
			}

			zrot_copies([0, 180]) {
				translate([0, rail_length/2-8, rail_height/4]) {
					difference() {
						// Side supports.
						cube(size=[rail_width, 4, rail_height/2], center=true);

						// Wiring access holes.
						grid_of(xa=[-rail_width/4, rail_width/4])
							teardrop(r=5, h=5, center=true);
					}
				}
			}
		}

		// Rail grooves.
		translate([0,0,rail_height+roller_thick/2]) {
			grid_of([-(rail_spacing/2), (rail_spacing/2)]) {
				scale([tan(roller_angle),1,1]) yrot(45) {
					cube(size=[roller_thick*sqrt(2)/2,rail_length+1,roller_thick*sqrt(2)/2], center=true);
				}
			}
		}
	}
}
//!rail_structure();



module rails_part() { // make me
	rail_structure();
}



rails_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

