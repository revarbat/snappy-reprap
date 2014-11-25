include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module yz_joiner()
{
	joiner_length=10;
	base_height = rail_height+groove_height;
	endstop_delta = platform_length - base_height;
	motor_mount_spacing=43+joiner_width+10;

	color("Turquoise")
	prerender(convexity=10)
	difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0, platform_length/2, rail_thick/2]) {
						yrot(90)
							sparse_strut(h=rail_width, l=platform_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
					}

					// Back.
					translate([0, rail_thick/2, platform_length/2]) zrot(90) {
						if (wall_style == "crossbeams")
							sparse_strut(h=platform_length, l=rail_width-joiner_width, thick=rail_thick, strut=5);
						if (wall_style == "thinwall")
							thinning_wall(h=platform_length, l=rail_width-joiner_width, thick=rail_thick, strut=rail_thick, bracing=true);
						if (wall_style == "corrugated")
							corrugated_wall(h=platform_length, l=rail_width-joiner_width, thick=rail_thick, strut=rail_thick, wall=3);
					}

					// Side Walls
					mirror_copy([1, 0, 0]) {
						translate([(rail_spacing+joiner_width)/2, 0, 0]) {
							// Upper Wall.
							grid_of(
								ya=[(rail_height+5)/2],
								za=[rail_height+groove_height]
							) {
								if (wall_style == "crossbeams")
									translate([0, 0, (platform_length-rail_height)/2-groove_height])
										sparse_strut(h=platform_length-rail_height, l=rail_height+5, thick=joiner_width, strut=5);
								if (wall_style == "thinwall")
									translate([0, 0, (platform_length-rail_height)/2-groove_height])
										thinning_wall(h=platform_length-rail_height, l=rail_height+5, thick=joiner_width, strut=rail_thick, bracing=false);
								if (wall_style == "corrugated")
									translate([0, 0, (platform_length-rail_height)/2-groove_height])
										corrugated_wall(h=platform_length-rail_height, l=rail_height+5, thick=joiner_width, strut=rail_thick, wall=3);
							}

							// Lower Wall.
							grid_of(
								ya=[(platform_length-joiner_length+1)/2]
							) {
								if (wall_style == "crossbeams")
									translate([0, 0, (rail_height+rail_thick)/2])
										sparse_strut(l=platform_length-joiner_length+1, h=rail_height+rail_thick, thick=joiner_width, strut=5);
								if (wall_style == "thinwall")
									translate([0, 0, (rail_height+rail_thick)/2])
										thinning_wall(l=platform_length-joiner_length+1, h=rail_height+rail_thick, thick=joiner_width, strut=rail_thick, bracing=true);
								if (wall_style == "corrugated")
									translate([0, 0, (rail_height)/2])
										corrugated_wall(l=platform_length-joiner_length+1, h=rail_height, thick=joiner_width, strut=rail_thick, wall=3);
							}

							// Rail tops.
							translate([0, rail_height, rail_height]) {
								translate([0, (platform_length-rail_height)/2, groove_height/2])
									cube(size=[joiner_width, platform_length-rail_height, groove_height], center=true);
								translate([0, groove_height/2, (platform_length-rail_height)/2])
									cube(size=[joiner_width, groove_height, platform_length-rail_height], center=true);
							}
						}
					}
				}

				// Shrinkage stress relief
				translate([0, platform_length/2, rail_thick/2]) {
					grid_of(count=[1, 7], spacing=[0, 12]) {
						cube(size=[rail_width+1, 1, rail_thick-2], center=true);
					}
					grid_of(count=[9, 2], spacing=[12, platform_length-10]) {
						cube(size=[1, 20, rail_thick-2], center=true);
					}
				}

				// Clear space for front joiners.
				translate([0, platform_length, rail_height/2]) {
					joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height+0.001, w=joiner_width, clearance=5, a=joiner_angle);
				}

				// Clear space for back joiners.
				translate([0, -6, rail_height/2]) {
					zrot(180) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height+0.001, w=joiner_width, a=joiner_angle);
				}

				// Clear space for side joiners.
				translate([0, platform_length/2, rail_height/2]) {
					zrot(90) joiner_quad_clear(xspacing=platform_length/2, yspacing=rail_width+2*6, h=rail_height+0.001, w=joiner_width, a=joiner_angle);
				}

				// Clear space for top joiners.
				translate([0, rail_height/2, platform_length]) {
					xrot(90) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width+0.001, clearance=5, a=joiner_angle);
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
			translate([0, platform_length/2, rail_height/2]) {
				zrot(90) joiner_quad(xspacing=platform_length/2, yspacing=rail_width+2*6, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}

			// Top joiners.
			translate([0, rail_height/2, platform_length]) {
				xrot(90) joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}

			translate([0, platform_length-joiner_length, rail_height/4]) {
				difference() {
					// Side supports.
					cube(size=[rail_width, 5, rail_height/2], center=true);

					// Wiring access holes.
					grid_of(xa=[-rail_width/4, rail_width/4])
						cube(size=[10, 10, 10], center=true);
				}
			}
		}
	}
}
//yz_joiner();



module yz_joiner_parts() { // make me
	translate([0, -platform_length/2, 0]) yz_joiner();
}



yz_joiner_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

