include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <acme_screw.scad>


$fa = 2;
$fs = 1;


module glass_bed_support1()
{
	glass_xoff = (2*platform_length + 2*20 - joiner_width - glass_length) / 2;
	backing_diam = adjust_screw_diam + 2*3;
	l = (glass_width-platform_width)/2 + 2;
	w = glass_xoff + backing_diam/2 + 10;
	h = glass_thick + 3;
	l2 = l - backing_diam/2;
	spring_h = 12;
	spring_w = 60;
	spring_thick = 1.4;

	color("Chocolate")
	prerender(convexity=10)
	down(platform_height/2-0.05) {
		difference() {
			union() {
				// Joiner.
				joiner(h=platform_height, w=joiner_width, l=l, a=joiner_angle);

				// Clip platform
				fwd(l2) {
					up(platform_height/2+spring_h-spring_thick/2) {
						cube(size=[backing_diam, backing_diam, spring_thick], center=true);
						up(h/2-0.25) {
							difference() {
								left(w/2-backing_diam/2) {
									cube(size=[w, backing_diam, h], center=true);
								}

								// glass mount slot
								left(50/2+glass_xoff-printer_slop) {
									back(2-printer_slop) {
										cube(size=[50, backing_diam, glass_thick], center=true);
										up(glass_thick-0.05) back(1) left(1) cube(size=[50, backing_diam, glass_thick], center=true);
									}
								}

								// Screw head clearance
								up(1.5) right(2/2) cube(size=[adjust_screw_knob_d+3, backing_diam+1, h], center=true);
							}
						}
					}
				}

				// Screw hole backing
				fwd(l2) {
					cylinder(d=backing_diam, h=platform_height, center=true);
				}

				// Leaf spring
				spring_r = spring_h/4 + spring_w * spring_w / 4 / spring_h;
				fwd(l2) {
					up(platform_height/2+spring_h/2-spring_thick) {
						xrot(90) {
							difference() {
								yflip_copy() {
									fwd(0.01) {
										back_half(spring_r*3) {
											fwd(spring_r-spring_thick/2-spring_h/2) {
												tube(h=backing_diam, r=spring_r, wall=spring_thick, center=true);
											}
										}
									}
								}
								xspread(spring_w+10) cube(size=[10, spring_h, backing_diam+1], center=true);
							}
						}
					}
				}
			}

			fwd(l2) {
				// Threaded hole
				acme_threaded_rod(d=adjust_screw_diam+2*printer_slop, l=platform_height*1.2, thread_depth=adjust_thread_depth, pitch=adjust_screw_pitch, thread_angle=adjust_screw_angle);

				// bevel threaded hole
				up(platform_height/2+0.2) {
					cylinder(d1=adjust_screw_diam-2*adjust_thread_depth, d2=adjust_screw_diam+2, h=2*adjust_thread_depth, center=true);
				}

				// gap
				cube(size=[adjust_screw_diam/2, adjust_screw_diam+2*3+1, platform_height*1.1], center=true);

				// Unthreaded hole
				up(platform_height/2+spring_h) {
					cylinder(d=adjust_screw_diam+2*printer_slop, h=h*2, center=true);
				}
			}
		}
	}
}
//!glass_bed_support1();



module glass_bed_support2()
{
	glass_xoff = (2*platform_length + 2*20 - joiner_width - glass_length) / 2;
	backing_diam = adjust_screw_diam + 2*3;
	l = (glass_width-platform_width)/2 + 2;
	w = glass_xoff + backing_diam/2 + 10;
	h = glass_thick + 3;
	l2 = l - backing_diam/2;
	spring_h = 12;
	spring_w = 60;
	spring_thick = 1.5;

	color("Chocolate")
	prerender(convexity=10)
	down(platform_height/2-0.05) {
		difference() {
			union() {
				// Joiner.
				yrot(180) joiner(h=platform_height, w=joiner_width, l=l, a=joiner_angle);

				// Clip platform
				fwd(l2) {
					up(platform_height/2+spring_h-spring_thick/2) {
						cube(size=[backing_diam, backing_diam, spring_thick], center=true);
						up(h/2-0.25) {
							difference() {
								right(w/2-backing_diam/2) {
									cube(size=[w, backing_diam, h], center=true);
								}

								// glass mount slot
								right(50/2+glass_xoff-printer_slop) {
									back(2-printer_slop) {
										cube(size=[50, backing_diam, glass_thick], center=true);
										up(glass_thick-0.05) back(1) right(1) cube(size=[50, backing_diam, glass_thick], center=true);
									}
								}

								// Screw head clearance
								up(1.5) left(2/2) cube(size=[adjust_screw_knob_d+3, backing_diam+1, h], center=true);
							}
						}
					}
				}

				// Screw hole backing
				fwd(l2) {
					cylinder(d=backing_diam, h=platform_height, center=true);
				}

				// Leaf spring
				spring_r = spring_h/4 + spring_w * spring_w / 4 / spring_h;
				fwd(l2) {
					up(platform_height/2+spring_h/2-spring_thick) {
						xrot(90) {
							difference() {
								yflip_copy() {
									fwd(0.01) {
										back_half(spring_r*3) {
											fwd(spring_r-spring_thick/2-spring_h/2) {
												tube(h=backing_diam, r=spring_r, wall=spring_thick, center=true);
											}
										}
									}
								}
								xspread(spring_w+10) cube(size=[10, spring_h, backing_diam+1], center=true);
							}
						}
					}
				}
			}

			fwd(l2) {
				// Threaded hole
				acme_threaded_rod(d=adjust_screw_diam+2*printer_slop, l=platform_height*1.2, thread_depth=adjust_thread_depth, pitch=adjust_screw_pitch, thread_angle=adjust_screw_angle);

				// bevel threaded hole
				up(platform_height/2+0.2) {
					cylinder(d1=adjust_screw_diam-2*adjust_thread_depth, d2=adjust_screw_diam+2, h=2*adjust_thread_depth, center=true);
				}

				// gap
				cube(size=[adjust_screw_diam/2, adjust_screw_diam+2*3+1, platform_height*1.1], center=true);

				// Unthreaded hole
				up(platform_height/2+spring_h) {
					cylinder(d=adjust_screw_diam+2*printer_slop, h=h*2, center=true);
				}
			}
		}
	}
}
//!glass_bed_support2();



module glass_bed_support_parts() { // make me
	l = (glass_width-platform_width)/2 + 2;
	zrot_copies([0, 180]) {
		up(l) {
			back(20) {
				left(40) xrot(90) glass_bed_support2();
				right(40) xrot(90) glass_bed_support1();
			}
		}
	}
}

glass_bed_support_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

