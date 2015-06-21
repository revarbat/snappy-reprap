include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <acme_screw.scad>


$fa = 2;
$fs = 2;

module z_sled()
{
	color("MediumSlateBlue")
	prerender(convexity=10)
	zrot(-90)
	back(rail_offset+groove_height/2)
	union() {
		difference() {
			xrot(90) {
				back(platform_length/2) {
					// Bottom
					up(platform_thick/2)
						zrot(90) yrot(90)
							thinning_wall(l=rail_spacing+joiner_width, h=platform_length, thick=platform_thick, strut=8, bracing=true);

					// Length-wise bracing.
					translate([0,0,platform_thick/2]) {
						cube(size=[lifter_rod_diam+2*3, platform_length, platform_thick], center=true);
					}

					back(25/2)
					yspread(floor((platform_length*7/8-25)/lifter_thread_size)*lifter_thread_size) {
						difference() {
							// Lifter block
							up(platform_thick) {
								up((lifter_rod_diam+2*4)/2) {
									cube(size=[lifter_rod_diam+2*3, platform_length/8, lifter_rod_diam+2*4], center=true);
								}
							}

							// Lifter threading
							up(rail_offset+groove_height/2) {
								union() {
									yspread(printer_slop) {
										xrot(90) zrot(90) {
											acme_threaded_rod(
												d=lifter_rod_diam+2*printer_slop,
												l=platform_length/8+0.5,
												threading=lifter_thread_size,
												thread_depth=1.5
											);
										}
									}
								}
							}
						}

						// lifter block ramp.
						fwd((lifter_rod_diam+2*4+platform_length/8)/2) {
							up((lifter_rod_diam+2*4)/2) {
								difference() {
									up(platform_thick) {
										cube(size=[lifter_rod_diam+2*3, lifter_rod_diam+2*4, lifter_rod_diam+2*4], center=true);
									}
									back((lifter_rod_diam+2*4)/2) {
										up(platform_thick+(lifter_rod_diam+2*4)/2) {
											xrot(45) {
												up((lifter_rod_diam+2*4)/2) {
													cube(size=[lifter_rod_diam+2*3+0.05, platform_length, lifter_rod_diam+2*4], center=true);
												}
											}
										}
									}
									down((lifter_rod_diam+2*4)/2) {
										up(rail_offset+groove_height/2) {
											xrot(90) cylinder(h=platform_length, d=lifter_rod_diam+2*printer_slop, center=true);
										}
									}
								}
							}
						}
					}

					// sliders
					xflip_copy() {
						translate([-(rail_spacing)/2, 0, 0]) {
							// bottom strut
							translate([6/2+printer_slop,0,platform_thick/2]) {
								cube(size=[6, platform_length, platform_thick], center=true);
							}

							up(rail_offset+groove_height/2) {
								left(joiner_width/2) {
									circle_of(n=2, r=joiner_width/2+printer_slop, rot=true) {
										// Slider base
										translate([15/2-9, 0, -groove_height-printer_slop]) {
											cube(size=[15, platform_length, groove_height-printer_slop*2], center=true);
										}

										// Slider backing
										translate([6/2, 0, -4/2]) {
											difference() {
												cube(size=[6, platform_length, groove_height+4], center=true);
												up((groove_height+4)/2) {
													yspread(platform_length) {
														xrot(45) cube(size=[11, 2*sqrt(2), 2*sqrt(2)], center=true);
													}
												}
											}
										}

										// Slider ridge
										scale([tan(groove_angle),1,1]) {
											yrot(45) {
												chamfcube(size=[groove_height/sqrt(2), platform_length, groove_height/sqrt(2)], chamfer=2, chamfaxes=[1,0,1], center=true);
											}
										}
									}
								}
							}
						}
					}
				}
			}

			// Clear side joiners
			xflip_copy() {
				up(rail_height/2/2) {
					fwd(joiner_width/2) {
						right((platform_width-5)/2+0.05) {
							zrot(-90) half_joiner_clear(h=rail_height/2+0.001, w=joiner_width, clearance=5, a=joiner_angle, slop=printer_slop);
						}
					}
				}
			}
		}

		// Side joiners
		xflip_copy() {
			up(rail_height/2/2) {
				fwd(joiner_width/2) {
					right((platform_width-5)/2) {
						zrot(-90) half_joiner2(h=rail_height/2, w=joiner_width, clearance=5, a=joiner_angle, slop=printer_slop);
					}
				}
			}
		}

		back(cantilever_length/2-(rail_offset+groove_height/2)) {
			difference() {
				union() {
					// Bottom.
					back(groove_height/2) {
						up(rail_thick/2) {
							yrot(90) {
								sparse_strut(h=rail_width, l=cantilever_length-groove_height, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
							}
						}
					}

					// Walls.
					back(groove_height/2) {
						xflip_copy() {
							up(rail_height/2) {
								right((rail_spacing+joiner_width)/2) {
									if (wall_style == "crossbeams")
										sparse_strut(h=rail_height, l=cantilever_length-10-groove_height/2, thick=joiner_width, strut=5);
									if (wall_style == "thinwall")
										thinning_wall(h=rail_height, l=cantilever_length-10-groove_height/2, thick=joiner_width, strut=5, bracing=false);
									if (wall_style == "corrugated")
										corrugated_wall(h=rail_height, l=cantilever_length-10-groove_height/2, thick=joiner_width, strut=5);
								}
							}
						}
					}

					// Side Supports
					up(rail_height/4) {
						back((cantilever_length-2*5-5)/2) {
							difference() {
								cube(size=[rail_width-joiner_width, 4, rail_height/2], center=true);
								xspread(rail_width/3, n=3) {
									cube(size=[16, 11, 12], center=true);
								}
							}
						}
					}
				}

				// Clear space for joiners.
				up(rail_height/2) {
					back(cantilever_length/2+0.05) {
						joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height+0.001, w=joiner_width, clearance=5, a=joiner_angle);
					}
				}

				// Shrinkage stress relief
				up(rail_thick/2) {
					yspread(13, n=12) {
						cube(size=[rail_width+1, 1, rail_thick-2], center=true);
					}
					xspread(13, n=8) {
						yspread(cantilever_length-10) {
							cube(size=[1, 60, rail_thick-2], center=true);
						}
					}
				}
			}

			// Snap-tab joiners.
			up(rail_height/2) {
				back(cantilever_length/2+0.05) {
					joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=5, a=joiner_angle);
				}
			}
		}
	}
}
//!z_sled();



module z_sled_parts() { // make me
	z_sled();
}


z_sled_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
