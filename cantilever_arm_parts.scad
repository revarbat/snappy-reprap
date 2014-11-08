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

					// Flanges on sides to reduce peeling.
					grid_of(
						xa=[-(w/2), (w/2)]
					) {
						hull() {
							grid_of(
								ya=[-(l/2-joiner_width/3), (l/2-joiner_width/3)],
								za=[2/2]
							) {
								cylinder(h=2, r=joiner_width/3, center=true, $fn=12);
							}
						}
					}

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

					// Endstop standoffs
					grid_of(
						xa=[-endstop_hole_spacing/2, endstop_hole_spacing/2],
						ya=[l/2-endstop_hole_inset],
						za=[(rail_thick+endstop_standoff)/2]
					) {
						cylinder(h=rail_thick+endstop_standoff, r=2+endstop_screw_size*1.2/2, center=true, $fn=16);
					}
				}

				// Clear space for joiners.
				translate([0, -l/2, h/2]) {
					zrot(180) joiner_pair_clear(spacing=w-joiner_width, h=h+0.001, w=joiner_width, a=joiner_angle, clearance=5);
				}

				// Endstop screw holes.
				grid_of(
					xa=[-endstop_hole_spacing/2, endstop_hole_spacing/2],
					ya=[l/2-endstop_hole_inset],
					za=[(rail_thick+endstop_standoff)/2]
				) {
					cylinder(h=rail_thick+endstop_standoff+1, r=endstop_screw_size*1.2/2, center=true, $fn=8);
				}

				// Trim corners behind pivot.
				grid_of(
					xa=[-(w-joiner_width)/2, (w-joiner_width)/2],
					ya=[l/2],
					za=[h]
				) {
					xrot(45) cube(size=[joiner_width+1, 6*sqrt(2), 6*sqrt(2)], center=true);
				}
			}

			// Snap-tab joiners.
			translate([0, -l/2, h/2]) {
				zrot(180) joiner_pair(spacing=w-joiner_width, h=h, w=joiner_width, l=5, a=joiner_angle);
			}

			zrot_copies([0, 180]) {
				translate([0, l/2-20, h/4]) {
					difference() {
						// Side supports.
						cube(size=[w, 5, h/2], center=true);

						// Wiring access holes.
						grid_of(xa=[-w/4, 0, w/4]) {
							cube(size=[10, 10, 10], center=true);
						}
					}
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

