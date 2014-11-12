include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rail_segment()
{
	color([0.9, 0.7, 1.0])
	prerender(convexity=20)
	union() {
		difference() {
			union() {
				// Bottom.
				translate([0,0,rail_thick/2]) yrot(90)
					sparse_strut(h=rail_width, l=rail_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);

				// Flanges on sides to reduce peeling.
				grid_of(count=2, spacing=rail_spacing+2*joiner_width) {
					hull() {
						grid_of(count=[1,2], spacing=[0, rail_length-2*joiner_width/3]) {
							translate([0, 0, 1/2])
								cylinder(h=1, r=joiner_width/3, center=true, $fn=12);
						}
					}
				}

				// Walls.
				zrot_copies([0, 180]) {
					translate([(rail_spacing+joiner_width)/2, 0, (rail_height+3)/2]) {
						if (wall_style == "crossbeams")
							sparse_strut(h=rail_height+3, l=rail_length-10, thick=joiner_width, strut=5);
						if (wall_style == "thinwall")
							thinning_wall(h=rail_height+3, l=rail_length-10, thick=joiner_width, strut=5, bracing=false);
						if (wall_style == "corrugated")
							corrugated_wall(h=rail_height+3, l=rail_length-10, thick=joiner_width, strut=5);
					}
				}

				// Rail backing.
				grid_of(count=2, spacing=rail_spacing+joiner_width)
					translate([0,0,rail_height+groove_height/2])
						chamfer(size=[joiner_width, rail_length, groove_height], chamfer=1, edges=[[1,1,0,0], [1,1,0,0], [0,0,0,0]])
							cube(size=[joiner_width, rail_length, groove_height], center=true);

				// Side Supports
				translate([0, 0, rail_height/4]) {
					grid_of(count=[1,2], spacing=[0, rail_length-38]) {
						cube(size=[rail_width, 5, rail_height/2], center=true);
					}
				}
			}

			// Rail grooves.
			translate([0,0,rail_height+groove_height/2]) {
				mirror_copy([1,0,0]) {
					translate([-(rail_width/2-joiner_width/2), 0, 0]) {
						mirror_copy([1,0,0]) {
							translate([(joiner_width/2), 0, 0]) {
								// main groove
								scale([tan(groove_angle),1,1]) yrot(45) {
									cube(size=[groove_height*sqrt(2)/2,rail_length+1,groove_height*sqrt(2)/2], center=true);
								}

								// chamfers
								mirror_copy([0,1,0]) {
									translate([0, rail_length/2, 0]) {
										hull() {
											grid_of(count=[1,2], spacing=2) {
												zrot(45) scale([tan(groove_angle)*sin(45),1.01,1.01]) yrot(45) {
													cube(size=[groove_height*sqrt(2)/2, 10, groove_height*sqrt(2)/2], center=true);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}

			// Wiring access holes.
			translate([0, 0, rail_height/4]) {
				grid_of(count=[3,2], spacing=[rail_width/3, rail_length-38]) {
					cube(size=[10, 10, 10], center=true);
				}
			}

			// Clear space for joiners.
			translate([0,0,rail_height/2]) {
				joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=rail_length, h=rail_height+0.001, w=joiner_width, clearance=5, a=joiner_angle);
			}

			// Shrinkage stress relief
			translate([0, 0, rail_thick/2]) {
				grid_of(count=[1, 7], spacing=[0, 30]) {
					cube(size=[rail_width+1, 1, rail_thick-2], center=true);
				}
				grid_of(count=[5, 2], spacing=[24, rail_length-10]) {
					cube(size=[1, 60, rail_thick-2], center=true);
				}
			}
		}

		// Snap-tab joiners.
		translate([0,0,rail_height/2]) {
			joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=rail_length, h=rail_height, w=joiner_width, l=5, a=joiner_angle);
		}
	}
}
//!rail_segment();



module rail_segment_parts() { // make me
	rail_segment();
}



rail_segment_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

