include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <acme_screw.scad>


module z_sled()
{
	color("MediumSlateBlue")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Bottom
				translate([0,0,platform_thick/2])
					yrot(90) sparse_strut(h=platform_width, l=platform_length, thick=platform_thick, maxang=45, strut=12, max_bridge=999);

				// Walls.
				zrot_copies([0, 180]) {
					translate([(platform_width-joiner_width)/2, 0, platform_height/2]) {
						if (wall_style == "crossbeams")
							sparse_strut(h=platform_height, l=platform_length-10, thick=joiner_width, strut=5);
						if (wall_style == "thinwall")
							thinning_wall(h=platform_height, l=platform_length-10, thick=joiner_width, strut=platform_thick, wall=3, bracing=false);
						if (wall_style == "corrugated")
							corrugated_wall(h=platform_height, l=platform_length-10, thick=joiner_width, strut=platform_thick, wall=3);
					}
				}

				// Length-wise bracing.
				translate([0,0,platform_thick/2]) {
					cube(size=[lifter_rod_diam+2*3, platform_length, platform_thick], center=true);
				}

				// Lifter blocks
				translate([0, 0, platform_thick]) {
					grid_of(count=[1,2], spacing=floor(platform_length*0.75/lifter_thread_size)*lifter_thread_size) {
						translate([0, 0, (lifter_rod_diam+2*4)/2]) {
							cube(size=[lifter_rod_diam+2*3, 15, lifter_rod_diam+2*4], center=true);
						}
					}
				}

				// sliders
				mirror_copy([1,0,0]) {
					translate([-(rail_spacing)/2, 0, 0]) {
						// bottom strut
						translate([6/2+printer_slop,0,platform_thick/2]) {
							cube(size=[6, platform_length, platform_thick], center=true);
						}

						grid_of(
							ya=[-platform_length*6/16, 0, platform_length*6/16],
							za=[rail_offset+groove_height/2]
						) {
							translate([-joiner_width/2, 0, 0]) {
							    circle_of(n=2, r=joiner_width/2+printer_slop, rot=true) {
									// Slider base
									translate([15/2-9, 0, -groove_height-printer_slop]) {
										difference() {
											cube(size=[15, platform_length/8, groove_height-printer_slop*2], center=true);
											grid_of(
												ya=[-(platform_length/8/2), (platform_length/8/2)],
												za=[groove_height/2]
											) {
												xrot(45) cube(size=[16, 2*sqrt(2), 2*sqrt(2)], center=true);
											}
										}
									}

									// Slider backing
									translate([6/2, 0, -4/2]) {
										difference() {
											cube(size=[6, platform_length/8, groove_height+4], center=true);
											grid_of(
												ya=[-(platform_length/8/2), (platform_length/8/2)],
												za=[(groove_height+4)/2]
											) {
												xrot(45) cube(size=[11, 2*sqrt(2), 2*sqrt(2)], center=true);
											}
										}
									}

									// Slider ridge
									scale([tan(groove_angle),1,1]) {
										yrot(45) {
											chamfcube(size=[groove_height/sqrt(2), platform_length/8, groove_height/sqrt(2)], chamfer=2, chamfaxes=[1,0,1], center=true);
										}
									}
								}
							}
						}
					}
				}
			}

			// Clear space for joiners.
			translate([0,0,platform_height/2]) {
				joiner_quad_clear(xspacing=platform_width-joiner_width, yspacing=platform_length, h=platform_height, w=joiner_width, clearance=5, a=joiner_angle);
			}

			// Shrinkage stress relief
			translate([0, 0, platform_thick/2]) {
				grid_of(count=[1, 9], spacing=[0,9]) {
					cube(size=[platform_width+1, 1, platform_thick-2], center=true);
				}
				grid_of(count=[9, 2], spacing=[14, platform_length-10]) {
					cube(size=[1, 20, platform_thick-2], center=true);
				}
			}

			// Lifter threading
			grid_of(count=[1,2], spacing=floor(platform_length*0.75/lifter_thread_size)*lifter_thread_size) {
				translate([0, 0, rail_offset+groove_height/2]) {
					union() {
						grid_of(ya=[-printer_slop/2,printer_slop/2]) {
							xrot(90) zrot(90) {
								acme_threaded_rod(
									d=lifter_rod_diam+2*printer_slop,
									l=16,
									threading=lifter_thread_size,
									thread_depth=1.5
								);
							}
						}
						teardrop(r=(lifter_rod_diam+2*printer_slop-3)/2, h=16, ang=30);
						translate([0, 0, (lifter_rod_diam+3)/2]) {
							cube(size=[4, 16, lifter_rod_diam], center=true);
						}
					}
				}
			}
		}

		// Snap-tab joiners.
		translate([0,0,platform_height/2]) {
			joiner_quad(xspacing=platform_width-joiner_width, yspacing=platform_length, h=platform_height, w=joiner_width, l=5, a=joiner_angle);
		}
	}
}
//!z_sled();



module z_sled_parts() { // make me
	zrot(90) z_sled();
}


z_sled_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
