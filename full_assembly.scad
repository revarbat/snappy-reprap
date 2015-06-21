$do_prerender=true;

include <config.scad>
include <GDMUtils.scad>
use <NEMA.scad>

use <bridge_center_parts.scad>
use <bridge_segment_parts.scad>
use <cable_chain_link_parts.scad>
use <cable_chain_mount_parts.scad>
use <drive_gear_parts.scad>
use <extruder_platform_parts.scad>
use <fan_shroud_parts.scad>
use <lifter_rod_coupler_parts.scad>
use <motor_mount_plate_parts.scad>
use <platform_support_parts.scad>
use <rail_endcap_parts.scad>
use <rail_segment_parts.scad>
use <rail_xy_motor_segment_parts.scad>
use <rail_z_motor_segment_parts.scad>
use <sled_endcap_parts.scad>
use <support_leg_parts.scad>
use <xy_joiner_parts.scad>
use <xy_sled_parts.scad>
use <yz_bottom_joiner_parts.scad>
use <yz_top_joiner_parts.scad>
use <z_sled_parts.scad>
use <z_strut_parts.scad>



module x_axis_slider_assembly(slidepos=0)
{
	platform_vert_off = rail_height+groove_height+rail_offset;

	zring(n=2) {
		fwd(motor_rail_length/2) {
			translate([0, -rail_length/2, 0]) {
				rail_segment();
			}
		}
	}
	rail_xy_motor_segment();

	// Stepper Motor
	up(rail_height-5-20) {
		motor_mount_plate();
		up(20-4-0.2) {
			nema17_stepper(h=34, shaft_len=20.05);
			up(19) {
				drive_gear();
			}
		}
	}

	// Sleds
	translate([0, slidepos, platform_vert_off]) {
		yspread(platform_length) {
			yrot(180) {
				xy_sled();
			}
		}
		children();
	}
}


module y_axis_slider_assembly(slidepos=0)
{
	platform_vert_off = rail_height+groove_height+rail_offset;

	zring(n=2) {
		fwd(motor_rail_length/2) {
			fwd(rail_length/2) {
				rail_segment();
				fwd(rail_length/2+platform_length) {
					// Bottom Y-axis to Z-axis corner joiner.
					yz_bottom_joiner();

					// Support legs.
					back(platform_length/2) {
						zring(n=2) {
							right(rail_width/2+2*7) {
								zrot(-90) support_leg();
							}
						}
					}
				}
			}
		}
	}
	rail_xy_motor_segment();

	// Stepper Motor
	up(rail_height-5-20) {
		motor_mount_plate();
		up(20-4-0.2) {
			nema17_stepper(h=34, shaft_len=20.05);
			up(19) {
				drive_gear();
			}
		}
	}

	// Sleds
	translate([0, slidepos, platform_vert_off]) {
		yspread(platform_length) {
			yrot(180) {
				xy_sled();
			}
		}
		children();
	}
}


module z_axis_slider_assembly(slidepos=0)
{
	platform_vert_off = rail_height+groove_height+rail_offset;

	fwd(motor_rail_length) {
		yspread(rail_length) {
			rail_segment();
		}
	}
	back(motor_rail_length) {
		zrot(180) rail_z_motor_segment();
	}

	up(rail_height+groove_height/2) {
		back(rail_length-motor_rail_length/2) {
			// Stepper Motor
			xrot(90) {
				motor_mount_plate();
				up(20-4-0.2) {
					nema17_stepper(h=34, shaft_len=20.05);
					up(5) {
						color("darkgrey") {
							zrot(slidepos/lifter_thread_size*360.0) {
								lifter_rod_coupler();
							}
						}
						up(lifter_rod_length/2+16) {
							color("silver") cylinder(d=lifter_rod_diam, h=lifter_rod_length, center=true);
						}
					}
				}
			}
		}
	}
}


module bridge_assembly()
{
	zring(n=2) {
		fwd(motor_rail_length/2) {
			fwd(rail_length/2) {
				bridge_segment();
				fwd(rail_length/2+platform_length) {
					yz_top_joiner();
				}
			}
		}
	}
	bridge_center();
}


module extruder_assembly(slidepos=0)
{
	platform_vert_off = groove_height+rail_offset;

	down(platform_length/2-slidepos) {
		zring(n=2) {
			fwd(extruder_length/2) {
				fwd(motor_rail_length/2) {
					z_strut();
					fwd(motor_rail_length/2+cantilever_length) {
						zrot(90) z_sled();
					}
				}
			}
		}
		extruder_platform();
		translate([rail_width/2+5, 0, 5]) {
			yrot(30) fan_shroud();
		}
	}
}


module full_assembly(hide_endcaps=false)
{
	joiner_length=20;
	xpos = 100*cos(360*$t);
	ypos = 100*sin(360*$t);
	zpos = 80*cos(240+360*$t)+10;

	// Top bridge
	up(2*rail_height+motor_rail_length+2*rail_length+groove_height) {
		xrot(180) bridge_assembly();
	}

	// Extruder bridge
	up(rail_height+motor_rail_length+rail_length+groove_height) {
		extruder_assembly(zpos);
	}

	zring(n=2) {
		fwd(platform_length + rail_length + motor_rail_length/2) {
			up(rail_height + groove_height + rail_length) {
				xrot(-90) {
					// Z-axis rails.
					z_axis_slider_assembly(zpos);
				}
			}
		}
	}

	// Y-axis rails.
	y_axis_slider_assembly(ypos) {
		// X-axis to Y-axis joiners.
		zrot_copies([0, 180]) {
			fwd(platform_length) {
				xy_joiner();
			}
		}
		translate([(platform_width-joiner_width)/2, -platform_length, 0]) {
			zrot(180) cable_chain_xy_mount();
		}
		zrot(90) {
			// X-axis rail endcaps.
			if (hide_endcaps == false) {
				zrot_copies([0, 180]) {
					fwd(rail_length + motor_rail_length/2) {
						rail_endcap();
					}
				}
			}

			// X-axis rails.
			x_axis_slider_assembly(xpos) {
				zrot_copies([0, 180]) {
					fwd(platform_length) {
						sled_endcap();
						fwd(20-joiner_width/2) {
							right(platform_width/2) {
								zrot(90) platform_support2();
							}
							left(platform_width/2) {
								zrot(270) platform_support1();
							}
						}
					}
				}
				up(3+glass_thick/2) {
					// Borosilicate Glass.  Render last to allow transparency to work.
					color([0.75, 1.0, 1.0, 0.5]) {
						cube(size=[glass_length, glass_width, glass_thick], center=true);
					}
				}
			}
		}
	}
}


full_assembly(hide_endcaps=false);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

