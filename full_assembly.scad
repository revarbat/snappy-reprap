include <config.scad>
use <GDMUtils.scad>

use <cap_parts.scad>
use <drive_gear_parts.scad>
use <motor_mount_plate_parts.scad>
use <sled_end_parts.scad>
use <rail_with_motor_mount_part.scad>
use <rails_90deg_joint_part.scad>
use <rails_end_part.scad>
use <rails_part.scad>
use <roller_parts.scad>
use <support_leg_part.scad>
use <xy_joiner_parts.scad>
use <z_platform_joint_part.scad>

use <slider_sled.scad>


// Set default camera position.
$vpd = 650;
$vpt = [45, -165, 165];
$vpr = [68, 0, 315];


module full_assembly()
{
	joiner_length=15;
	platform_vert_off = rail_height+roller_base+roller_thick/2+5;

	x_rail_color = [1.0, 0.6, 0.6];
	x_sled_color = [1.0, 0.4, 0.4];
	y_rail_color = [0.6, 1.0, 0.6];
	y_sled_color = [0.4, 0.8, 0.4];
	z_rail_color = [0.6, 0.6, 1.0];
	z_sled_color = [0.4, 0.4, 1.0];
	e_color = [0.8, 0.6, 0.9];

	// Y-axis to Z-axis corner joiner.
	color((y_rail_color+z_rail_color)/2) rails_90deg_joint();

	// Support legs.
	color((y_rail_color+z_rail_color)/2) translate([0, platform_length/2, 0]) {
		zrot_copies([0,180]) {
			translate([rail_spacing/2+joiner_width+7, 0, 0]) {
				zrot(-90) support_leg();
			}
		}
	}

	translate([0, platform_length, 0]) {
		// Y-axis rails.
		color(y_rail_color) translate([0, rail_length/2, 0]) {
			rail_structure();
			translate([0, rail_length/2+motor_rail_length/2, 0]) {
				rail_with_motor_mount(show_motor=true);
				translate([0, motor_rail_length/2+rail_length/2, 0]) {
					rail_structure();
					translate([0, rail_length/2, 0]) {
						zrot(180) rails_end();
					}
				}
			}
		}


		translate([0, rail_length+motor_rail_length/2, 0]) {
			// Y-axis slider platform.
			color(y_sled_color) translate([0, 0, platform_vert_off]) {
				grid_of(ya=[-platform_length/2, platform_length/2]) {
					yrot(180) slider_sled(show_rollers=true, with_rack=true);
				}
			}

			// X-axis to Y-axis joiners.
			color((x_rail_color+y_rail_color)/2) translate([0, 0, platform_vert_off]) {
				zrot_copies([0, 180]) {
					translate([0, -platform_length, 0]) {
						xy_joiner();
					}
				}
			}

			zrot(90) translate([0, 0, platform_vert_off]) {
				color(x_rail_color) {
					// Horizontal X-axis rails.
					grid_of(ya=[-(rail_length+motor_rail_length)/2, (rail_length+motor_rail_length)/2]) {
						rail_structure();
					}
					rail_with_motor_mount(show_motor=true);
					zrot_copies([0, 180]) {
						translate([0, rail_length+motor_rail_length/2, 0]) {
							zrot(180) rails_end();
						}
					}
				}

				// X-axis slider platform.
				color(x_sled_color) translate([0, 0, platform_vert_off]) {
					grid_of(ya=[-platform_length/2, platform_length/2]) {
						yrot(180) slider_sled(show_rollers=true, with_rack=true);
					}
					zrot_copies([0, 180]) {
						translate([0, -platform_length, 0]) {
							yrot(180) sled_end();
						}
					}
				}
			}
		}
	}

	translate([0, 0, platform_length]) {
		color(z_rail_color) {
			// Vertical Z-axis slider rails.
			for(i = [0:1]) {
				translate([0, 0, (i+0.5)*rail_length])
					xrot(-90) rail_structure();
			}
			translate([0, 0, 2*rail_length]) {
				xrot(-90) rails_end();
			}
		}

		translate([0, platform_vert_off, rail_length]) {
			color(z_sled_color) {
				// Vertical Z-axis platform.
				xrot(-90) yrot(180) slider_sled(show_rollers=true, with_rack=false, nut_size=threaded_rod_diam);
			}

			// Z-axis platform to extruder cantilever joint.
			color((z_sled_color+e_color)/2) translate([0, 0, platform_length/2]) {
				zrot(180) z_platform_joint();
			}

			color(e_color) translate([0, joiner_length, 0]) {
				// Extruder cantilever.
				for (i=[0:1]) {
					translate([0, (i+0.5)*rail_length, 0]) {
						rail_structure();
					}
				}
			}
		}
	}
}



zrot(180) full_assembly();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap


