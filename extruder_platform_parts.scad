include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module extruder_platform()
{
	color("LightSteelBlue") difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0,0,rail_thick/2])
						cube(size=[rail_width, rail_length, rail_thick], center=true);

					// Walls.
					grid_of(
						xa=[-(rail_spacing/2+joiner_width/2), (rail_spacing/2+joiner_width/2)],
						za=[(rail_height+groove_height)/2]
					) {
						thinning_triangle(h=rail_height+groove_height, l=rail_length-2*12, thick=joiner_width, strut=rail_thick);
					}
				}

				// Blunt off end of platform.
				translate([0, rail_length/2+rail_thick*2, 0])
					cube(size=[rail_width+1, rail_length/2, rail_height*3], center=true);

				// Clear space out near clips.
				grid_of(
					xa=[-(rail_spacing+joiner_width)/2, (rail_spacing+joiner_width)/2],
					ya=[-rail_length/2],
					za=[(rail_height)/4, (rail_height)*3/4]
				) {
					scale([1, tan(joiner_angle), 1]) xrot(45)
						cube(size=rail_height/2/sqrt(2), center=true);
				}

				// Extruder mount holes.
				circle_of(r=25, n=4) {
					cylinder(r=4.5/2, h=20, center=true);
				}

				// Extruder hole.
				cylinder(r=16, h=20, center=true);

				// Wiring Access hole.
				grid_of(xa=[-30, 30], ya=[-40])
					cylinder(r=10, h=20, center=true);
			}

			// Rail backing.
			grid_of([-(rail_spacing+joiner_width)/2, (rail_spacing+joiner_width)/2])
				translate([0,-(rail_length-12)/2,rail_height+groove_height/2])
					cube(size=[joiner_width, 12, groove_height], center=true);


			// Joiner clips.
			translate([0,0,rail_height/2]) {
				zrot_copies([180]) {
					yrot_copies([0,180]) {
						translate([rail_spacing/2+joiner_width/2, rail_length/2, 0]) {
							joiner(h=rail_height, w=joiner_width, l=12, a=joiner_angle);
						}
					}
				}
			}
		}
	}
}
//!rail_structure();



module extruder_platform_parts() { // make me
	extruder_platform();
}



extruder_platform_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

