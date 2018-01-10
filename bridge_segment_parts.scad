include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>

$fa=2;
$fs=2;

// connectby valid options: "", "fwd", "back"
module bridge_segment(explode=0, connectby="")
{
	side_joiner_len = 2;
	l = rail_length / cos(bridge_arch_angle) - 2 * printer_slop;
	spacing = z_joiner_spacing;
	wall_h = rail_height/2;

	up(
		(connectby=="fwd")? -rail_height/2 :
		(connectby=="back")? -rail_height/2 :
		0
	) back(
		(connectby=="back")? -l/2 :
		(connectby=="fwd")? l/2 :
		0
	) {
		color([0.9, 0.7, 1.0])
		prerender(convexity=20)
		union() {
			difference() {
				union() {
					difference() {
						union() {
							// Bottom.
							up(rail_thick/2) yrot(90) {
								sparse_strut(h=spacing, l=l-1, thick=rail_thick, maxang=70, strut=7, max_bridge=500);
							}

							// Walls
							xspread(spacing) {
								up(wall_h/2) {
									difference() {
										union() {
											if (wall_style == "crossbeams")
												sparse_strut(h=wall_h, l=l-12.1, thick=rail_thick, strut=platform_thick);
											if (wall_style == "thinwall")
												thinning_wall(h=wall_h, l=l-12.1, thick=rail_thick, strut=platform_thick);
											if (wall_style == "corrugated") {
												corrugated_wall(h=wall_h, l=l-12.1, thick=rail_thick, strut=platform_thick);

												// Side wiring access hole frame
												down(wall_h-10/2-rail_thick) {
													yspread(motor_rail_length-2*28) {
														cube(size=[platform_thick, 16+4, 10+4], center=true);
													}
												}
											}
										}

										// Side wiring access hole
										if (wall_style != "crossbeams") {
											down(wall_h/2-10/2-rail_thick) {
												yspread(motor_rail_length-2*28) {
													cube(size=[10, 16, 10], center=true);
												}
											}
										}
									}
								}
							}

							// Cross supports
							up(wall_h/2) {
								yspread(l/2-joiner_width, n=3) {
									difference() {
										cube(size=[spacing-0.1, 4, wall_h], center=true);
										down(wall_h/2-rail_thick-10/2-0.05) cube(size=[16, 11, 10], center=true);
									}
								}
							}

							// Triangle Bracing
							up(rail_height/2-0.05) {
								xspread(spacing) {
									yflip_copy() {
										back(l/2-6) {
											front_half() {
												trapezoid([rail_thick, rail_height], [rail_thick, 0.1], h=rail_height/2, center=false);
											}
										}
									}
								}
							}
						}

						// Clear space for joiners.
						up(rail_height/2) {
							joiner_quad_clear(xspacing=spacing, yspacing=l-0.05, h=rail_height, w=joiner_width, clearance=1, a=joiner_angle);
						}
					}

					// Snap-tab joiners.
					up(rail_height/2+0.05) {
						joiner_quad(xspacing=spacing, yspacing=l, h=rail_height, w=joiner_width, l=10, a=joiner_angle);
					}
				}

				// Clear space for Side half joiners
				up(rail_height/2/2) {
					yspread(l-2*joiner_width-2-0.05) {
						zring(r=spacing/2+joiner_width/2+side_joiner_len+0.05, n=2) {
							zrot(-90) {
								half_joiner_clear(h=rail_height/2, w=joiner_width, a=joiner_angle, clearance=0);
							}
						}
					}
				}
			}
			// Side half joiners
			up(rail_height/2/2) {
				yspread(l-2*joiner_width-2-0.04) {
					zring(r=spacing/2+joiner_width/2+side_joiner_len+0.1, n=2) {
						zrot(-90) {
							chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
								half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len+joiner_width/2, a=joiner_angle);
							}
						}
					}
				}
			}
		}

		up(rail_height/2) {
			fwd(l/2+explode) {
				if ($children > 0) children(0);
			}
			back(l/2+explode) {
				if ($children > 1) children(1);
			}
		}
		up(rail_height/2/2) {
			back(l/2-10) {
				left(spacing/2+joiner_width/2+side_joiner_len) {
					if ($children > 2) children(2);
				}
				right(spacing/2+joiner_width/2+side_joiner_len) {
					if ($children > 3) children(3);
				}
			}
			fwd(l/2-10) {
				left(spacing/2+joiner_width/2+side_joiner_len) {
					if ($children > 4) children(4);
				}
				right(spacing/2+joiner_width/2+side_joiner_len) {
					if ($children > 5) children(5);
				}
			}
		}
	}
}
//!bridge_segment();



module bridge_segment_parts() { // make me
	zrot(90) bridge_segment();
}



bridge_segment_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

