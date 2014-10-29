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
					difference() {
						union() {
							translate([0, platform_length/2, rail_thick/2]) {
								yrot(90)
									sparse_strut(h=rail_width, l=platform_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
							}
							translate([0, rail_height+groove_height/2, rail_thick/2]) {
								cube(size=[45+20, motor_mount_spacing+joiner_width, rail_thick], center=true);
							}
						}
						translate([0, rail_height+groove_height/2, rail_thick/2]) {
							cube(size=[45, motor_mount_spacing-joiner_width, rail_thick+1], center=true);
						}
					}

					// Flanges on sides to reduce peeling.
					grid_of(
						xa=[-(rail_spacing/2+joiner_width), (rail_spacing/2+joiner_width)]
					) {
						hull() {
							grid_of(
								ya=[-6+6, (platform_length-6)],
								za=[1/2]
							) {
								cylinder(h=1, r=6, center=true, $fn=24);
							}
						}
					}
					translate([0, -6/2, 1/2])
					cube(size=[rail_width, 6, 1], center=true);


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

				// Clear space for front joiners.
				translate([0, platform_length, rail_height/2]) {
					joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, clearance=5, a=joiner_angle);
				}

				// Clear space for back joiners.
				translate([0, -6, rail_height/2]) {
					zrot(180) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, a=joiner_angle);
				}

				// Clear space for side joiners.
				translate([0, platform_length/2, rail_height/2]) {
					zrot(90) joiner_quad_clear(xspacing=platform_length/2, yspacing=rail_width+2*6, h=rail_height, w=joiner_width, a=joiner_angle);
				}

				// Clear space for top joiners.
				translate([0, rail_height/2, platform_length]) {
					xrot(90) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, clearance=5, a=joiner_angle);
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

			translate([0, rail_height+groove_height/2, 0]) {
				// Motor mount joiners.
				translate([0, 0, 40]) {
					zrot(90) xrot(90) joiner_pair(spacing=43+joiner_width+10, h=rail_height, w=joiner_width, l=40, a=joiner_angle);
				}
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

