include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module cantilever_arm()
{
	l = cantilever_length;
	w = platform_width;
	h = rail_height;

	color([0.9, 0.7, 1.0])
	render(convexity=20)
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
				}

				// Clear space for joiners.
				translate([0, -l/2, h/2]) {
					zrot(180) joiner_pair_clear(spacing=w-joiner_width, h=h, w=joiner_width+5, a=joiner_angle);
				}

				// Pivot
				mirror_copy([1,0,0]) {
					translate([w/2-joiner_width, l/2-6, h-6]) {
						yrot(90) cylinder(h=2, r1=6, r2=4, center=true);
					}
				}

				// endstop screw holes.
				grid_of(
					xa=[-endstop_hole_spacing/2, endstop_hole_spacing/2],
					ya=[l/2-endstop_hole_inset],
					za=[rail_thick/2]
				) {
					cylinder(h=rail_thick+0.05, r=endstop_screw_size*1.2/2, center=true, $fn=8);
				}

				// Chamfer front corners.
				translate([0, l/2, h/2]) {
					grid_of(xa=[-w/2, w/2]) {
						zrot(45) cube(size=[5*sqrt(2), 5*sqrt(2), h+1], center=true);
					}
				}
			}

			// Snap-tab joiners.
			translate([0, -l/2, h/2]) {
				zrot(180) joiner_pair(spacing=w-joiner_width, h=h, w=joiner_width, l=5, a=joiner_angle);
			}

			zrot_copies([0, 180]) {
				translate([0, l/2-19, h/4]) {
					difference() {
						// Side supports.
						cube(size=[w, 5, h/2], center=true);

						// Wiring access holes.
						grid_of(xa=[-w/4, w/4])
							cube(size=[8, 6, 10], center=true);
					}
				}
			}
		}

		// Chamfer sharp joiner corner.
		translate([w/2, -l/2, 0]) {
			zrot(45) cube(size=[joiner_width/3*sqrt(2), joiner_width/3*sqrt(2), 10], center=true);
		}
	}
}
//!cantilever_arm();



module cantilever_arm_parts() { // make me
	zrot(90) cantilever_arm();
}



cantilever_arm_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

