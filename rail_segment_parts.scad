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
				up(rail_thick/2) yrot(90)
					sparse_strut(h=rail_width, l=rail_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);

				// Walls.
				zrot_copies([0, 180]) {
					up((rail_height+3)/2) {
						right((rail_spacing+joiner_width)/2) {
							if (wall_style == "crossbeams")
								sparse_strut(h=rail_height+3, l=rail_length-10, thick=joiner_width, strut=5);
							if (wall_style == "thinwall")
								thinning_wall(h=rail_height+3, l=rail_length-10, thick=joiner_width, strut=5, bracing=false);
							if (wall_style == "corrugated")
								corrugated_wall(h=rail_height+3, l=rail_length-10, thick=joiner_width, strut=5);
						}
					}
				}

				// Rail backing.
				xspread(rail_spacing+joiner_width)
					up(rail_height+groove_height/2)
						chamfer(size=[joiner_width, rail_length, groove_height], chamfer=1, edges=[[1,1,0,0], [1,1,0,0], [0,0,0,0]])
							cube(size=[joiner_width, rail_length, groove_height], center=true);

				// Side Supports
				up(rail_height/4) {
					yspread(rail_length-2*5-5) {
						difference() {
							cube(size=[rail_width-joiner_width, 4, rail_height/2], center=true);
							xspread(rail_width/3, n=3) {
								cube(size=[16, 11, 12], center=true);
							}
						}
					}
				}
			}

			// Rail grooves.
			up(rail_height+groove_height/2) {
				mirror_copy([1,0,0]) {
					left((rail_width-joiner_width)/2) {
						mirror_copy([1,0,0]) {
							right(joiner_width/2) {
								// main groove
								scale([tan(groove_angle),1,1]) yrot(45) {
									cube(size=[groove_height*sqrt(2)/2,rail_length+1,groove_height*sqrt(2)/2], center=true);
								}

								// chamfers
								mirror_copy([0,1,0]) {
									back(rail_length/2) {
										hull() {
											yspread(2) {
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

			// Clear space for joiners.
			up(rail_height/2) {
				joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=rail_length, h=rail_height+0.001, w=joiner_width, clearance=5, a=joiner_angle);
			}

			// Shrinkage stress relief
			up(rail_thick/2) {
				yspread(13, n=12) {
					cube(size=[rail_width+1, 1, rail_thick-2], center=true);
				}
				xspread(13, n=8) {
					yspread(rail_length-10) {
						cube(size=[1, 60, rail_thick-2], center=true);
					}
				}
			}
		}

		// Snap-tab joiners.
		up(rail_height/2) {
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

