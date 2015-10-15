include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module yz_joiner()
{
	joiner_length=10;
	base_height = rail_height+groove_height;
	endstop_delta = platform_length - base_height;
	motor_mount_spacing=43+joiner_width+10;

	color([0.5, 0.7, 1.0])
	prerender(convexity=10)
	difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					up(rail_thick/2) {
						back(platform_length/2) {
							yrot(90) sparse_strut(h=rail_width, l=platform_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
						}
					}

					// Back.
					up((rail_height+groove_height)/2) {
						back(rail_thick/2) {
							zrot(90) {
								if (wall_style == "crossbeams")
									sparse_strut(h=rail_height+groove_height, l=rail_width-joiner_width/2, thick=rail_thick, strut=5);
								if (wall_style == "thinwall")
									thinning_wall(h=rail_height+groove_height, l=rail_width-joiner_width/2, thick=rail_thick, strut=rail_thick, bracing=true);
								if (wall_style == "corrugated")
									corrugated_wall(h=rail_height+groove_height, l=rail_width-joiner_width/2, thick=rail_thick, strut=rail_thick, wall=3);
							}
						}
					}

					// Side Walls
					xflip_copy() {
						right((rail_spacing+joiner_width)/2) {
							// Wall.
							back((platform_length-joiner_length+1)/2) {
								if (wall_style == "crossbeams")
									up((rail_height+rail_thick)/2)
										sparse_strut(l=platform_length-joiner_length+1, h=rail_height+rail_thick, thick=joiner_width, strut=5);
								if (wall_style == "thinwall")
									up((rail_height+rail_thick)/2)
										thinning_wall(l=platform_length-joiner_length+1, h=rail_height+rail_thick, thick=joiner_width, strut=rail_thick, bracing=false);
								if (wall_style == "corrugated")
									up(rail_height/2)
										corrugated_wall(l=platform_length-joiner_length+1, h=rail_height, thick=joiner_width, strut=rail_thick, wall=3);
							}

							// Rail tops.
							translate([0, rail_height, rail_height-0.05]) {
								translate([0, (platform_length-rail_height)/2, groove_height/2])
									cube(size=[joiner_width, platform_length-rail_height, groove_height], center=true);
							}
						}
					}

					// Wiring access hole frame
					if (wall_style == "corrugated") {
						up(rail_thick+rail_height/4/2) {
							back(rail_thick/2) {
								cube([16+4, rail_thick, rail_height/4+4], center=true);
							}
						}
					}
				}

				// Shrinkage stress relief
				translate([0, platform_length/2, rail_thick/2]) {
					yspread(12, n=7) {
						cube(size=[rail_width+1, 1, rail_thick-2], center=true);
					}
					xspread(12, n=9) {
						yspread(platform_length-10) {
							cube(size=[1, 20, rail_thick-2], center=true);
						}
					}
				}

				// Clear space for front joiners.
				translate([0, platform_length+0.05, rail_height/2]) {
					joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height+0.001, w=joiner_width, clearance=5, a=joiner_angle);
				}

				// Clear space for back joiners.
				translate([0, -6.05, rail_height/2]) {
					zrot(180) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height+0.001, w=joiner_width, a=joiner_angle);
				}

				// Clear space for side joiners.
				translate([0, platform_length/2+0.05, rail_height/2]) {
					zrot(90) joiner_quad_clear(xspacing=platform_length/2, yspacing=rail_width+2*6, h=rail_height+0.001, w=joiner_width, a=joiner_angle);
				}

				// Clear space for top joiners.
				translate([0, rail_height/2, rail_height+groove_height-0.05]) {
					xrot(90) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width+0.001, clearance=5, a=joiner_angle);
				}

				// Wiring access hole
				if (wall_style != "crossbeams") {
					up(rail_thick+rail_height/4/2) {
						cube([16, joiner_width*3, rail_height/4], center=true);
					}
				}
			}

			// Front joiners.
			translate([0, platform_length, rail_height/2]) {
				joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}

			// Back joiners.
			translate([0, -6, rail_height/2]) {
				zrot(180) joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}

			// Side joiners.
			translate([0, platform_length/3, rail_height/2]) {
				zrot(90) joiner_quad(xspacing=platform_length/2, yspacing=rail_width+2*6, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}

			// Top joiners.
			translate([0, rail_height/2, rail_height+groove_height]) {
				xrot(90) joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}

			translate([0, platform_length-joiner_length, rail_height/4]) {
				difference() {
					// Side supports.
					cube(size=[rail_width, 5, rail_height/2], center=true);

					// Wiring access holes.
					xspread(rail_width/3, n=3) {
						cube(size=[16, 11, 11], center=true);
					}
				}
			}
		}
	}
}
//yz_joiner();



module yz_joiner_parts() { // make me
	zrot(-90) fwd(platform_length/2) yz_joiner();
}



yz_joiner_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

