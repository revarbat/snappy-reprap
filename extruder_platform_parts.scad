include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module extruder_platform()
{
	platform_vert_off = rail_height+groove_height+rail_offset;
	l = motor_rail_length*0.5+platform_length-platform_vert_off-15;
	w = platform_width;
	h = rail_height;

	color("LightSteelBlue")
	render(convexity=10)
	translate([0, l, 0])
	union() {
		difference() {
			union() {
				// Bottom.
				translate([0, -(0.4*l), rail_thick/2])
					rrect(r=joiner_width, size=[platform_width, 1.2*l, rail_thick], center=true);

				// Walls.
				grid_of(
					xa=[-(w-joiner_width)/2, (w-joiner_width)/2],
					ya=[-(l-l*0.75/2-10)],
					za=[(h-12)/2]
				) {
					thinning_triangle(h=h-12, l=l*0.75, thick=joiner_width, strut=rail_thick, diagonly=true);
				}

				// Triangle Backing
				mirror_copy([1,0,0]) {
					translate([(w-joiner_width-5)/2, -l+10/2, (h-12)/2]) {
						cube(size=[joiner_width+5, 10, h-12], center=true);
					}
				}
			}

			// Blunt off end of platform.
			translate([0, l+rail_thick*2, 0])
				cube(size=[platform_width+1, l, h*3], center=true);

			// Extruder mount holes.
			circle_of(r=25, n=2) {
				cylinder(r=4.5/2, h=20, center=true);
			}

			// Extruder hole.
			rrect(r=10, size=[40, 60, 20], center=true);
		}

		// Pivot backings
		mirror_copy([1,0,0]) {
			translate([(w-joiner_width-4.5)/2-5.5, -l-6, h-6]) {
				difference() {
					xrot(joiner_angle) {
						translate([0, 0, -12/sin(joiner_angle)/2]) {
							cube(size=[4.5, 12, 12/sin(joiner_angle)], center=true);
						}
					}
					translate([0, 12+10, -12*2*sin(joiner_angle)])
						cube(size=[4.5, 12, 12/sin(joiner_angle)], center=true);
				}
			}
			translate([(w-joiner_width-4.5)/2-5.5, -l-6, h-6]) {
				yrot(90) cylinder(h=4.5, r=6, center=true);
			}
		}

		// Pivot
		mirror_copy([1,0,0]) {
			translate([w/2-joiner_width, -l-6, h-6]) {
				yrot(90) intersection() {
					cylinder(h=2, r1=6, r2=4, center=true);
					cylinder(h=2, r=6, center=true);
				}
			}
		}

		// Z endstop block.
		translate([0, -l+10/2, 15/2]) {
			cube(size=[20, 10, 15], center=true);
		}
	}
}
//!rail_structure();



module extruder_platform_parts() { // make me
	extruder_platform();
}



extruder_platform_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

