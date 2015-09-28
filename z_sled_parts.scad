include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <acme_screw.scad>
use <sliders.scad>



$fa = 2;
$fs = 2;

module z_sled(explode=0, arrows=false)
{
	offcenter = platform_thick;
	cantlen = cantilever_length - platform_thick - groove_height/2;
	slider_len = 20;
	lifter_block_size = 20;

	color("MediumSlateBlue")
	prerender(convexity=10)
	yrot(90)
	zrot(90)
	down(offcenter+groove_height/2)
	union() {
		back(platform_length/2) {
			difference() {
				union() {
					// Back
					up(platform_thick/2)
						zrot(90) yrot(90)
							sparse_strut(l=rail_spacing-joiner_width+5, h=platform_length, thick=platform_thick, strut=8, maxang=45, max_bridge=999);

					// Lifter clamp support
					up(5/2) {
						cube(size=[lifter_rod_diam+2*3, platform_length, 5], center=true);
					}

					// Side supports
					yspread(platform_length-platform_thick) {
						up((offcenter+groove_height+5)/2) {
							cube(size=[rail_spacing-joiner_width+5, platform_thick, offcenter+groove_height+5], center=true);
						}
					}

					// sliders
					xspread(rail_spacing+joiner_width) {
						up((groove_height+offcenter)/2) {
							difference() {
								// Slider block
								up(7.5/2) {
									chamfcube(chamfer=2, size=[joiner_width+2*7.5+2, platform_length, groove_height+offcenter+7.5], chamfaxes=[0, 1, 0], center=true);
								}

								// Slider groove
								up(2/2-0.05) {
									cube(size=[joiner_width+2, platform_length+1, groove_height+offcenter+2], center=true);
								}
							}
						}

						// Slider ridges
						up(groove_height+offcenter) {
							yspread(platform_length-slider_len-20, n=2) {
								xrot(180) slider(l=slider_len, base=0, slop=2*printer_slop);
							}
						}
					}

					// Lifter block
					up((offcenter+lifter_rod_diam+4)/2) {
						chamfcube(chamfer=3, size=[lifter_rod_diam+2*3, lifter_block_size, offcenter+lifter_rod_diam+4], chamfaxes=[0, 1, 0], center=true);
					}
				}

				// Split Lifter block
				up((offcenter+2*lifter_rod_diam+4)/2) {
					up(5) cube(size=[lifter_rod_diam*0.65, lifter_block_size+1, offcenter+lifter_rod_diam+0.05], center=true);
				}

				// Lifter threading
				up(offcenter+groove_height/2) {
					yspread(printer_slop*1.5) {
						xrot(90) zrot(90) {
							acme_threaded_rod(
								d=lifter_rod_diam+2*printer_slop,
								l=lifter_block_size+2*lifter_rod_pitch+0.5,
								pitch=lifter_rod_pitch,
								thread_depth=lifter_rod_pitch/3,
								$fn=32
							);
						}
					}
					fwd(lifter_block_size/2-2/2) {
						xrot(90) cylinder(h=2.05, d1=lifter_rod_diam-2*lifter_rod_pitch/3, d2=lifter_rod_diam+2, center=true);
					}
					back(lifter_block_size/2-2/2) {
						xrot(90) cylinder(h=2.05, d1=lifter_rod_diam+2, d2=lifter_rod_diam-2*lifter_rod_pitch/3, center=true);
					}
				}

				// Lifter rod access
				yspread(platform_length-platform_thick) {
					up(offcenter+groove_height/2) {
						xrot(90) cylinder(d=lifter_rod_diam+4, h=platform_thick+10, center=true, $fn=32);
					}
				}
			}
		}

		up(offcenter+groove_height+platform_thick-2) {
			difference() {
				union() {
					// Bottom.
					up(cantlen/2-5/2) {
						back(platform_thick/2) {
							zrot(90) sparse_strut(l=rail_width, h=cantlen-1, thick=platform_thick, strut=4);
						}
					}

					// Rail top corners
					up(cantlen+2) {
						back(rail_height+groove_height/2-0.05) {
							down((cantlen+3)/2+0.05) {
								xspread(rail_spacing+joiner_width) {
									cube([joiner_width, groove_height, cantlen+3], center=true);
								}
							}
						}
					}
				}

				// Clear space for joiners.
				up(cantlen+2.05) {
					back(rail_height/2) {
						xrot(90) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height+0.001, w=joiner_width, clearance=5, a=joiner_angle);
					}
				}
			}

			// Snap-tab joiners.
			up(cantlen+2) {
				back(rail_height/2) {
					xrot(90) joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=cantlen+3, a=joiner_angle);
				}
			}
		}
	}
	right(offcenter+groove_height/2) {
		right(cantlen+explode) {
			up(rail_height/2) {
				zrot(-90) children();
			}
		}
	}
}
//!z_sled() sphere(1);



module z_sled_parts() { // make me
	offcenter = platform_thick;
	left(platform_length/2)
		up(offcenter+groove_height/2)
			zrot(180) yrot(-90) z_sled();
}


z_sled_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
