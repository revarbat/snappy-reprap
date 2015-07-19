$do_prerender=true;

include <config.scad>
include <GDMUtils.scad>
use <NEMA.scad>
use <acme_screw.scad>

use <cable_chain_link_parts.scad>
use <cable_chain_mount_parts.scad>
use <drive_gear_parts.scad>
use <extruder_platform_parts.scad>
use <fan_shroud_parts.scad>
use <filament_hanger_parts.scad>
use <lifter_rod_coupler_parts.scad>
use <lifter_lock_nut_parts.scad>
use <motor_mount_plate_parts.scad>
use <motherboard_mount_parts.scad>
use <platform_support_parts.scad>
use <rail_endcap_parts.scad>
use <rail_segment_parts.scad>
use <rail_xy_motor_segment_parts.scad>
use <rail_z_motor_segment_parts.scad>
use <sled_endcap_parts.scad>
use <support_leg_parts.scad>
use <xy_joiner_parts.scad>
use <xy_sled_parts.scad>
use <yz_joiner_parts.scad>
use <z_sled_parts.scad>
use <z_strut_parts.scad>


module arrow(size=10, headpart=0.4) {
	color("orange")
	yrot(90) {
		down(size/2)
		union() {
			up(size*headpart/2) cylinder(d1=0, d2=size/2, h=size*headpart, center=true, $fn=18);
			up(size/2+size*headpart/2) cylinder(d=size/6, h=size*(1-headpart), center=true, $fn=18);
		}
	}
}
//!arrow(size=200);


module x_sled_assembly(explode=0, arrows=false)
{
	platform_vert_off = groove_height/2+rail_offset;
	up(platform_vert_off) {
		xspread(platform_length+explode) {
			zrot(90) yrot(180) xy_sled();
		}
		zrot_copies([0,180]) {
			right(platform_length+explode*1.5) {
				zrot(90) xy_joiner();
			}
		}
		children();
	}

	// Construction arrows.
	if(arrows && explode>20) {
		zring(r=platform_length+explode*3/4) {
			arrow(size=explode/3);
		}
	}
}
//!x_sled_assembly(explode=100, arrows=true);


module y_sled_assembly(explode=0, arrows=false)
{
	platform_vert_off = groove_height/2+rail_offset;
	up(platform_vert_off) {
		yspread(platform_length+explode) {
			yrot(180) xy_sled();
		}
		zrot_copies([0,180]) {
			fwd(platform_length+explode*1.5) {
				sled_endcap();
				fwd(20-joiner_width/2) {
					right(platform_width/2+explode*1.5) {
						zrot(90) platform_support2();
					}
					left(platform_width/2+explode*1.5) {
						zrot(-90) platform_support1();
					}
				}
			}
		}
		children();
	}

	// Construction arrows.
	if(arrows && explode>10) {
		zrot(90) zring(r=platform_length+explode) {
			arrow(size=explode/3);
		}
		yspread(platform_length*2+3*explode+20-joiner_width/2) {
			zring(r=(platform_width+explode*1.5)/2) {
				arrow(size=explode/3);
			}
		}
	}
}
//!y_sled_assembly(explode=100, arrows=true);


module xy_motor_segment_assembly(explode=0, arrows=false)
{
	motor_width = nema_motor_width(17)+printer_slop*2;

	rail_xy_motor_segment();

	// Stepper Motor
	up(motor_top_z) {
		up(explode*2-motor_length/2) motor_mount_plate();
		up(explode) {
			nema17_stepper(h=motor_length, shaft_len=motor_shaft_length);
			up(gear_base+rack_height/2+2.1+explode*2) {
				drive_gear();
			}
		}
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(rail_height+groove_height+explode/8) {
			yrot(-90) arrow(size=explode/3);
			up(motor_length+explode*7/8) {
				yrot(-90) arrow(size=explode/3);
				up(5+explode) {
					yrot(-90) arrow(size=explode/3);
				}
			}
		}
	}
}
//!xy_motor_segment_assembly(explode=100, arrows=true);
//!xy_motor_segment_assembly();


module z_motor_segment_assembly(slidepos=0, explode=0, arrows=false)
{
	motor_width = nema_motor_width(17)+printer_slop*2;

	zrot(90) xrot(90) rail_z_motor_segment();

	right(rail_height+groove_height/2+explode) {
		up(explode/2) {
			zrot(90) motor_mount_plate();
			up(motor_length/2-0.1) {
				down(explode) nema17_stepper(h=motor_length, shaft_len=motor_shaft_length);
				zrot(slidepos/lifter_rod_pitch*360.0) {
					up(motor_shaft_length+explode) {
						color("darkgrey") {
							lifter_rod_coupler();
						}
						color("grey") {
							up(30/2+10/2+explode) {
								zrot(180) lifter_lock_nut();
							}
						}
						up(lifter_rod_length/2+2*explode) {
							color("silver") {
								acme_threaded_rod(
									d=lifter_rod_diam,
									l=lifter_rod_length,
									pitch=lifter_rod_pitch,
									thread_depth=lifter_rod_pitch/2,
									$fn=32
								);
							}
						}
					}
				}
			}
		}
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(explode/4) {
			right(explode) {
				yrot(-45) xrot(-90) arrow(size=explode/3);
			}
			right(rail_height+groove_height/2+explode) {
				down(explode/10) yrot(90) arrow(size=explode/3);
				up(explode) {
					yrot(-90) arrow(size=explode/3);
					up(30+explode) {
						yrot(-90) arrow(size=explode/3);
						up(explode) {
							yrot(-90) arrow(size=explode/3);
						}
					}
				}
			}
		}
	}
}
//!z_motor_segment_assembly(explode=100, arrows=true);
//!z_motor_segment_assembly();


module x_axis_slider_assembly(slidepos=0, explode=0, arrows=false)
{
	platform_vert_off = rail_height+groove_height/2;

	zrot(90) xy_motor_segment_assembly();
	xspread(motor_rail_length+rail_length+2*explode) {
		zrot(90) rail_segment();
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(rail_height/2+groove_height/2) {
			zring(r=(motor_rail_length+explode)/2) {
				arrow(size=explode/3);
			}
		}
	}

	// Left Z Tower
	left(motor_rail_length/2+rail_length+2*explode) {
		if ($children > 0) children(0);
	}

	// Right Z Tower
	right(motor_rail_length/2+rail_length+2*explode) {
		if ($children > 1) children(1);
	}

	// Sled
	up(platform_vert_off) {
		left(slidepos) {
			if ($children > 2) children(2);
		}
	}
}
//!x_axis_slider_assembly(slidepos=50, explode=100, arrows=true);
//!x_axis_slider_assembly(slidepos=0) {sphere(1); sphere(1); x_sled_assembly();}


module y_axis_slider_assembly(slidepos=0, hide_endcaps=false, explode=0, arrows=false)
{
	platform_vert_off = rail_height+groove_height/2;

	xy_motor_segment_assembly();
	yspread(motor_rail_length+rail_length+2*explode) {
		rail_segment();
	}
	zrot(90) zring(r=(motor_rail_length+2*rail_length+4*explode)/2) {
		if (hide_endcaps == false) {
			zrot(90) rail_endcap();
		}
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(rail_height/2+groove_height/2) {
			zrot(90) zring(r=(motor_rail_length+explode)/2) {
				arrow(size=explode/3);
			}
			zrot(90) zring(r=(motor_rail_length+2*rail_length+3*explode)/2) {
				arrow(size=explode/3);
			}
		}
	}

	// Sled
	up(platform_vert_off) {
		fwd(slidepos) {
			children();
		}
	}
}
//!y_axis_slider_assembly(explode=100, arrows=true);
//!y_axis_slider_assembly(slidepos=90) y_sled_assembly();


module z_tower_assembly(slidepos=0, hide_endcaps=false, explode=0, arrows=false, isback=false)
{
	left(platform_length)
	zrot(-90) {
		yz_joiner();
		if (!isback && $children > 1) {
			fwd(6+explode) {
				children(1);
			}
		}
		back(platform_length/2) {
			zring(r=rail_width/2+14+explode) {
				zrot(-90) support_leg();
			}
		}
		up(rail_height+groove_height+motor_rail_length/2+explode) {
			if (isback && $children > 0) {
				up(motor_rail_length/2+10+explode/2) {
					fwd(explode) {
						children(0);
					}
				}
			}
			zrot(90) z_motor_segment_assembly(slidepos=slidepos);

			up(motor_rail_length/2+rail_length+explode*1.5) {
				zspread(rail_length+explode) {
					xrot(-90) rail_segment();
				}
				up(slidepos) {
					back(rail_height+groove_height/2) {
						if (!isback && $children > 0) children(0);
					}
				}
				up(rail_length+explode*1.5) {
					if (hide_endcaps == false) {
						xrot(-90) rail_endcap();
					}
				}
			}
		}

		// Construction arrows.
		if (arrows && explode>10) {
			back(rail_height/2+groove_height/2) {
				up(rail_height+groove_height+explode/2) {
					yrot(-90) arrow(size=explode/3);
					up(motor_rail_length+explode) {
						yrot(-90) arrow(size=explode/3);
						up(rail_length+explode) {
							yrot(-90) arrow(size=explode/3);
							up(rail_length+explode) {
								yrot(-90) arrow(size=explode/3);
							}
						}
					}
				}
				up(rail_height/2+groove_height/2) {
					zring(r=rail_width/2+explode/2) {
						arrow(size=explode/3);
					}
				}
			}
		}
	}
}
//!z_tower_assembly(slidepos=25.4/8/4, explode=0, arrows=true);


module extruder_bridge_assembly(slidepos=0, explode=0, arrows=false)
{
	platform_vert_off = groove_height/2+rail_offset;

	back(extruder_length/2+motor_rail_length+cantilever_length+2*explode)
	down(platform_length/2-slidepos) {
		extruder_platform();
		yspread(extruder_length+motor_rail_length+2*explode) {
			z_strut();
		}
		zrot(90) zring(r=(extruder_length+2*motor_rail_length+2*cantilever_length+4*explode)/2) {
			zrot(180) z_sled();
		}

		right(rail_width/2+5+explode) {
			up(5) yrot(30) fan_shroud();
		}

		// Construction arrows.
		if(arrows && explode>10) {
			up(rail_height/2+groove_height/2) {
				zrot(90) zring(r=(extruder_length+explode)/2) {
					arrow(size=explode/3);
				}
				zrot(90) zring(r=(extruder_length+2*motor_rail_length+3*explode)/2) {
					arrow(size=explode/3);
				}
			}
			right(platform_width/2+explode/2) {
				arrow(size=explode/3);
			}
		}

		up(platform_thick) children();
	}
}
//!extruder_bridge_assembly(explode=100, arrows=true);
//!extruder_bridge_assembly();


// Borosilicate Glass.  Render last to allow transparency to work.
module build_platform() {
	up(3+glass_thick/2) {
		color([0.75, 1.0, 1.0, 0.5]) {
			cube(size=[glass_length, glass_width, glass_thick], center=true);
		}
	}
}



module full_assembly(hide_endcaps=false, explode=0, arrows=false)
{
	joiner_length=20;
	xpos = 100*cos(360*$t);
	ypos = 100*sin(360*$t);
	zpos = 80*cos(240+360*$t)+10;

	x_axis_slider_assembly(slidepos=xpos, explode=explode, arrows=arrows) {
		z_tower_assembly(slidepos=zpos, hide_endcaps=hide_endcaps, explode=explode, arrows=arrows) {
			extruder_bridge_assembly(explode=explode, arrows=arrows);
			zrot(180) motherboard_mount();
		}
		zrot(180) z_tower_assembly(slidepos=zpos, hide_endcaps=hide_endcaps, explode=explode, arrows=arrows, isback=true) {
			zrot(-90) filament_hanger();
		}
		x_sled_assembly(explode=explode, arrows=arrows) {
			y_axis_slider_assembly(slidepos=ypos, hide_endcaps=hide_endcaps, explode=explode, arrows=arrows)
				y_sled_assembly(explode=explode, arrows=arrows)
					build_platform();
		}
	}

	//cable_chain_xy_joiner_mount();
}


full_assembly(hide_endcaps=false);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
