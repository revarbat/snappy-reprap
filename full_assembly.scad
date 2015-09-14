$do_prerender=true;

include <config.scad>
include <GDMUtils.scad>
use <NEMA.scad>
use <acme_screw.scad>

use <cable_chain_link_parts.scad>
use <cable_chain_mount_parts.scad>
use <cooling_fan_shroud_parts.scad>
use <drive_gear_parts.scad>
use <extruder_fan_clip_parts.scad>
use <extruder_fan_shroud_parts.scad>
use <extruder_idler_parts.scad>
use <extruder_motor_clip_parts.scad>
use <jhead_platform_parts.scad>
use <motor_mount_plate_parts.scad>
use <platform_support_parts.scad>
use <rail_endcap_parts.scad>
use <rail_motor_segment_parts.scad>
use <rail_segment_parts.scad>
use <ramps_mount_parts.scad>
use <sled_endcap_parts.scad>
use <sled_parts.scad>
use <spool_holder_parts.scad>
use <support_leg_parts.scad>
use <xy_joiner_parts.scad>
use <yz_joiner_parts.scad>
use <z_joiner_parts.scad>



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


module x_sled_end_assembly(explode=0, arrows=false)
{
	up(groove_height/2+rail_offset) {
		zrot(90) yrot(180) sled();
		right(platform_length/2+explode*2) {
			zrot(90) xy_joiner();
		}
	}

	// Construction arrows.
	if(arrows && explode>20) {
		right(platform_length/2+explode*0.75) {
			arrow(size=explode/3);
		}
	}
}
//!x_sled_end_assembly(explode=100, arrows=true);


module x_sled_end_assembly2(explode=0, arrows=false)
{
	up(groove_height/2+rail_offset) {
		zrot(90) yrot(180) sled();
		left(platform_length/2+explode*2) {
			zrot(-90) xy_joiner();
		}
	}

	// Construction arrows.
	if(arrows && explode>20) {
		left(platform_length/2+explode*0.75) {
			zrot(180) arrow(size=explode/3);
		}
	}
}
//!x_sled_end_assembly2(explode=100, arrows=true);


module x_sled_assembly(explode=0, arrows=false)
{
	right((platform_length/2+explode/2)) {
		x_sled_end_assembly();
	}
	left((platform_length/2+explode/2)) {
		x_sled_end_assembly2();
	}
	up(groove_height/2+rail_offset) {
		children();
	}

	// Construction arrows.
	if(arrows && explode>20) {
		zring(r=explode/6) {
			arrow(size=explode/3);
		}
	}
}
//!x_sled_assembly(explode=100, arrows=true);


module y_sled_endcap_assembly(explode=0, arrows=false)
{
	sled_endcap();
	fwd(20-joiner_width/2) {
		right(platform_width/2+explode*1.5) {
			zrot(90) platform_support2();
		}
		left(platform_width/2+explode*1.5) {
			zrot(-90) platform_support1();
		}
	}

	// Construction arrows.
	fwd(20-joiner_width/2) {
		zring(r=(platform_width+explode*1.5)/2) {
			arrow(size=explode/3);
		}
	}
}
//!y_sled_endcap_assembly(explode=100, arrows=true);


module y_sled_end_assembly(explode=0, arrows=false)
{
	up(groove_height/2+rail_offset) {
		yrot(180) sled();
		fwd(platform_length/2+explode) {
			y_sled_endcap_assembly();
		}
	}

	// Construction arrows.
	if(arrows && explode>20) {
		fwd(platform_length/2+explode*0.5) {
			zrot(-90) arrow(size=explode/3);
		}
	}
}
//!y_sled_end_assembly(explode=100, arrows=true);


module y_sled_end_assembly2(explode=0, arrows=false)
{
	up(groove_height/2+rail_offset) {
		yrot(180) sled();
		back(platform_length/2+explode) {
			zrot(180) y_sled_endcap_assembly();
		}
	}

	// Construction arrows.
	if(arrows && explode>20) {
		back(platform_length/2+explode*0.5) {
			zrot(90) arrow(size=explode/3);
		}
	}
}
//!y_sled_end_assembly2(explode=100, arrows=true);


module y_sled_assembly(explode=0, arrows=false)
{
	fwd((platform_length/2+explode/2)) {
		y_sled_end_assembly();
	}
	back((platform_length/2+explode/2)) {
		y_sled_end_assembly2();
	}
	up(groove_height/2+rail_offset) {
		children();
	}

	// Construction arrows.
	if(arrows && explode>20) {
		zrot(-90) zring(r=explode/6) {
			arrow(size=explode/3);
		}
	}
}
//!y_sled_assembly(explode=100, arrows=true);


module z_sled_top_end_assembly(explode=0, arrows=false)
{
	right(groove_height/2+rail_offset) {
		zrot(-90) xrot(90) sled();
		up(platform_length/2+2*explode) {
			zrot(-90) z_joiner() {
				children();
			}
		}
	}

	// Construction arrows.
	if(arrows && explode>20) {
		up(platform_length/2+explode*0.5) {
			yrot(-90) arrow(size=explode/3);
		}
	}
}
//!z_sled_top_end_assembly(explode=100, arrows=true);


module z_sled_bottom_end_assembly(explode=0, arrows=false)
{
	right(groove_height/2+rail_offset) {
		zrot(-90) xrot(90) sled();
		down(platform_length/2+explode) {
			yrot(90) zrot(90) sled_endcap();
		}
	}

	// Construction arrows.
	if(arrows && explode>20) {
		down(platform_length/2+explode*0.5) {
			yrot(90) arrow(size=explode/3);
		}
	}
}
//!z_sled_bottom_end_assembly(explode=100, arrows=true);


module z_sled_assembly(explode=0, arrows=false)
{
	up((platform_length/2+explode/2)) {
		z_sled_top_end_assembly() {
			children();
		}
	}
	down((platform_length/2+explode/2)) {
		z_sled_bottom_end_assembly();
	}

	// Construction arrows.
	if(arrows && explode>20) {
		zrot(-90) xring() {
			down(explode/6) {
				yrot(90) arrow(size=explode/3);
			}
		}
	}
}
//!z_sled_assembly(explode=0, arrows=true);


module motor_assembly(explode=0, arrows=false)
{
	nema17_stepper(h=motor_length, shaft_len=motor_shaft_length);
	up(gear_base+rack_height/2+2.1+explode) {
		drive_gear();
	}

	// Construction arrow.
	if(arrows && explode>10) {
		up(explode*0.6) {
			yrot(-90) arrow(size=explode/3);
		}
	}
}
//!motor_assembly(explode=100, arrows=true);


module microswitch()
{
	color([0.3, 0.3, 0.3]) {
		difference() {
			cube([endstop_thick, endstop_length, endstop_depth], center=true);
			xrot(-5) {
				up(endstop_depth) {
					cube([endstop_thick+1, endstop_length, endstop_depth], center=true);
				}
			}
			down(endstop_hole_inset/2-endstop_click_voff/2) {
				yspread(endstop_hole_spacing) {
					yrot(90) cylinder(h=endstop_thick+1, d=endstop_screw_size, center=true, $fn=12);
				}
			}
		}
	}
	up(endstop_depth/2) {
		color([0.3, 0.3, 0.3]) {
			yrot(90) cylinder(h=endstop_thick*0.75, d=1, center=true, $fn=12);
		}
		color("silver") {
			fwd(endstop_length*0.9/2) xrot(5) back(endstop_length*0.9/2) {
				cube([endstop_thick, endstop_length*0.9, 0.1], center=true);
				back(endstop_length*0.9/2+1) {
					top_half() {
						yrot(90) {
							difference() {
								cylinder(h=endstop_thick, r=1, center=true, $fn=12);
								cylinder(h=endstop_thick+1, r=0.8, center=true, $fn=12);
							}
						}
					}
				}
			}
			grid_of(ya=[-endstop_length/2+2, -endstop_length/8, endstop_length/2-2]) {
				down(endstop_depth+5/2) {
					cube([endstop_thick*0.5, 0.2, 5], center=true);
				}
			}
		}
	}
}
//!microswitch();


module motor_mount_assembly(explode=0, arrows=false)
{
	motor_mount_plate();
	up(motor_length/2+2-endstop_depth/2) {
		fwd(endstop_hole_hoff) {
			right((motor_mount_spacing+joiner_width)/2+endstop_standoff+endstop_thick/2+explode) {
				microswitch();
			}
		}
	}

	// Construction arrow.
	if(arrows && explode>10) {
		up(motor_length/2+2-endstop_depth/2) {
			fwd(endstop_hole_hoff) {
				right((motor_mount_spacing+joiner_width)/2+endstop_standoff+endstop_thick/2+explode/2) {
					xrot(-90) arrow(size=explode/3);
				}
			}
		}
	}
}
//!motor_mount_assembly(explode=100, arrows=true);


module motor_segment_assembly(explode=0, arrows=false)
{
	motor_width = nema_motor_width(17)+printer_slop*2;

	rail_motor_segment();

	// Stepper Motor
	up(motor_top_z) {
		up(explode*2.2-motor_length/2) {
			motor_mount_assembly();
		}
		up(explode*1.1) {
			motor_assembly();
		}
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(rail_height+groove_height+explode/8) {
			yrot(-90) arrow(size=explode/3);
			up(motor_length+explode) {
				yrot(-90) arrow(size=explode/3);
			}
		}
	}
}
//!motor_segment_assembly(explode=100, arrows=true);
//!motor_segment_assembly();


module x_axis_slider_assembly(slidepos=0, explode=0, arrows=false)
{
	platform_vert_off = rail_height+groove_height/2;

	zrot(90) motor_segment_assembly();
	zring(r=(motor_rail_length+rail_length+2*explode)/2, n=2) {
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

	motor_segment_assembly();
	zrot(90) {
		zring(r=(motor_rail_length+rail_length+2*explode)/2, n=2) {
			zrot(90) rail_segment();
		}
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


module z_tower_assembly(slidepos=0, hide_endcaps=false, explode=0, arrows=false)
{
	left(platform_length) {
		zrot(-90) yz_joiner();
		left(6+explode) {
			if ($children > 2) children(2);
		}
		right(platform_length/3) {
			zrot_copies([0,180]) {
				back(rail_width/2+14+explode) {
					zrot(0) support_leg();
				}
			}
		}
		up(rail_height+groove_height+rail_length/2+explode) {
			yrot(90) zrot(90) rail_segment();

			up(motor_rail_length/2+rail_length/2+explode*1) {
				yrot(90) zrot(90) motor_segment_assembly(slidepos=slidepos);
				up(slidepos) {
					right(rail_height+groove_height/2) {
						if ($children > 0) children(0);
					}
				}
				up(motor_rail_length/2+rail_length/2+explode*1) {
					yrot(90) zrot(-90) rail_segment();
					up(rail_length/2+explode*1.5) {
						if (hide_endcaps == false) {
							if ($children > 1) children(1);
						}
					}
				}
			}
		}

		// Construction arrows.
		if (arrows && explode>10) {
			back(rail_height/2+groove_height/2) {
				up(rail_height+groove_height+explode*0.55) {
					yrot(-90) arrow(size=explode/3);
					up(motor_rail_length+explode*1.5) {
						yrot(-90) arrow(size=explode/3);
						up(rail_length+explode*0.5) {
							yrot(-90) arrow(size=explode/3);
						}
					}
				}
				up(rail_height/2+groove_height/2) {
					zring(r=rail_width/2+explode*0.55) {
						arrow(size=explode/3);
					}
				}
			}
		}
	}
}
//!z_tower_assembly(slidepos=0, explode=0, arrows=true) z_sled_assembly();
//!z_tower_assembly(explode=100, arrows=true);


module extruder_assembly(explode=0, arrows=false)
{
	motor_width = nema_motor_width(17);

	jhead_platform();
	down(explode) jhead_hotend();
	fwd(explode) {
		up(jhead_groove_thick+jhead_shelf_thick+motor_width/2+explode*1.5) {
			right(extruder_drive_diam/2-0.5) {
				fwd(extruder_shaft_len/2-0.05) {
					xrot(-90) {
						nema17_stepper(h=motor_length, shaft_len=motor_shaft_length);
						up(4+explode) extruder_drive_gear();
						fwd(explode) {
							down(motor_length/2) {
								xrot(90) extruder_motor_clip();
							}
						}
					}
				}
			}
			zrot(90) {
				up(explode*3) {
					extruder_idler();
					up(0.1) fwd(0.1+explode) extruder_latch();
					back(extruder_idler_diam/2) {
						fwd(explode/2)
							idler_bearing();
						left(extruder_shaft_len/2/2+1+explode/2)
							yrot(90) extruder_idler_axle();
						right(extruder_shaft_len/2/2+1+explode/2)
							yrot(-90) extruder_idler_axle_cap();
					}
				}
			}
		}
	}
	back(extruder_length/4+explode) {
		up(jhead_groove_thick+0.05+explode*2) {
			zrot(90) extruder_fan_shroud() {
				cooling_fan_shroud() {
					extruder_fan();
				}
			}
			up(jhead_shelf_thick+explode) {
				extruder_fan();
				up(12-extruder_fan_thick+2+0.05+explode) {
					extruder_fan_clip();
				}
			}
		}
	}
}
//!extruder_assembly(explode=100, arrows=true);


module extruder_bridge_assembly(explode=0, arrows=false)
{
	down(rail_height/2) {
		back(extruder_length/2+rail_length+2*explode) {
			extruder_assembly();
			zrot(90) zring(r=(extruder_length+rail_length+2*explode)/2, n=2) {
				zrot(-90) rail_segment();
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
}
//!extruder_bridge_assembly(explode=100, arrows=true);
//!extruder_bridge_assembly();


module spool_holder_assembly(explode=0, arrows=false)
{
	right(rail_height/2) {
		spool_holder();
		up(spool_holder_length-15/2*cos(30)+0.25+explode) {
			spool_axle();
			down(52.5/2-14) spool();
		}
	}
}


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
			z_sled_assembly(explode=explode, arrows=arrows) {
				extruder_bridge_assembly(explode=explode, arrows=arrows);
			}
			zrot(-90) xrot(-90) rail_endcap();
			zrot(-90) ramps_mount();
		}
		zrot(180) z_tower_assembly(slidepos=zpos, hide_endcaps=hide_endcaps, explode=explode, arrows=arrows) {
			z_sled_assembly(explode=explode, arrows=arrows);
			spool_holder_assembly(explode=explode, arrows=arrows);
		}
		x_sled_assembly(explode=explode, arrows=arrows) {
			y_axis_slider_assembly(slidepos=ypos, hide_endcaps=hide_endcaps, explode=explode, arrows=arrows) {
				y_sled_assembly(explode=explode, arrows=arrows) {
					build_platform();
				}
			}
		}
	}

	//cable_chain_xy_joiner_mount();
}


full_assembly(hide_endcaps=false);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
