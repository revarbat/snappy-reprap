include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>

use <cantilever_joint_parts.scad>
use <cantilever_arm_parts.scad>
use <drive_gear_parts.scad>
use <extruder_platform_parts.scad>
use <motor_mount_plate_parts.scad>
use <rail_endcap_parts.scad>
use <rail_motor_segment_parts.scad>
use <rail_segment_parts.scad>
use <sled_endcap_parts.scad>
use <sled_parts.scad>
use <support_leg_parts.scad>
use <xy_joiner_parts.scad>
use <yz_joiner_parts.scad>


// Set default camera position.
$vpd = 3500;
$vpt = [0, 0, 160];
$vpr = [65, 0, 120];


platform_vert_off = rail_height+groove_height+rail_offset;


module axis_slider_assembly()
{
	translate([0, -motor_rail_length/2, 0]) {
		translate([0, -rail_length/2, 0]) {
			rail_segment();
		}
	}
	rail_motor_segment();
	translate([0, motor_rail_length/2, 0]) {
		translate([0, rail_length/2, 0]) {
			rail_segment();
		}
	}

	// Stepper Motor
	translate([0, 0, 30]) {
		motor_mount_plate();
		translate([0, 0, 5.9+rail_thick]) {
			nema17_stepper(h=34, shaft_len=20.05);
			translate([0, 0, 17]) {
				drive_gear();
			}
		}
	}

	// Sleds
	translate([0, 0, platform_vert_off]) {
		grid_of(ya=[-platform_length/2, platform_length/2]) {
			yrot(180) {
				sled();
			}
		}
	}
}


module full_assembly(hide_endcaps=false)
{
	joiner_length=15;

	// Y-axis to Z-axis corner joiner.
	yz_joiner();

	// Support legs.
	translate([0, platform_length/2, 0]) {
		zrot_copies([0,180]) {
			translate([rail_width/2+2*7, 0, 0]) {
				zrot(-90) support_leg();
			}
		}
	}

	translate([0, platform_length + rail_length + motor_rail_length/2, 0]) {
		// Y-axis rails.
		axis_slider_assembly();
		if (hide_endcaps == false) {
			translate([0, motor_rail_length/2 + rail_length, 0]) {
				zrot(180) rail_endcap();
			}
		}

		// X-axis to Y-axis joiners.
		translate([0, 0, platform_vert_off]) {
			zrot_copies([0, 180]) {
				translate([0, -platform_length, 0]) {
					xy_joiner();
				}
			}
			zrot(90) {
				// X-axis rails.
				axis_slider_assembly();
				if (hide_endcaps == false) {
					zrot_copies([0, 180]) {
						translate([0, -(rail_length + motor_rail_length/2), 0]) {
							rail_endcap();
						}
						translate([0, -platform_length, platform_vert_off]) {
							sled_endcap();
						}
					}
				}
			}
		}
	}

	translate([0, 0, platform_length + rail_length + motor_rail_length/2]) {
		xrot(-90) {
			// Z-axis rails.
			axis_slider_assembly();
			if (hide_endcaps == false) {
				translate([0, -(motor_rail_length/2 + rail_length), 0]) {
					rail_endcap();
				}
			}
			translate([0, 0, platform_vert_off]) {
				translate([0, -platform_length, 0]) {
					xrot(90) {
						// Z-axis platform to extruder cantilever joint.
						cantilever_joint();

						// Extruder cantilever.
						translate([0, joiner_length, -(platform_length+rail_height)/2]) {
							translate([0, cantilever_length/2, 0]) {
								cantilever_arm();
								translate([0, cantilever_length/2, 0]) {
									extruder_platform();
								}
							}
						}
					}
				}
			}
		}
	}
}



translate([0,-1.5*rail_length,0])
	full_assembly(hide_endcaps=false);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

