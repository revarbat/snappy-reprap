include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>
use <sliders.scad>
use <acme_screw.scad>



$fa = 2;
$fs = 2;

module z_sled(explode=0, arrows=false)
{
	slider_len = 15;
	slider_width = 12;
	thread_depth = lifter_rod_pitch/3.2;
	pitch = lifter_rod_pitch;

	color("MediumSlateBlue")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Threaded socket
				socket_h = rail_height;
				up(socket_h/2) {
					difference() {
						union() {
							cylinder(d=lifter_rod_diam*1.5, h=socket_h, center=true);
							right((cantilever_length - platform_thick/2)/2) {
								down(socket_h/2) {
									yspread(lifter_rod_diam*1.5-rail_thick) {
										upcube([cantilever_length - platform_thick/2, rail_thick, socket_h]);
									}
								}
							}

							// Sliders
							right(10+groove_height/2) {
								yspread(z_joiner_spacing) {
									rotate([90, 0, -90]) {
										slider(l=rail_height, base=10, slop=3*printer_slop);
									}
								}
								left(5/2) cube([5, z_joiner_spacing+joiner_width, rail_height], center=true);
							}

							// Limit switch adjuster screw socket
							down(rail_height/2) {
								back(z_joiner_spacing/2+joiner_width/2+12) {
									difference() {
										union() {
											cylinder(d=1.5*adjust_screw_diam, h=adjust_screw_pitch*3, center=false);
											fwd((12-1)/2) upcube([adjust_screw_diam, 12-1, adjust_screw_pitch*3]);
										}
										acme_threaded_rod(d=adjust_screw_diam+3*printer_slop, l=adjust_screw_pitch*7, thread_depth=adjust_thread_depth, pitch=adjust_screw_pitch, thread_angle=adjust_screw_angle);
									}
								}
							}
						}
						acme_threaded_rod(d=lifter_rod_diam+5*printer_slop, l=socket_h+0.1, thread_depth=thread_depth, pitch=pitch, thread_angle=lifter_rod_angle);
						if (socket_h > 3*pitch + 2 * thread_depth) {
							chamf_cyl(d=lifter_rod_diam+4, h=socket_h-3*pitch+2*thread_depth, chamfer=thread_depth+2, center=true);
						}
						zflip_copy() {
							down(socket_h/2+0.01) {
								cylinder(d1=lifter_rod_diam, d2=lifter_rod_diam-2*thread_depth, h=thread_depth, center=false);
							}
						}
					}
				}
			}

			// Angle front of supports
			right(cantilever_length-rail_thick/2-10) {
				yrot(-bridge_arch_angle) {
					right(rail_height*1.5) {
						cube(rail_height*3, center=true);
					}
				}
			}
		}

		right(cantilever_length) {
			top_half() {
				yrot(-bridge_arch_angle) {
					// Back
					left(rail_thick/2+10-0.1) {
						upcube([rail_thick, z_joiner_spacing+joiner_width, rail_height]);
					}

					// Snap-tab front joiners.
					up(rail_height/2) {
						zrot(-90) joiner_pair(spacing=z_joiner_spacing, h=rail_height, w=joiner_width, l=10, a=joiner_angle);
					}
				}
			}
		}
	}

	// Children
	right(cantilever_length) {
		yrot(-bridge_arch_angle) {
			right(explode) {
				up(rail_height/2) {
					children();
				}
			}
		}
	}
}
//!z_sled() cylinder(d=1, h=10);



module z_sled_parts() { // make me
	z_sled();
}


z_sled_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
