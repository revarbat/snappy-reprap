include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module extruder_platform()
{
	platform_vert_off = rail_height+groove_height+rail_offset;
	l = motor_rail_length*0.5+cantilever_length-platform_vert_off-15;
	w = platform_width;
	h = rail_height;

	color("LightSteelBlue")
	prerender(convexity=10)
	translate([0, l, 0])
	union() {
		difference() {
			union() {
				// Bottom.
				translate([0, -(0.4*l), rail_thick/2])
					rrect(r=joiner_width, size=[w, 1.2*l, rail_thick], center=true);

				// Walls.
				grid_of(
					xa=[-(w-joiner_width)/2, (w-joiner_width)/2],
					ya=[-(l-l*0.75/2-9)],
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
						yrot(90) cylinder(h=4.5, r=6, center=true, $fn=32);
					}
				}

				// Pivot
				mirror_copy([1,0,0]) {
					translate([w/2-joiner_width, -l-6, h-6]) {
						translate([2/2-0.5, 0, 0]) {
							yrot(90) intersection() {
								cylinder(h=2, r1=6, r2=4, center=true, $fn=32);
								cylinder(h=20, r=6, center=true, $fn=32);
							}
						}
					}
				}

				translate([0, -l+10/2+2, (rail_thick+endstop_click_voff+set_screw_size+endstop_standoff)/2]) {
					difference() {
						// Z endstop block.
						cube(size=[w-joiner_width, 10, (rail_thick+endstop_click_voff+set_screw_size+endstop_standoff)], center=true);

						// Z endstop adjustment screw nut slot.
						translate([0, 0, (rail_thick+endstop_click_voff-set_screw_size+endstop_standoff)/2]) {
							xrot(90) {
								cylinder(h=11, r=set_screw_size*1.1/2, center=true, $fn=12);
								hull() {
									grid_of(ya=[0, 5]) {
										zrot(90) metric_nut(size=set_screw_size, hole=false, center=true);
									}
								}
							}
						}
					}
				}
			}

			// Blunt off end of platform.
			translate([0, l+rail_thick*2, 0])
				cube(size=[w+1, l, h*3], center=true);

			// Extruder mount holes.
			circle_of(r=25, n=2) {
				cylinder(r=4.5/2, h=20, center=true);
			}

			// Extruder hole.
			rrect(r=10, size=[40, 60, 20], center=true);

			// Chamfer extruder hole corners.
			translate([0, l*0.2, h/2]) {
				grid_of(xa=[-40/2, 40/2]) {
					zrot(45) cube(size=[10/sqrt(2), 10/sqrt(2), h+1], center=true);
				}
			}

			// Chamfer back corners.
			translate([0, -l, h/2]) {
				grid_of(xa=[-w/2, w/2]) {
					zrot(45) cube(size=[10/sqrt(2), 10/sqrt(2), h+1], center=true);
				}
			}

			// Wiring acess holes.
			grid_of(
				xa=[-w/4, w/4],
				ya=[-l*0.6]
			) {
				cylinder(h=20, r=w/8, center=true);
			}

			// Pivot screw hole.
			mirror_copy([1,0,0]) {
				translate([w/2-joiner_width, -l-6, h-6]) {
					yrot(90) {
						cylinder(h=20, r=set_screw_size*1.1/2, center=true, $fn=12);
					}
				}
			}
		}
	}
}
//!rail_structure();



module extruder_platform_parts() { // make me
	zrot(90) extruder_platform();
}



extruder_platform_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

