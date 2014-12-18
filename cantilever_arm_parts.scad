include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module cantilever_arm()
{
	l = cantilever_length;
	w = platform_width;
	h = rail_height;

	color([0.9, 0.7, 1.0])
	prerender(convexity=20)
	difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0,0,rail_thick/2]) yrot(90)
						sparse_strut(h=w, l=l, thick=rail_thick, maxang=45, strut=10, max_bridge=500);

					mirror_copy([1, 0, 0]) {
						// Walls.
						translate([(w-joiner_width)/2, 0, h/2]) {
							if (wall_style == "crossbeams")
								sparse_strut(h=h, l=l-10, thick=joiner_width, strut=5);
							if (wall_style == "thinwall")
								thinning_wall(h=h, l=l-10, thick=joiner_width, strut=rail_thick, bracing=false);
							if (wall_style == "corrugated")
								corrugated_wall(h=h, l=l-10, thick=joiner_width, strut=rail_thick);
						}

						//Back ends
						translate([(w-joiner_width)/2, l/2-2.5, h/2]) {
							cube(size=[joiner_width, 5, h], center=true);
						}
					}

					zrot_copies([0, 180]) {
						translate([0, l/2-20, h/4]) {
							difference() {
								// Side supports.
								cube(size=[w, 5, h/2], center=true);

								// Wiring access holes.
								grid_of(count=3, spacing=w/3) {
									cube(size=[25,11,8], center=true);
								}
							}
						}
					}

					// Endstop standoff backing
					translate([0, l/2-10, rail_thick/2]) {
						cube(size=[endstop_hole_spacing + endstop_screw_size*2 + 6, 20, rail_thick], center=true);
					}

					// Endstop standoffs
					translate([0, l/2-endstop_hole_inset, (rail_thick+endstop_standoff)/2]) {
						grid_of(count=2, spacing=endstop_hole_spacing) {
							cylinder(h=rail_thick+endstop_standoff, r=2+endstop_screw_size*1.2/2, center=true, $fn=16);
						}
					}
				}

				// Clear space for joiners.
				translate([0, -l/2, h/2]) {
					zrot(180) joiner_pair_clear(spacing=w-joiner_width, h=h+0.001, w=joiner_width, a=joiner_angle, clearance=5);
				}

				// Endstop screw holes.
				translate([0, l/2-endstop_hole_inset, (rail_thick+endstop_standoff)/2]) {
					grid_of(count=2, spacing=endstop_hole_spacing) {
						cylinder(h=rail_thick+endstop_standoff+1, r=endstop_screw_size*1.2/2, center=true, $fn=8);
					}
				}

				// Trim corners behind pivot.
				translate([0, l/2, h]) {
					grid_of(count=2, spacing=w-joiner_width) {
						xrot(45) cube(size=[joiner_width+1, 6*sqrt(2), 6*sqrt(2)], center=true);
					}
				}

				// Shrinkage stress relief
				translate([0, 0, rail_thick/2]) {
					grid_of(count=[1, 9], spacing=[0, 12]) {
						cube(size=[w+1, 1, rail_thick-2], center=true);
					}
					grid_of(count=[11, 2], spacing=[12.7, l-10]) {
						cube(size=[1, 36, rail_thick-2], center=true);
					}
				}
			}

			// Snap-tab joiners.
			translate([0, -l/2, h]) {
				grid_of(count=[1,1,2], spacing=h) {
					zrot(180) joiner_pair(spacing=w-joiner_width, h=h, w=joiner_width, l=10, a=joiner_angle);
				}
			}
			translate([0, -l/2+10+h/2, h*3/2]) {
				grid_of(count=2, spacing=w-joiner_width) {
					thinning_triangle(h=h, l=h, thick=joiner_width, diagonly=true);
				}
			}

			// Pivot backing
			mirror_copy([1, 0, 0]) {
				translate([(w-joiner_width)/2, l/2-6, h-6]) {
					yrot(90) cylinder(h=joiner_width, r=7.5, center=true, $fn=32);
				}
			}
		}

		// Pivot
		mirror_copy([1, 0, 0]) {
			translate([w/2-joiner_width, l/2-6, h-6]) {
				translate([2/2-0.05, 0, 0]) {
					yrot(90) {
						cylinder(h=2, r1=6, r2=4, center=true, $fn=32);
						cylinder(h=20, r=set_screw_size*1.1/2, center=true, $fn=12);
						translate([0,0,0.75]) {
							zrot(90) scale([1.1, 1.1, 1.2]) {
								metric_nut(size=set_screw_size, hole=false);
							}
						}
					}
				}
			}
		}
	}
}
//!cantilever_arm();



module cantilever_arm_parts() { // make me
	zrot(90) cantilever_arm();
}



cantilever_arm_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

