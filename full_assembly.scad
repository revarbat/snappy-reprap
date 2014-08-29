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
	joiner_length=10;
	platform_vert_off = rail_height+roller_base+roller_thick/2+5;

	// Y-axis to Z-axis corner joiner.
	rails_90deg_joint();

	// Support legs.
	translate([0, platform_length/2, 0]) {
		zrot_copies([0,180]) {
			translate([rail_spacing/2+joiner_width+7, 0, 0]) {
				zrot(-90) support_leg();
			}
		}
	}

	translate([0, platform_length, 0]) {
		// Y-axis rails.
		translate([0, rail_length/2, 0]) {
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
			translate([0, 0, platform_vert_off]) {
				grid_of(ya=[-platform_length/2, platform_length/2]) {
					yrot(180) slider_sled(show_rollers=true, with_rack=true);
				}
			}

			// X-axis to Y-axis vertical joiners.
			translate([0, 0, platform_vert_off]) {
				zrot_copies([0, 180]) {
					translate([0, -platform_length, 0]) {
						xy_joiner();
					}
				}
			}

			zrot(90) translate([0, 0, platform_vert_off]) {
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

				// X-axis slider platform.
				translate([0, 0, platform_vert_off]) {
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
		// Vertical Z-axis slider rails.
		for(i = [0:1]) {
			translate([0, 0, (i+0.5)*rail_length])
				xrot(-90) rail_structure();
		}
		translate([0, 0, 2*rail_length]) {
			xrot(-90) rails_end();
		}

		translate([0, platform_vert_off, rail_length]) {
			// Vertical Z-axis platform.
			xrot(-90) yrot(180) slider_sled(show_rollers=true, with_rack=false);

			// Z-axis platform to extruder cantilever joint.
			translate([0, 0, platform_length/2]) {
				zrot(180) z_platform_joint();
			}

			translate([0, joiner_length, 0]) {
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


