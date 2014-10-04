include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module extruder_platform()
{
	platform_vert_off = rail_height+groove_height+rail_offset;
	l = motor_rail_length*0.5+platform_length-platform_vert_off-15;

	color("LightSteelBlue")
	render(convexity=10)
	translate([0, l, 0])
	difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0, -(0.4*l), rail_thick/2])
						rrect(r=joiner_width, size=[rail_width, 1.2*l, rail_thick], center=true);

					// Walls.
					grid_of(
						xa=[-(rail_spacing/2+joiner_width/2), (rail_spacing/2+joiner_width/2)],
						ya=[-(l-l*0.75/2-10)],
						za=[rail_height/2]
					) {
						thinning_triangle(h=rail_height, l=l*0.75, thick=joiner_width, strut=rail_thick, diagonly=true);
					}
				}

				// Blunt off end of platform.
				translate([0, l+rail_thick*2, 0])
					cube(size=[rail_width+1, l, rail_height*3], center=true);

				// Clear space out near clips.
				grid_of(
					xa=[-(rail_spacing+joiner_width)/2, (rail_spacing+joiner_width)/2],
					ya=[-l],
					za=[(rail_height)/4, (rail_height)*3/4]
				) {
					scale([1, tan(joiner_angle), 1]) xrot(45)
						cube(size=rail_height/2/sqrt(2), center=true);
				}

				// Extruder mount holes.
				circle_of(r=25, n=2) {
					cylinder(r=4.5/2, h=20, center=true);
				}

				// Extruder hole.
				rrect(r=10, size=[40, 60, 20], center=true);
			}

			// Joiner clips.
			translate([0,0,rail_height/2]) {
				zrot_copies([180]) {
					yrot_copies([0,180]) {
						translate([rail_spacing/2+joiner_width/2, l, 0]) {
							joiner(h=rail_height, w=joiner_width, l=10, a=joiner_angle);
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

