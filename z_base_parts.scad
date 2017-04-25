include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>

$fa=2;
$fs=2;

// connectby valid options: "", "fwd", "back"
module z_base(explode=0, connectby="")
{
	side_joiner_len = 2;
	l = z_base_height;
	wall_dx = rail_spacing - (z_joiner_spacing-joiner_width);
	wall_ang = atan2(wall_dx/2, l);
	cross_dx = rail_spacing/2 + (z_joiner_spacing-joiner_width)/2 + joiner_width;
	cross_ang = atan2(cross_dx, l - 2*rail_thick);
	cross_l = hypot(cross_dx, l - 2*rail_thick);

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
					// Bottom.
					up(rail_thick/2) {
						fwd((l-2*rail_thick)/2-0.5) {
							cube(size=[rail_spacing+joiner_width, 2*rail_thick, rail_thick], center=true);
						}
						back((l-2*rail_thick)/2-0.5) {
							cube(size=[lifter_screw_diam+joiner_width, 2*rail_thick, rail_thick], center=true);
						}
						intersection() {
							xflip_copy() {
								right((rail_spacing+joiner_width)/2) {
									fwd(l/2-3) {
										zrot(cross_ang) {
											back(cross_l/2) {
												cube(size=[2*rail_thick, cross_l, rail_thick], center=true);
											}
										}
									}
								}
							}
							cube(size=[2*rail_spacing, l-1, rail_thick+1], center=true);
						}
					}

					// Walls.
					xflip_copy() {
						up(rail_height/2+groove_height/2) {
							fwd(l/2) {
								skew_xz(xang=wall_ang) {
									back(l/2) {
										left((rail_spacing+joiner_width)/2) {
											difference() {
												union() {
												// Wall
													if (wall_style == "crossbeams")
														sparse_strut(h=rail_height+groove_height, l=l-0.1, thick=joiner_width, strut=7);
													if (wall_style == "thinwall")
														thinning_wall(h=rail_height+groove_height, l=l-0.1, thick=joiner_width, strut=7);
													if (wall_style == "corrugated")
														corrugated_wall(h=rail_height+groove_height, l=l-0.1, thick=joiner_width, strut=7);

													// Side wiring access hole frame
													if (wall_style == "corrugated") {
														down((rail_height+groove_height)/2) {
															up(15/2+rail_thick) {
																cube(size=[joiner_width, 16+4, 10+4], center=true);
															}
														}
													}
												}

												// Side wiring access hole
												if (wall_style != "crossbeams") {
													down((rail_height+groove_height)/2) {
														up(15/2+rail_thick) {
															cube(size=[joiner_width+1, 16, 10], center=true);
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

					// Side supports
					up(rail_height/2) {
						fwd((l-2*5-5)/2) {
							difference() {
								cube(size=[rail_width-joiner_width, 3, rail_height], center=true);
								down(rail_height/2-rail_thick-12/2-1) {
									xspread(rail_width/3, n=3) {
										cube(size=[16, 11, 12], center=true);
									}
								}
							}
						}
						back((l-2*5-5)/2) {
							difference() {
								cube(size=[z_joiner_spacing, 3, rail_height], center=true);
								down(rail_height/2-rail_thick-12/2-1) {
									cube(size=[16, 11, 12], center=true);
								}
							}
						}
					}
				}

				// Clear space for joiners.
				up(rail_height/2) {
					back(l/2-0.05) joiner_pair_clear(spacing=z_joiner_spacing, h=rail_height, w=joiner_width, clearance=4, a=joiner_angle);
					fwd(l/2-0.05) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, clearance=4, a=joiner_angle);
				}

				// Clear space for Side half joiners
				up(rail_height/2/2) {
					fwd((l-20)/2-0.05) {
						zring(r=rail_spacing/2+joiner_width+side_joiner_len-0.05, n=2) {
							zrot(-90) {
								chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
									half_joiner_clear(h=rail_height/2, w=joiner_width, a=joiner_angle);
								}
							}
						}
					}
					back((l-20)/2-0.05) {
						zring(r=z_joiner_spacing/2+joiner_width/2+side_joiner_len-0.05, n=2) {
							zrot(-90) {
								chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
									half_joiner_clear(h=rail_height/2, w=joiner_width, a=joiner_angle);
								}
							}
						}
					}
				}
			}

			// Side half joiners
			up(rail_height/2/2) {
				fwd((l-20)/2+0.05) {
					zring(r=rail_spacing/2+joiner_width+side_joiner_len+0.1, n=2) {
						zrot(-90) {
							chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
								half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len+joiner_width/2, a=joiner_angle);
							}
						}
					}
				}
				back((l-20)/2+0.05) {
					zring(r=z_joiner_spacing/2+joiner_width/2+side_joiner_len+0.1, n=2) {
						zrot(-90) {
							chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
								half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len+joiner_width/2, a=joiner_angle);
							}
						}
					}
				}
			}

			// Snap-tab joiners.
			up(rail_height/2+0.05) {
				fwd(l/2) zrot(180) xspread(rail_spacing+joiner_width) joiner(h=rail_height, w=joiner_width, l=6, a=joiner_angle);
				back(l/2) xspread(z_joiner_spacing) yrot(180) joiner(h=rail_height, w=joiner_width, l=6, a=joiner_angle);
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
				left(rail_spacing/2+joiner_width+side_joiner_len) {
					if ($children > 2) children(2);
				}
				right(rail_spacing/2+joiner_width+side_joiner_len) {
					if ($children > 3) children(3);
				}
			}
		}
	}
}
//!z_base();



module z_base_parts() { // make me
	z_base();
}



z_base_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

