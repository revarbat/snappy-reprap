include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>

use <cantilever_joint_parts.scad>
use <cantilever_arm_parts.scad>
use <drive_gear_parts.scad>
use <extruder_platform_parts.scad>
use <lifter_nut_cap_parts.scad>
use <lifter_nut_parts.scad>
use <lifter_rod_coupler_parts.scad>
use <motor_mount_plate_parts.scad>
use <rail_endcap_parts.scad>
use <rail_motor_segment_parts.scad>
use <rail_segment_parts.scad>
use <sled_endcap_parts.scad>
use <support_leg_parts.scad>
use <xy_joiner_parts.scad>
use <xy_sled_parts.scad>
use <yz_joiner_parts.scad>
use <z_sled_parts.scad>


// Set default camera position.
$vpd = 3500;
$vpt = [0, 0, 160];
$vpr = [65, 0, 120];


module full_assembly(hide_endcaps=false)
{
	joiner_length=15;
	platform_vert_off = rail_height+groove_height+rail_offset;

	// Y-axis to Z-axis corner joiner.
	yz_joiner();

	// Z-Axis Stepper Motor
	translate([0, rail_height+groove_height/2, 0]) {
		translate([0, 0, 40]) {
			zrot(90) motor_mount_plate();
			translate([0, 0, 5.9+rail_thick]) {
				nema17_stepper(h=34, shaft_len=20.05);
				translate([0, 0, 30]) {
					color("DimGray")
						lifter_rod_coupler();
					translate([0, 0, lifter_rod_length/2]) {
						color("silver")
							cylinder(h=lifter_rod_length, r=lifter_rod_diam/2, center=true);
					}
				}
			}
		}
	}

	// Support legs.
	translate([0, platform_length/2, 0]) {
		zrot_copies([0,180]) {
			translate([rail_spacing/2+joiner_width+10, 0, 0]) {
				zrot(-90) support_leg();
			}
		}
	}

	translate([0, platform_length, 0]) {
		// Y-axis rails.
		translate([0, rail_length/2, 0]) {
			rail_segment();
			translate([0, rail_length/2+motor_rail_length/2, 0]) {
				rail_motor_segment();
				translate([0, motor_rail_length/2+rail_length/2, 0]) {
					rail_segment();
					if (hide_endcaps == false) {
						translate([0, rail_length/2, 0]) {
							zrot(180) rail_endcap();
						}
					}
				}

				// Y-Axis Stepper Motor
				translate([0, 0, 30]) {
					motor_mount_plate();
					translate([0, 0, 5.9+rail_thick]) {
						nema17_stepper(h=34, shaft_len=20.05);
						translate([0, 0, 17]) {
							drive_gear();
						}
					}
				}
			}
		}


		translate([0, rail_length+motor_rail_length/2, 0]) {
			// Y-axis slider platform.
			translate([0, 0, platform_vert_off]) {
				grid_of(ya=[-platform_length/2, platform_length/2]) {
					yrot(180) {
						xy_sled();
					}
				}
			}

			// X-axis to Y-axis joiners.
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
					rail_segment();
				}
				rail_motor_segment();
				if (hide_endcaps == false) {
					zrot_copies([0, 180]) {
						translate([0, rail_length+motor_rail_length/2, 0]) {
							zrot(180) rail_endcap();
						}
					}
				}

				// X-Axis Stepper Motor
				translate([0, 0, 30]) {
					motor_mount_plate();
					translate([0, 0, 5.9+rail_thick]) {
						nema17_stepper(h=34, shaft_len=20.05);
						translate([0, 0, 17]) {
							drive_gear();
						}
					}
				}

				// X-axis slider platform.
				translate([0, 0, platform_vert_off]) {
					grid_of(ya=[-platform_length/2, platform_length/2]) {
						yrot(180) {
							xy_sled();
						}
					}
					if (hide_endcaps == false) {
						zrot_copies([0, 180]) {
							translate([0, -platform_length, 0]) {
								sled_endcap();
							}
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
				xrot(-90) rail_segment();
		}
		if (hide_endcaps == false) {
			translate([0, 0, 2*rail_length]) {
				xrot(-90) rail_endcap();
			}
		}

		translate([0, platform_vert_off, rail_length]) {
			// Vertical Z-axis platform.
			xrot(-90) yrot(180) {
				z_sled();
				z_sled_nuts();
			}

			translate([0, 0, platform_length/2]) {
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



translate([0,-1.5*rail_length,0])
	full_assembly(hide_endcaps=false);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

