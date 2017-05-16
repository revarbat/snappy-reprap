$do_prerender=true;

include <config.scad>
include <GDMUtils.scad>
use <NEMA.scad>
use <wiring.scad>
use <acme_screw.scad>
use <vitamins.scad>

use <adjustment_screw_parts.scad>
use <bridge_segment_parts.scad>
use <cable_chain_link_parts.scad>
use <cable_chain_mount_parts.scad>
use <compression_screw_parts.scad>
use <cooling_fan_shroud_parts.scad>
use <drive_gear_parts.scad>
use <extruder_fan_clip_parts.scad>
use <extruder_fan_shroud_parts.scad>
use <extruder_idler_parts.scad>
use <extruder_motor_clip_parts.scad>
use <jhead_platform_parts.scad>
use <lifter_screw_parts.scad>
use <glass_bed_support_parts.scad>
use <rail_segment_parts.scad>
use <rail_xy_motor_segment_parts.scad>
use <rail_y_endcap_parts.scad>
use <rail_z_endcap_parts.scad>
use <ramps_mount_parts.scad>
use <sled_endcap_parts.scad>
use <spool_holder_parts.scad>
use <support_leg_parts.scad>
use <wire_clip_parts.scad>
use <xy_joiner_parts.scad>
use <xy_sled_parts.scad>
use <yz_joiner_parts.scad>
use <z_base_parts.scad>
use <z_rail_parts.scad>
use <z_sled_parts.scad>


hide_endcaps = false;


module xy_motor_assembly(explode=0, arrows=false)
{
	// view: [30, 25, 30] [55, 0, 25] 475
	// desc: Press-fit a drive gear onto the shaft of a stepper motor, making sure to align the flat of the shaft with the flat of the shaft hole. Repeat this with the other drive gear and another stepper.  Lubricate the drive gear teeth with mineral oil.
	nema17_stepper(h=motor_length, shaft_len=motor_shaft_length, $fa=1, $fs=0.5);
	up(1+2.1+explode) {
		drive_gear();
	}

	// Construction arrow.
	if(arrows && explode>10) {
		up(explode*0.6) {
			yrot(-90) arrow(size=explode/3);
		}
	}
}
//!xy_motor_assembly(explode=100, arrows=true);
//!xy_motor_assembly();



module y_motor_segment_assembly_1(explode=0, arrows=false)
{
	// view: [0, 0, 87] [62, 0, 191] 900
	// desc: Seat the stepper motor with drive gear in the X/Y motor rail segment, with the wiring facing towards the left.  Route the wiring out the front left wiring access hole.
	motor_width = nema_motor_width(17)+printer_slop*2;

	rail_xy_motor_segment();

	// Stepper Motor
	up(motor_top_z) {
		up(explode*1.1) {
			zrot(-90) xy_motor_assembly();
			down(motor_length-3) {
				wiring([
					[0, 0, 0],
					[-rail_width/2+joiner_width+5, 0, 0],
					[-rail_width/2+joiner_width+5, -motor_rail_length/3.5-2, 5],
					[-rail_width/1.5, -motor_rail_length/3.5-2, 5],
					[-rail_width/1.5-10, -motor_rail_length/2-25, 0],
					[-rail_width/1.5-30, -motor_rail_length/2-25, 0],
				], 4, wirenum=2);
			}
		}
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(rail_height+groove_height+explode/8) {
			yrot(-90) arrow(size=explode/3);
		}
	}
}
//!y_motor_segment_assembly_1(explode=100, arrows=true);
//!y_motor_segment_assembly_1();


module y_motor_segment_assembly_2(explode=0, arrows=false)
{
	// view: [-20, -110, 30] [43, 0, 22] 1100
	// desc: Insert the limit microswitch in the left-side limit switch clip in the X/Y motor rail segment. Orient the switch with the arm leaning outwards on top. Route the wiring through the back of the limit switch clip, and out the same front-left wiring access hole as the motor wires.
	motor_width = nema_motor_width(17)+printer_slop*2;

	y_motor_segment_assembly_1();

	// Limit switch
	sw_x = motor_width/2+7+endstop_thick/2;
	sw_y = drive_gear_diam/2+1-endstop_depth/2;
	sw_z = motor_top_z+endstop_length/2-5;
	fwd(explode*2+sw_y) {
		up(sw_z) left(sw_x) xrot(90) microswitch();
		wiring([
			[-sw_x, 10, sw_z+8],
			[-sw_x, 19, sw_z+8],
			[-sw_x-2, 19, sw_z-8],
			[-rail_width/2+joiner_width+3, 20, 4],
			[-rail_width/2+joiner_width+3, -motor_rail_length/3.5+9, 9],
			[-rail_width/1.5, -motor_rail_length/3.5+9, 9],
			[-rail_width/1.5-8, -motor_rail_length/2-14, 4.5],
			[-rail_width/1.5-30, -motor_rail_length/2-14, 4.5],
		], 1);
		wiring([
			[-sw_x, 10, sw_z-8],
			[-sw_x, 19, sw_z-8],
			[-rail_width/2+joiner_width+5, 20, 4],
			[-rail_width/2+joiner_width+5, -motor_rail_length/3.5+7, 9],
			[-rail_width/1.5+2, -motor_rail_length/3.5+7, 9],
			[-rail_width/1.5-7, -motor_rail_length/2-16, 4.5],
			[-rail_width/1.5-30, -motor_rail_length/2-16, 4.5],
		], 1, wirenum=1);
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(sw_z) {
			left(sw_x) {
				fwd(explode*1.3) {
					zrot(-90) arrow(size=explode/3);
				}
			}
		}
	}
}
//!y_motor_segment_assembly_2(explode=100, arrows=true);
//!y_motor_segment_assembly_2();


module y_axis_assembly_1(slidepos=0, explode=0, arrows=false)
{
	// view: [0, 0, 0] [45, 0, 310] 1800
	// desc: Join a rail segment to each end of another motor rail assembly.  Apply mineral oil to the slider rail V-grooves for lubrication.
	platform_vert_off = rail_height+groove_height/2;

	y_motor_segment_assembly_2();
	zrot(90) {
		zring(r=(motor_rail_length+rail_length+2*explode)/2, n=2) {
			zrot(90) rail_segment();
		}
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(rail_height/2+groove_height/2) {
			zrot(90) zring(r=(motor_rail_length+explode)/2) {
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
//!y_axis_assembly_1(explode=100, arrows=true);
//!y_axis_assembly_1(slidepos=90);


module y_axis_assembly_2(explode=0, arrows=false)
{
	// view: [0, 75, 25] [55, 0, 140] 1800
	// desc: Join opposing glass bed supports to either side of both Y sled endcaps. Screw an adjustment screws into each of the supports, leaving them loose for now.
	sled_endcap();
	fwd(20-joiner_width/2) {
		right(platform_width/2+explode*1.5) {
			zrot(90) glass_bed_support2();
			right(glass_width/2-platform_width/2-adjust_screw_diam/2-1) {
				up(explode*1.0+10+7) xrot(180) adjustment_screw();
			}
		}
		left(platform_width/2+explode*1.5) {
			zrot(-90) glass_bed_support1();
			left(glass_width/2-platform_width/2-adjust_screw_diam/2-1) {
				up(explode*1.0+10+7) xrot(180) adjustment_screw();
			}
		}
	}

	// Construction arrows.
	if(arrows && explode>20) {
		fwd(20-joiner_width/2) {
			zring(r=(platform_width+explode*1.5)/2) {
				arrow(size=explode/3);
			}
			up(explode/2) {
				xspread(glass_width-adjust_screw_diam-2*1+explode*3) {
					yrot(-90) arrow(size=explode/3);
				}
			}
		}
	}
}
//!y_axis_assembly_2(explode=100, arrows=true);
//!y_axis_assembly_2(explode=0);


module y_axis_assembly_3(explode=0, arrows=false)
{
	// view: [-40, 10, 40] [55, 0, 230] 1400
	// desc: Join two XY sled parts together. Make sure the bottom racks line up.  Lubricate the slider pinchers and gear rack teeth on the underside of the sled with mineral oil.
	up(groove_height/2+rail_offset) {
		yspread(platform_length+0.5+explode) {
			yrot(180) xy_sled();
		}
		children();
	}

	// Construction arrows.
	if(arrows && explode>20) {
		zrot(-90) arrow(size=explode/3);
	}
}
//!y_axis_assembly_3(explode=100, arrows=true);
//!y_axis_assembly_3();


module y_axis_assembly_4(explode=0, arrows=false)
{
	// view: [0, -60, 0] [40, 0, 230] 1500
	// desc: Join a Y sled endcap assembly to one end of the Y sled central assembly.
	up(groove_height/2+rail_offset) {
		fwd(platform_length+0.5+explode) {
			y_axis_assembly_2();
		}
	}
	y_axis_assembly_3() children();

	// Construction arrows.
	if(arrows && explode>20) {
		fwd(platform_length+explode*0.5) {
			zrot(-90) arrow(size=explode/3);
		}
	}
}
//!y_axis_assembly_4(explode=100, arrows=true);
//!y_axis_assembly_4();


module y_axis_assembly_5(slidepos=0, explode=0, arrows=false)
{
	// view: [0, 0, 0] [55, 0, 310] 2200
	// desc: Slide the Y sled partial assembly onto the Y axis rails assembly, so that it is centered.  The gear rack should slide between the limit switch on the left, and the drive gear.  Adjust the drive gear if necessary, so that it aligns exactly with the herringbone rack.
	y_axis_assembly_1(slidepos=slidepos) {
		back(explode*4) {
			if ($children>1) children(0);
			zrot(180) y_axis_assembly_4() {
				if ($children>1) children(1);
			}

			// Construction arrows.
			if(arrows && explode>75) {
				fwd(platform_length+explode/2) {
					zrot(90) arrow(size=explode/3);
				}
			}
		}
	}
}
//!y_axis_assembly_5(slidepos=0, explode=100, arrows=true);
//!y_axis_assembly_5();


module y_axis_assembly_6(slidepos=0, explode=0, arrows=false)
{
	// view: [0, 0, 0] [55, 0, 310] 2200
	// desc: Join the other Y sled endcap assembly to the end of the Y sled partial assembly.
	y_axis_assembly_5(slidepos=slidepos) {
		fwd(platform_length+0.5+explode*3) {
			up(groove_height/2+rail_offset) {
				y_axis_assembly_2();
			}

			// Construction arrows.
			if(arrows && explode>75) {
				back(explode) {
					zrot(-90) arrow(size=explode/3);
				}
			}
		}
		up(0) children();
	}
}
//!y_axis_assembly_6(slidepos=0, explode=100, arrows=true);
//!y_axis_assembly_6();


module y_axis_assembly_7(slidepos=0, explode=0, arrows=false)
{
	// view: [0, 0, 0] [55, 0, 310] 2200
	// desc: Optionally join a rail endcap to each end of the Y axis.
	platform_vert_off = rail_height+groove_height/2;

	zrot(90) zring(r=(motor_rail_length+2*rail_length+3*explode)/2) {
		if (hide_endcaps == false) {
			zrot(90) rail_y_endcap();
		}
	}
	y_axis_assembly_6(slidepos=slidepos) {
		children();
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(rail_height/2+groove_height/2) {
			zrot(90) zring(r=(motor_rail_length+2*rail_length+1.5*explode)/2) {
				arrow(size=explode/3);
			}
		}
	}
}
//!y_axis_assembly_7(explode=100, arrows=true);
//!y_axis_assembly_7();


module x_motor_segment_assembly_1(explode=0, arrows=false)
{
	// view: [0, 0, 87] [62, 0, 11] 900
	// desc: Seat the stepper motor with drive gear in the X/Y motor rail segment, with the wiring facing towards the left.  Route the wiring out the front left wiring access hole.
	motor_width = nema_motor_width(17)+printer_slop*2;

	rail_xy_motor_segment();

	// Stepper Motor
	up(motor_top_z) {
		up(explode*1.1) {
			zrot(-90) xy_motor_assembly();
			down(motor_length-3) {
				wiring([
					[0, 0, 0],
					[-rail_width/2+joiner_width+20, 0, 0],
					[-rail_width/2+joiner_width+20, -motor_rail_length/3.5-4, 5],
					[0, -motor_rail_length/3.5-4, 5],
					[0, -motor_rail_length/2-20, 5],
				], 4, wirenum=2);
			}
		}
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(rail_height+groove_height+explode/8) {
			yrot(-90) arrow(size=explode/3);
		}
	}
}
//!x_motor_segment_assembly_1(explode=100, arrows=true);
//!x_motor_segment_assembly_1();


module x_motor_segment_assembly_2(explode=0, arrows=false)
{
	// view: [-20, -110, 30] [43, 0, 22] 1100
	// desc: Insert the limit microswitch in the left-side limit switch clip in the X/Y motor rail segment. Route the wiring through the back of the limit switch clip, and out the same front-left wiring access hole as the motor wires.
	motor_width = nema_motor_width(17)+printer_slop*2;

	x_motor_segment_assembly_1();

	// Limit switch
	sw_x = motor_width/2+7+endstop_thick/2;
	sw_y = drive_gear_diam/2+1-endstop_depth/2;
	sw_z = motor_top_z+endstop_length/2-5;
	fwd(explode*2+sw_y) {
		up(sw_z) left(sw_x) xrot(90) microswitch();
		wiring([
			[-sw_x, 10, sw_z-8],
			[-sw_x-1, 18, sw_z-8],
			[-sw_x-1, 19, 10],
			[-sw_x-1, -motor_rail_length/3.5-5+sw_y, 10],
			[1, -motor_rail_length/3.5-5+sw_y, 10],
			[1, -motor_rail_length/2-20+sw_y, 10],
		], 1);
		wiring([
			[-sw_x, 10, sw_z+8],
			[-sw_x-3, 18, sw_z+8],
			[-sw_x-3, 19, 10],
			[-sw_x-3, -motor_rail_length/3.5-5+sw_y-2, 10],
			[-1, -motor_rail_length/3.5-5+sw_y-2, 10],
			[-1, -motor_rail_length/2-20+sw_y, 10],
		], 1, wirenum=1);
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(sw_z) {
			left(sw_x) {
				fwd(explode*1.3) {
					zrot(-90) arrow(size=explode/3);
				}
			}
		}
	}
}
//!x_motor_segment_assembly_2(explode=100, arrows=true);
//!x_motor_segment_assembly_2();


module x_axis_assembly_1(slidepos=0, explode=0, arrows=false)
{
	// view: [-5, 65, 85] [50, 0,  310] 1750
	// desc: Join a rail segment to each end of a motor rail assembly, to make the X axis slider. Route the wiring to one end of the slider assembly.  Apply mineral oil to the slider rail V-grooves for lubrication.
	platform_vert_off = rail_height+groove_height/2;

	zrot(-90) x_motor_segment_assembly_2();
	zring(r=(motor_rail_length+rail_length+2*explode)/2, n=2) {
		zrot(90) rail_segment();
	}

	up(12) {
		wiring([
			[-motor_rail_length/2, 0, 0],
			[-(rail_length+explode), 0, 0],
			[-(rail_length+explode+motor_rail_length/2)-30, 0, 0],
		], 6);
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
//!x_axis_assembly_1(slidepos=100, explode=100, arrows=true);
//!x_axis_assembly_1(slidepos=0) {sphere(1); sphere(1); sphere(1);}


module x_axis_assembly_2(explode=0, arrows=false)
{
	// view: [0, 0, 0] [50, 0, 310] 1000
	// desc: Join two XY sled parts together. Make sure the bottom racks line up.  Lubricate the slider pinchers and gear rack teeth on the underside of the sled with mineral oil.
	up(groove_height/2+rail_offset) {
		xspread(platform_length+explode) {
			zrot(90) yrot(180) xy_sled();
		}
	}

	// Construction arrows.
	if(arrows && explode>20) {
		arrow(size=explode/3);
	}
}
//!x_axis_assembly_2(explode=100, arrows=true);


module x_axis_assembly_3(explode=0, arrows=false)
{
	// view: [-55, 60, 65] [55, 0, 55] 1500
	// desc: Join the X sled cable-chain mount to the front/left side of the X sled endstop.
	up(groove_height/2+rail_offset) {
		left(explode/2) {
			zrot(-90) xy_joiner();
			right(explode*1.25+0.3) {
				fwd((platform_width-joiner_width)/2) {
					zrot(90) {
						//cable_chain_xy_joiner_mount();
						cable_chain_x_sled_mount();
					}
				}
			}
		}
	}

	// Construction arrows.
	if(arrows && explode>20) {
		up(groove_height/2+rail_offset+rail_height/4) {
			fwd(platform_width/2-joiner_width/2) {
				right(explode/3) {
					arrow(size=explode/3);
				}
			}
		}
	}
}
//!x_axis_assembly_3(explode=100, arrows=true);
//!x_axis_assembly_3();


module x_axis_assembly_4(explode=0, arrows=false)
{
	// view: [-55, 60, 65] [55, 0, 55] 1500
	// desc: Join an X-Y joiner endcap to one end of the X sled central assembly.
	x_axis_assembly_2();
	left(platform_length+0.3+explode) {
		x_axis_assembly_3();
	}

	// Construction arrows.
	if(arrows && explode>20) {
		left(platform_length+explode*0.6) {
			zrot(180) arrow(size=explode/3);
		}
	}
}
//!x_axis_assembly_4(explode=100, arrows=true);
//!x_axis_assembly_4();


module x_axis_assembly_5(slidepos=0, explode=0, arrows=false)
{
	// view: [-155, -50, 25] [50, 0, 310] 2500
	// desc: Slide the X sled partial assembly onto the X axis rails assembly, so that it is centered.
	x_axis_assembly_1(slidepos=slidepos) {
		if ($children>0) children(0); else nil();
		if ($children>1) children(1); else nil();
		left(explode*5) {
			x_axis_assembly_4();
			if ($children>2) children(2); else nil();

			// Construction arrows.
			if(arrows && explode>75) {
				right(platform_length+explode) {
					zrot(180) arrow(size=explode/3);
				}
			}
		}
	}
}
//!x_axis_assembly_5(slidepos=0, explode=100, arrows=true);
//!x_axis_assembly_5();


module x_axis_assembly_6(xslidepos=0, yslidepos=0, explode=0, arrows=false)
{
	// view: [150, 0, 110] [50, 0, 310] 2500
	// desc: Connect the Y axis assembly to the XY joiner on the X axis partial assembly. Route the Y axis wiring through the front hole in the XY joiner.
	x_axis_assembly_5(slidepos=xslidepos) {
		if ($children>0) children(0); else nil();
		if ($children>1) children(1); else nil();
		right(explode*4) {
			if ($children>2) children(2); else nil();
			up(groove_height/2+rail_offset) {
				y_axis_assembly_7(slidepos=yslidepos) {
					if ($children>3) children(3);
				}
			}

			// Construction arrows.
			if(arrows && explode>75) {
				left(explode*1.25) {
					arrow(size=2*explode/3);
				}
			}
		}
	}
}
//!x_axis_assembly_6(explode=100, arrows=true);
//!x_axis_assembly_6();


module x_axis_assembly_7(xslidepos=0, yslidepos=0, explode=0, arrows=false)
{
	// view: [85, 70, 40] [50, 0, 15] 2500
	// desc: Join the other X sled endcap assembly to the end of the X sled assembly, fixing the Y sled assembly in place.
	x_axis_assembly_6(xslidepos=xslidepos, yslidepos=yslidepos) {
		if ($children>0) children(0); else nil();
		if ($children>1) children(1); else nil();
		right(platform_length+0.5+explode*3) {
			up(groove_height/2+rail_offset) {
				zrot(90) xy_joiner();
			}

			// Construction arrows.
			if(arrows && explode>75) {
				left(explode*1.25) {
					arrow(size=explode/3);
				}
			}
		}
		if ($children>2) children(2);
	}
}
//!x_axis_assembly_7(xslidepos=0, yslidepos=0, explode=100, arrows=true);
//!x_axis_assembly_7(xslidepos=platform_length*sin($t*360), yslidepos=0, explode=0, arrows=false);


module x_axis_assembly_8(xslidepos=0, yslidepos=0, explode=0, arrows=false)
{
	// view: [-10, 0, 75] [55, 0, 310] 1100
	// desc: Attach the cable chain joiner mount to the X motor segment, on the same side as the X sled cable chain joiner and Y axis wiring.
	x_axis_assembly_7(xslidepos=xslidepos, yslidepos=yslidepos) {
		if ($children>0) children(0); else nil();
		if ($children>1) children(1); else nil();
		if ($children>2) children(2);
	}
	fwd(rail_width/2+2+explode/2) {
		left(side_mount_spacing/2) {
			// Construction arrows.
			if(arrows && explode>75) {
				up(rail_height/2/2) {
					zrot(-90) arrow(size=explode/3);
				}
			}
			fwd(explode/2) {
				zrot(90) cable_chain_joiner_mount();
			}
		}
	}
}
//!x_axis_assembly_8(xslidepos=0, yslidepos=0, explode=100, arrows=true);
//!x_axis_assembly_8(xslidepos=platform_length*sin($t*360), yslidepos=0, explode=0, arrows=false);


module x_axis_assembly_9(xslidepos=0, yslidepos=0, explode=0, arrows=false)
{
	// view: [-12, 0, 75] [62, 0, 345] 1400
	// desc: Attach the cable-chain assembly (with 13 or 14 links) to the cable chain mounts on the X axis assembly, making sure to feed the Y-axis wiring through the cable chain.  Route the wiring in through the wiring access hole beside the cable chain mount, then out through the end of the X axis assembly.  You may need to lubricate each cable-chain pivot with mineral oil.
	x_axis_assembly_8(xslidepos=xslidepos, yslidepos=yslidepos) {
		if ($children>0) children(0); else nil();
		if ($children>1) children(1); else nil();
		if ($children>2) children(2);
	}
	vert_off = rail_height + groove_height + rail_offset + cable_chain_height/2;
	left(explode*1.5) {
		fwd(platform_width/2+cable_chain_width/2+2) {
			fwd(15) {
				// Construction arrows.
				if(arrows && explode>75) {
					left(platform_length+explode/6) {
						up(vert_off) zrot(180) arrow(size=explode/3);
					}
					left(side_mount_spacing/2+explode/6) {
						up(cable_chain_height/2) zrot(180) arrow(size=explode/3);
					}
				}
			}
			left(explode/2) {
				cable_chain_assembly(
					[-platform_length-1, 0, vert_off],
					[-side_mount_spacing/2-cable_chain_length/2+cable_chain_height/3, 0, cable_chain_height/2],
					[-1,0,0],
					platform_length*2,
					xslidepos,
					wires=6
				);
			}
		}
	}
	if (explode>0) {
		fwd(platform_width/2+cable_chain_width/2+2) {
			wiring([
				[-platform_length-1-explode*2, 0, vert_off],
				[-platform_length-1-explode, 0, vert_off],
				[-platform_length-1, 0, vert_off],
			], 6);
			wiring([
				[-side_mount_spacing/2-cable_chain_length/2+cable_chain_height/3-explode*2, 0, cable_chain_height/2],
				[-side_mount_spacing/2-cable_chain_length/2+cable_chain_height/3-explode, 0, cable_chain_height/2],
				[-side_mount_spacing/2-cable_chain_length/2+cable_chain_height/3, 0, cable_chain_height/2],
			], 6);
		}
	}
	wiring([
		[-side_mount_spacing/2-cable_chain_length/2+cable_chain_height/3, -(platform_width/2+cable_chain_width/2+2), cable_chain_height/2],
		[-motor_rail_length/3+10, -(platform_width/2+cable_chain_width/2+2), cable_chain_height/2],
		[-motor_rail_length/3+5, -(rail_width/2+joiner_width/2), rail_thick+5],
		[-motor_rail_length/3+5, -rail_width/3, rail_thick+5],
		[-rail_length-motor_rail_length/2-30, -rail_width/3, rail_thick+5],
	], 6);
}
//!x_axis_assembly_9(xslidepos=0, yslidepos=0, explode=100, arrows=true);
//!x_axis_assembly_9(xslidepos=platform_length*sin($t*360), yslidepos=0, explode=0, arrows=false);
//!x_axis_assembly_9(xslidepos=0, yslidepos=0, explode=0, arrows=false);


module z_tower_assembly_1(slidepos=0, explode=0, arrows=false)
{
	// view: [110, -40, 60] [65, 0, 40] 1900
	// desc: Attach two Z rail segments together to make a Z tower rail assembly.  Do this again to make a second tower. Superglue these together if they aren't attached firmly.  Lubricate the slider rails and lifter screw slots with mineral oil.
	zspread(rail_length + explode) {
		yrot(90) zrot(90) z_rail();
	}
	if ($children > 0) {
		up(slidepos) {
			right(rail_height+groove_height/2) {
				children(0);
			}
		}
	}
	up(rail_length+2*explode) {
		if (hide_endcaps == false) {
			if ($children > 1) {
				children(1);
			}
		}
	}

	// Construction arrows.
	if (arrows && explode>50) {
		right(rail_height/2+groove_height/2) {
			yrot(-90) arrow(size=explode/3);
		}
	}
}
//!z_tower_assembly_1(explode=100, arrows=true);
//!z_tower_assembly_1() { z_sled(); rail_z_endcap(); }
//!z_tower_assembly_1();


// Child 0: Left Z tower motherboard mount point.
module z_tower_assembly_2(explode=0, arrows=false)
{
	// view: [-110, 20, 80] [55, 0, 60] 1400
	// desc: Attach support legs to each side of a YZ Joiner part.  Do this again for a second YZ Joiner part.
	zrot(-90) yz_joiner();
	left(6+explode) {
		if ($children > 0) zrot(-90) children(0);
	}
	right(platform_length/3) {
		zrot_copies([0,180]) {
			back(rail_width/2+14+explode) {
				zrot(0) support_leg();
			}
		}
	}

	// Construction arrows.
	if (arrows && explode>10) {
		right(10+platform_length/2/2) {
			up(rail_height/2+groove_height/2) {
				zrot(90) zring(r=rail_width/2+explode*0.55) {
					zrot(0) arrow(size=explode/3);
				}
			}
		}
	}
}
//!z_tower_assembly_2(explode=100, arrows=true);
//!z_tower_assembly_2();
//!z_tower_assembly_2() color("red") sphere(10);


// Child 0: Left Z tower motherboard mount point.
module z_tower_assembly_3(slidepos=0, explode=0, arrows=false)
{
	// view: [-55, 0, 285] [70, 0, 65] 1700
	// desc: Attach a Z base part to the top of each YZ joiner assembly, to make two tower base assemblies. Superglue these together if the attachment is wobbly in any way.
	left(platform_length) {
		z_tower_assembly_2() {
			if ($children > 0) children(0);
		}
		up(rail_height+groove_height+z_base_height/2+explode) {
			yrot(90) zrot(90) z_base();
		}

		// Construction arrows.
		if (arrows && explode>10) {
			right(rail_height/2+groove_height/2) {
				up(rail_height+groove_height+explode*0.5) {
					yrot(-90) arrow(size=explode/3);
				}
			}
		}
	}
}
//!z_tower_assembly_3(slidepos=0, explode=0, arrows=true) z_sled();
//!z_tower_assembly_3(explode=100, arrows=true);
//!z_tower_assembly_3();


// Child 0: Z sled
// Child 1: Left Z tower top endcap mount point.
// Child 2: Left Z tower motherboard mount point.
module z_tower_assembly_4(slidepos=0, explode=0, arrows=false)
{
	// view: [-55, 0, 255] [70, 0, 55] 1700
	// desc: Attach a Z tower rail assembly to the top of each tower base assembly.  Superglue these together if the attachment is wobbly in any way.
	z_tower_assembly_3() {
		if ($children > 2) children(2);
	}
	up(rail_height+groove_height+z_base_height+rail_length+explode) {
		left(platform_length) {
			z_tower_assembly_1(slidepos=slidepos) {
				if ($children > 0) children(0);
				if ($children > 1) children(1);
			}
		}
	}

	// Construction arrows.
	if (arrows && explode>10) {
		right(rail_height/2+groove_height/2) {
			up(rail_height+groove_height+z_base_height+explode*0.5) {
				left(platform_length) {
					yrot(-90) arrow(size=explode/3);
				}
			}
		}
	}
}
//!z_tower_assembly_4(slidepos=0, explode=0, arrows=true) z_sled();
//!z_tower_assembly_4(explode=100, arrows=true);
//!z_tower_assembly_4();


// Child 0: Z sled
// Child 1: Left Z tower top endcap mount point.
// Child 2: Left Z tower motherboard mount point.
module z_tower_assembly_5(slidepos=0, explode=0, arrows=false)
{
	// view: [-55, 0, 285] [70, 0, 65] 1700
	// desc: Attach a cable chain joiner mount to the front-size of the left Z tower, above the top hole of the bottom rail segment.
	z_tower_assembly_4(slidepos=slidepos) {
		if ($children > 0) children(0);
		if ($children > 1) children(1);
		if ($children > 2) children(2);
	}
	left(platform_length) {
		fwd(z_joiner_spacing/2+7+explode) {
			up(rail_height+groove_height+z_base_height+rail_length-11) {
				yrot(90) zrot(90) cable_chain_joiner_mount();
			}
		}
	}
	// Construction arrows.
	if (arrows && explode>10) {
		left(platform_length-rail_height/4) {
			fwd(z_joiner_spacing/2+7+explode*0.5) {
				up(rail_height+groove_height+z_base_height+rail_length-11) {
					zrot(-90) arrow(size=explode/3);
				}
			}
		}
	}
}
//!z_tower_assembly_5(explode=0, arrows=true) z_sled();
//!z_tower_assembly_5(explode=100, arrows=true);
//!z_tower_assembly_5();
//!z_tower_assembly_5() {z_sled(); nil(); sphere(10);}


module extruder_assembly_1(explode=0, arrows=false)
{
	// view: [0, -40, 0] [75, 0, 45] 1000
	// desc: Insert the 686 bearing into the extruder idler arm.
	extruder_idler();
	back(extruder_idler_diam/2-explode) {
		idler_bearing();
	}

	// Construction arrows.
	if (arrows && explode>50) {
		fwd(explode*0.5) {
			zrot(-90) arrow(size=0.5*explode/3);
		}
	}
}
//!extruder_assembly_1(explode=100, arrows=true);
//!extruder_assembly_1();


module extruder_assembly_2(explode=0, arrows=false)
{
	// view: [0, 15, 15] [75, 0, 30] 1000
	// desc: Insert the idler axle through the 686 bearing, and lock it into the extruder idler arm with the axle clip.
	extruder_assembly_1();
	left(printer_slop) {
		back(extruder_idler_diam/2) {
			left(extruder_shaft_len/2/2+1+explode*0.75) {
				xrot(90) yrot(90) extruder_idler_axle();
			}
			right(extruder_shaft_len/2/2+1/2+explode*0.75) {
				xrot(90) yrot(90) extruder_idler_axle_clip();
			}
		}
	}

	// Construction arrows.
	if (arrows && explode>50) {
		back(extruder_idler_diam/2) {
			right(explode*0.4) {
				arrow(size=0.5*explode/3);
			}
			left(explode*0.4) {
				zrot(180) arrow(size=0.5*explode/3);
			}
		}
	}
}
//!extruder_assembly_2(explode=100, arrows=true);
//!extruder_assembly_2();


module extruder_assembly_3(explode=0, arrows=false)
{
	// view: [40, 20, 10] [55, 0, 25] 700
	// desc: Attach the extruder drive gear onto the stepper motor shaft.
	xrot(180) yrot(90) zrot(-90) {
		nema17_stepper(h=motor_length, shaft_len=motor_shaft_length);
		wiring([
			[0.5, 0, -motor_length+3],
			[0, -25, -motor_length+3],
			[5, -20.01, -(motor_length+16)],
			[5, -20, -(motor_length+26)],
		], 4, fillet=3);
		up(4+explode) extruder_drive_gear();
	}

	// Construction arrows.
	if (arrows && explode>50) {
		right(explode*0.6) {
			arrow(size=0.5*explode/3);
		}
	}
}
//!extruder_assembly_3(explode=100, arrows=true);
//!extruder_assembly_3();


module extruder_assembly_4(explode=0, arrows=false)
{
	// view: [0, 0, 0] [50, 0, 80] 900
	// desc: Slide the JHead extruder hot end into the slot in the bottom of the JHead platform.  Route the wiring up through the wiring access slot, and along the back of the extruder platform.
	jhead_platform();
	down(explode) jhead_hotend();

	// Construction arrows.
	if (arrows && explode>50) {
		down(explode*0.25) {
			yrot(90) arrow(size=0.5*explode/3);
		}
	}
}
//!extruder_assembly_4(explode=100, arrows=true);
//!extruder_assembly_4();


module extruder_assembly_5(explode=0, arrows=false)
{
	// view: [10, 85, 230] [55, 0, 55] 1600
	// desc: Clip the extruder motor with drive gear to the jhead platform using the extruder motor clip.
	motor_width = nema_motor_width(17);

	extruder_assembly_4();
	up(jhead_groove_thick+jhead_shelf_thick+motor_width/2+explode*2) {
		fwd(extruder_drive_diam/2-0.5) {
			left(extruder_shaft_len/2-0.05) {
				extruder_assembly_3();
				left(motor_length/2) {
					up(explode*2) {
						zrot(-90) extruder_motor_clip();
					}
				}
			}
		}
	}

	// Construction arrows.
	if (arrows && explode>50) {
		up(jhead_groove_thick+jhead_shelf_thick+motor_width/2+explode) {
			fwd(extruder_drive_diam/2-0.5) {
				left(extruder_shaft_len/2-0.05+motor_length/2) {
					yrot(-90) arrow(size=explode/3);
					up(explode*2) {
						yrot(-90) arrow(size=explode/3);
					}
				}
			}
		}
	}
}
//!extruder_assembly_5(explode=100, arrows=true);
//!extruder_assembly_5();


module extruder_assembly_6(explode=0, arrows=false)
{
	// view: [70, 0, 60] [55, 0, 55] 1000
	// desc: Insert the idler arm into the idler hinge hole on the JHead platform.
	motor_width = nema_motor_width(17);

	extruder_assembly_5();
	up(jhead_groove_thick+jhead_shelf_thick+motor_width/2) {
		right(explode*2) {
			extruder_assembly_2();
		}
	}

	// Construction arrows.
	if (arrows && explode>50) {
		right(explode*1.25) {
			back(motor_width/2) {
				up(10) arrow(size=explode/3);
			}
		}
	}
}
//!extruder_assembly_6(explode=100, arrows=true);
//!extruder_assembly_6();


module extruder_assembly_7(explode=0, arrows=false)
{
	// view: [70, 0, 60] [55, 0, 55] 1000
	// desc: Insert the idler latch arm into the latch hinge hole on the JHead platform.
	motor_width = nema_motor_width(17);
	extruder_assembly_6();
	up(jhead_groove_thick+jhead_shelf_thick+motor_width/2) {
		back(30+20.1+explode*1.5) {
			xrot(90) compression_screw();
		}
	}

	// Construction arrows.
	if (arrows && explode>50) {
		back(explode*1.25) {
			fwd(motor_width/2) {
				up(jhead_groove_thick+jhead_shelf_thick+motor_width/2) {
					zrot(90) arrow(size=explode/3);
				}
			}
		}
	}
}
//!extruder_assembly_7(explode=100, arrows=true);
//!extruder_assembly_7();


module extruder_assembly_8(explode=0, arrows=false)
{
	// view: [90, 70, 95] [55, 0, 25] 1200
	// desc: Insert the extruder fan shroud into the JHead platform, latching the JHead hot end, and idler and latch arms into place.
	extruder_assembly_7();
	right(extruder_length/4) {
		up(jhead_groove_thick+0.05+explode*2) {
			extruder_fan_shroud() children();
		}
	}

	// Construction arrows.
	if (arrows && explode>50) {
		up(explode*1.25) {
			right(extruder_length/4) {
				yrot(-90) arrow(size=explode/3);
			}
		}
	}
}
//!extruder_assembly_8(explode=100, arrows=true);
//!extruder_assembly_8();


module extruder_assembly_9(explode=0, arrows=false)
{
	// view: [0, 0, 110] [55, 0, 10] 1200
	// desc: Clip a cooling fan to the top of the extruder fan shroud using the extruder fan clip.  Route the wiring along the back side of the extruder platform.  WARNING: This fan MUST be running any time the J-Head hotend is hot, or else the bottom of the mount will warp!  Either hook it up to a constant 12V supply, or make sure your firmware turns it on when the extruder is hot.
	extruder_assembly_8() {
		children();
	}
	right(extruder_length/4) {
		up(jhead_groove_thick+jhead_shelf_thick+0.05) {
			up(explode) {
				up(explode/2) {
					cooling_fan();
					translate([-(extruder_fan_size/2-5), 0, extruder_fan_thick/4]) {
						wiring([
							[0, extruder_fan_size/2, 0],
							[0, extruder_fan_size/2+10, 0],
							[-10, rail_width/3+5, 0],
							[-30, rail_width/3+5, 0],
							[-76, rail_width/3-5, 0],
							[-76, 0, 0],
							[-95, 0, 0],
						], 2, fillet=5, wirenum=4);
					}
					up(12-extruder_fan_thick+2+0.05+explode/2) {
						up(explode/2) {
							zrot(90) extruder_fan_clip();
						}

						// Construction arrows.
						if (arrows && explode>50) {
							yrot(-90) arrow(size=0.75*explode/3);
						}
					}
				}

				// Construction arrows.
				if (arrows && explode>50) {
					yrot(-90) arrow(size=0.75*explode/3);
				}
			}
		}
	}
}
//!extruder_assembly_9(explode=100, arrows=true);
//!extruder_assembly_9();


module extruder_assembly_10(explode=0, arrows=false)
{
	// view: [90, 70, 95] [55, 0, 25] 1200
	// desc: Attach a cooling fan to the cooling fan shroud.
	cooling_fan_shroud() {
		up(explode) {
			cooling_fan();
			translate([-(extruder_fan_size/2-5), 0, extruder_fan_thick/4]) {
				wiring([
					[0, extruder_fan_size/2, 0],
					[0, extruder_fan_size/2+10, 0],
					[-40, 27.01, 25],
					[-40, 27.01, 45],
					[-45, rail_width/3+5, 51],
					[-65, rail_width/3+5, 51],
					[-(extruder_length/2+47), rail_width/3-5, 60],
					[-(extruder_length/2+47), 0, 60],
					[-(extruder_length/2+62), 0, 60],
				], 2, fillet=5, wirenum=6);
			}
		}

		// Construction arrows.
		if (arrows && explode>50) {
			up(explode/2) yrot(-90) arrow(size=0.75*explode/3);
		}
	}
}
//!extruder_assembly_10(explode=100, arrows=true);
//!extruder_assembly_10();


module extruder_assembly_11(explode=0, arrows=false)
{
	// view: [32, -6, -50] [100, 0, 10] 1000
	// desc: Attach the cooling fan shroud assembly to the bottom of the extruder fan shroud.  Route the wiring up through the wiring access slot, and along the back side of the extruder platform.
	extruder_assembly_9() {
		down(explode) extruder_assembly_10();

		// Construction arrows.
		if (arrows && explode>50) {
			down(explode/2) {
				yrot(90) arrow(size=0.75*explode/3);
			}
		}
	}
}
//!extruder_assembly_11(explode=100, arrows=true);
//!extruder_assembly_11();


module bridge_assembly_1(explode=0, arrows=false)
{
	// view: [0, 70, 55] [55, 0, 25] 1850
	// desc: Attach bridge segments to either end of the extruder platform assembly.  Superglue these together if the attachments are in any way wobbly.  Route the wiring through the left side bridge segment, and out the front-left wiring access hole.
	extruder_assembly_11();
	zrot_copies([0,180]) {
		right((extruder_length+rail_length)/2+explode) {
			left(rail_length/2) up(rail_height/2) {
				yrot(bridge_arch_angle) {
					right(rail_length/2) down(rail_height/2) {
						zrot(90) bridge_segment();
					}
				}
			}
		}
	}
	up(rail_thick+4) {
		left(extruder_length/2+rail_length/2+explode) {
			arch_off = (rail_length-20)*sin(bridge_arch_angle);
			wiring([
				[rail_length/2+explode, 0, 0],
				[0, 0, -arch_off/2],
				[-(motor_rail_length/2-32), -z_joiner_spacing/3, -arch_off],
				[-(motor_rail_length/2-32), -(z_joiner_spacing/2+5), -arch_off],
			], 12);
		}
	}

	// Construction arrows.
	if(arrows && explode>10) {
		up(rail_height/2+groove_height/2) {
			zring(r=(extruder_length+explode)/2, n=2) {
				arrow(size=explode/3);
			}
		}
	}
}
//!bridge_assembly_1(explode=100, arrows=true);
//!bridge_assembly_1();


module bridge_assembly_2(explode=0, arrows=false)
{
	// view: [0, 0, 18] [55, 0, 25] 2100
	// desc: Attach a vertical cable-chain mount to the front left side of the extruder bridge.
	bridge_assembly_1();
	left(extruder_length/2) {
		up(rail_height/2) {
			yrot(-bridge_arch_angle) {
				down(rail_height/2) {
					left(rail_length-10) {
						fwd(z_joiner_spacing/2+7+explode) {
							fwd(explode) zrot(90) cable_chain_joiner_vertical_mount();

							// Construction arrows.
							if(arrows && explode>50) {
								up(rail_height/4) {
									zrot(-90) arrow(size=explode/3);
								}
							}
						}
					}
				}
			}
		}
	}
}
//!bridge_assembly_2(explode=100, arrows=true);
//!bridge_assembly_2();


module bridge_assembly_3(explode=0, arrows=false)
{
	// view: [0, 0, 18] [55, 0, 25] 2100
	// desc: Attach Z sled segments to either end of the extruder bridge assembly.  Superglue these on if the attachments are in any way wobbly.
	arch_offset = rail_length*sin(bridge_arch_angle);
	up(arch_offset) bridge_assembly_2();
	zring(r=(extruder_length+2*rail_length+2*cantilever_length+3*explode)/2, n=2) {
		zrot(180) z_sled();
	}

	// Construction arrows.
	if(arrows && explode>50) {
		up(rail_height/2+groove_height/2) {
			zring(r=(extruder_length+2*rail_length+2*cantilever_length+0.75*explode)/2, n=2) {
				arrow(size=explode/3);
			}
		}
	}
}
//!bridge_assembly_3(explode=100, arrows=true);
//!bridge_assembly_3();


module bridge_assembly_4(slidepos=0, explode=0, arrows=false)
{
	// view: [0, 0, 18] [55, 0, 25] 2100
	// desc: Press fit the lifter screw onto the stepper motor shaft, making sure the flatted side matches that on the lifter screw shaft hole.  (The hole on the lifter screw rim is aligned with the flatted side.)  Apply mineral oil to the screw threads for lubrication.
	nema17_stepper(h=motor_length, shaft_len=motor_shaft_length, $fa=1, $fs=0.5);
	up(explode+lifter_screw_thick+5.05) {
		zrot(-360*slidepos/lifter_screw_pitch-90) {
			yrot(180) lifter_screw();
		}
	}

	// Construction arrows.
	if(arrows && explode>50) {
		up(explode/2) {
			yrot(-90) arrow(size=explode/3);
		}
	}
}
//!bridge_assembly_4(slidepos=1, explode=100, arrows=true);
//!bridge_assembly_4();


module bridge_assembly_5(slidepos=0, explode=0, arrows=false)
{
	// view: [0, -15, -85] [45, 0, 180] 1800
	// desc: Insert the Z stepper motors into the motor mount cages on the Z-sleds at both ends of the bridge.  Route the wiring to the left-side front wiring access hole with the rest of the extruder wiring.
	motor_width = nema_motor_width(17)+printer_slop*2;
	arch_offset = rail_length*sin(bridge_arch_angle);
	bridge_assembly_3();
	down(explode*3-1) {
		zring(r=(extruder_length+2*rail_length+2*cantilever_length)/2, n=2) {
			xrot(180) zrot(-90) bridge_assembly_4(slidepos=slidepos);
		}

		motor_spread = extruder_length + 2*rail_length + 2*cantilever_length - motor_width;
		wiring([
			[-motor_spread/2, 0, motor_length-5],
			[-(motor_spread/2-5), 0, motor_length-5],
			[-(motor_spread/2-5), 0, rail_thick+5],
			[-(extruder_length/2+rail_length), 0, rail_thick+5],
			[-(extruder_length/2+rail_length-33), 0, rail_thick+5],
			[-(extruder_length/2+rail_length-33), -(z_joiner_spacing-joiner_width)/2, rail_thick+10],
			[-(extruder_length/2+rail_length-33), -(z_joiner_spacing+joiner_width)/2, rail_thick+10]
		], 4);
		wiring([
			[motor_spread/2, 0, motor_length-5],
			[(motor_spread/2-5), 0, motor_length-5],
			[(motor_spread/2-5), 0, rail_thick+5],
			[(extruder_length/2+rail_length), 0, rail_thick+5],
			[extruder_length/2-10, 0, rail_thick+5+arch_offset],
			[extruder_length/2-10, rail_width/3-5, rail_thick+5+arch_offset],
			[15, rail_width/3+5, rail_thick+10+arch_offset],
			[-15, rail_width/3+5, rail_thick+10+arch_offset],
			[-extruder_length/2+10, rail_width/3-5, rail_thick+5+arch_offset],
			[-extruder_length/2+10, 0, rail_thick+5+arch_offset],
			[-(extruder_length/2+rail_length/2), 0, rail_thick+5+arch_offset/2],
			[-(extruder_length/2+rail_length-36), -(z_joiner_spacing-joiner_width)/2, rail_thick+12],
			[-(extruder_length/2+rail_length-36), -(z_joiner_spacing+joiner_width)/2, rail_thick+12],
		], 4);
	}

	// Construction arrows.
	if(arrows && explode>50) {
		zring(r=(extruder_length+2*rail_length+2*cantilever_length)/2, n=2) {
			down(explode*1.5) {
				yrot(90) arrow(size=explode/3);
			}
		}
	}
}
//!bridge_assembly_5(explode=100, arrows=true);
//!bridge_assembly_5();


// Borosilicate Glass.  Render last to allow transparency to work.
module build_platform() {
	up(10+2+glass_thick/2) {
		color([0.75, 1.0, 1.0, 0.5]) {
			cube(size=[glass_width, glass_length, glass_thick], center=true);
		}
	}
}


module final_assembly_1(xslidepos=0, yslidepos=0, zslidepos=0, explode=0, arrows=false)
{
	// view: [140, 0, 235] [40, 0, 335] 2200
	// desc: Attach the right Z tower assembly to the right end of the XY axes assembly.  Route the right tower wiring through the rear X axis wiring access holes.
	x_axis_assembly_9(xslidepos=xslidepos, yslidepos=yslidepos) {
		nil();
		right(explode*2) {
			zrot(180) z_tower_assembly_5(slidepos=zslidepos) {
				nil();
				if ($children > 3) children(3);
				if ($children > 4) children(4);
			}

			// Construction arrows.
			if (arrows && explode>50) {
				up((rail_height+groove_height)/2) {
					left(explode*1.0) arrow(size=2*explode/3);
				}
			}
		}
		if ($children > 5) children(5);
	}
}
//!final_assembly_1(xslidepos=0, yslidepos=0, zslidepos=0, explode=0, arrows=true) z_sled();
//!final_assembly_1(explode=100, arrows=true);
//!final_assembly_1();


// Child 0: Z sled
// Child 1: Left Z tower top endcap mount point.
// Child 2: Left Z tower motherboard mount point.
// Child 3: Right Z tower top spool holder mount.
// Child 4: Right Z tower motherboard mount.  (not generally used.)
// Child 5: Build plate mount
module final_assembly_2(xslidepos=0, yslidepos=0, zslidepos=0, explode=0, arrows=false)
{
	// view: [-100, 0, 235] [45, 0, 45] 2400
	// desc: Attach the left Z tower assembly to the left end of the XY axes assembly.  Route all wiring out the back of the left Z tower base.
	x_axis_assembly_9(xslidepos=xslidepos, yslidepos=yslidepos) {
		left(explode*2) {
			z_tower_assembly_5(slidepos=zslidepos) {
				if ($children > 0) children(0);
				if ($children > 1) children(1);
				if ($children > 2) children(2);
			}

			// Construction arrows.
			if (arrows && explode>50) {
				up((rail_height+groove_height)/2) {
					right(explode*1.0) {
						zrot(180) arrow(size=2*explode/3);
					}
				}
			}
		}
		right(0) {
			zrot(180) z_tower_assembly_4(slidepos=zslidepos) {
				nil();
				if ($children > 3) children(3);
				if ($children > 4) children(4);
			}
		}
		if ($children > 5) children(5);
	}
	wiring([
		[-(motor_rail_length/2+rail_length+2*explode+platform_length+100), 0, rail_thick+10],
		[-(motor_rail_length/2+rail_length+2*explode+platform_length-5), 0, rail_thick+10],
		[-(motor_rail_length/2+rail_length+2*explode+15), 0, rail_thick+5],
		[-motor_rail_length/2, 0, rail_thick+5],
	], 4);
	wiring([
		[-(motor_rail_length/2+rail_length+2*explode+platform_length+100), +5, rail_thick+5],
		[-(motor_rail_length/2+rail_length+2*explode+platform_length-5), +5, rail_thick+5],
		[-(motor_rail_length/2+rail_length+2*explode+15), -rail_width/3, rail_thick+5],
		[-motor_rail_length/2, -rail_width/3, rail_thick+5],
	], 4);
}
//!final_assembly_2(xslidepos=0, yslidepos=0, zslidepos=0, explode=0, arrows=true) z_sled();
//!final_assembly_2(explode=100, arrows=true);
//!final_assembly_2();


// Child 0: Left Z tower top endcap mount point.
// Child 1: Left Z tower motherboard mount point.
// Child 2: Right Z tower top spool holder mount.
// Child 3: Right Z tower motherboard mount.  (not generally used.)
// Child 4: Build plate mount
module final_assembly_3(xslidepos=0, yslidepos=0, zslidepos=0, explode=0, arrows=false)
{
	// view: [0, 0, 240] [55, 0, 25] 3000
	// desc: Lower the extruder bridge down into the Z tower grooves, screwing the lifter screws into the Z-rail racks evenly.
	final_assembly_2(xslidepos=xslidepos, yslidepos=yslidepos, zslidepos=zslidepos) {
		up(explode*4) {
			right((extruder_length+rail_length*2+cantilever_length*2)/2) {
				bridge_assembly_5(slidepos=zslidepos);
			}

			// Construction arrows.
			if(arrows && explode>50) {
				bridgelen = extruder_length+2*rail_length+2*cantilever_length;
				down(explode*1.2) {
					right(bridgelen/2) {
						xspread(bridgelen) {
							yrot(-90) arrow(size=explode/2);
						}
					}
				}
			}
		}
		if ($children > 0) children(0);
		if ($children > 1) children(1);
		if ($children > 2) children(2);
		if ($children > 3) children(3);
		if ($children > 4) children(4);
	}
}
//!final_assembly_3(explode=100, arrows=true);
//!final_assembly_3(zslidepos=0);


module final_assembly_4(explode=0, arrows=false)
{
	// view: [0, 0, 240] [60, 0, 125] 400
	// desc: Attach a limit microswitch, with wiring, to the Z rail endcap.  Orient the switch as shown.
	rail_z_endcap();
	up(rail_height-endstop_length/2-2) {
		left(z_joiner_spacing/2-joiner_width/2-5-endstop_thick/2) {
			back(explode-endstop_depth/2) {
				zrot(180) xrot(90) {
					microswitch();
					wiring([
						[0, 8, -10],
						[-1, 7.9, -25],
						[-18.5, -30, -25],
						[-18.5, -30.01, 20],
					], 1, fillet=5, wirenum=4);
					wiring([
						[0, -8, -10],
						[0, -8.01, -25],
						[-16.5, -30, -25],
						[-16.5, -30.01, 20],
					], 1, fillet=5, wirenum=5);
				}
			}
		}
	}

	// Construction arrows.
	if(arrows && explode>50) {
		up(rail_height+groove_height-endstop_length/2-2) {
			left(z_joiner_spacing/2-joiner_width/2-5-endstop_thick/2) {
				back(explode/2-endstop_depth/2) {
					zrot(90) arrow(size=explode/4);
				}
			}
		}
	}
}
//!final_assembly_4(explode=100, arrows=true);
//!final_assembly_4();


// Child 0: Left Z tower motherboard mount point.
// Child 1: Right Z tower top spool holder mount.
// Child 2: Right Z tower motherboard mount.  (not generally used.)
// Child 3: Build plate mount
module final_assembly_5(xslidepos=0, yslidepos=0, zslidepos=0, explode=0, arrows=false)
{
	// view: [0, 0, 240] [55, 0, 25] 3000
	// desc: Attach the Z tower endcap to the left Z tower.  Route the limit switch wiring down through the wiring access holes in the left Z tower, and out the back of the base with the other wiring.
	final_assembly_3(xslidepos=xslidepos, yslidepos=yslidepos, zslidepos=zslidepos) {
		up(explode*2) {
			yrot(90) zrot(-90) final_assembly_4();

			// Construction arrows.
			if(arrows && explode>50) {
				down(explode*1.0) {
					right(rail_height/2+groove_height/2) {
						yrot(-90) arrow(size=explode/2);
					}
				}
			}
		}
		if ($children > 0) children(0);
		if ($children > 1) children(1);
		if ($children > 2) children(2);
		if ($children > 3) children(3);
	}
	left(motor_rail_length/2+rail_length+platform_length) {
		wiring([
			[rail_thick+5, 0, rail_height+groove_height+z_base_height+2*rail_length+2*explode],
			[rail_thick+5, 0, rail_thick+5],
			[-100, 0, rail_thick+5],
		], 2, fillet=9, wirenum=4);
	}
}
//!final_assembly_5(explode=100, arrows=true);
//!final_assembly_5();


// Child 0: Left Z tower motherboard mount point.
// Child 1: Right Z tower top spool holder mount.
// Child 2: Right Z tower motherboard mount.  (not generally used.)
// Child 3: Build plate mount
module final_assembly_6(xslidepos=0, yslidepos=0, zslidepos=85, explode=0, arrows=false)
{
	// view: [0, 0, 240] [92, 0, 10] 3000
	// desc: Attach a cable chain (18 links) from the extruder bridge cable chain mount to the left Z tower cable chain mount.  Route the extruder bridge wiring up through the cable chain, back into the left Z tower through the wiring access hole below the cable chain mount, down the left Z tower, and back out the motor rail segment to where the controller board will be mounted.  You may need to lubricate each cable-chain pivot with mineral oil.
	final_assembly_5(xslidepos=xslidepos, yslidepos=yslidepos, zslidepos=zslidepos) {
		if ($children > 0) children(0);
		if ($children > 1) children(1);
		if ($children > 2) children(2);
		if ($children > 3) children(3);
	}
	vert_off = rail_height + groove_height/2 + cantilever_length + cable_chain_height/2;
	up(2*explode+rail_height+groove_height+z_base_height+rail_length) {
		left(motor_rail_length/2+rail_length+platform_length) {
			fwd(z_joiner_spacing/2+joiner_width+23.5) {
				yrot(90) {
					up(cable_chain_height/2) {
						cable_chain_assembly(
							[-cable_chain_length/2-cable_chain_height/4-1, 0, vert_off],
							[0, 0, 0],
							[-1, 0, 0],
							2*rail_length,
							zslidepos,
							wires=20
						);
					}
				}
				right(cable_chain_height/2) {
					wiring([
						[0, 0, 0],
						[0, 0.01, -explode*2-cable_chain_length/2],
						[rail_thick-1, 0, -explode*2-cable_chain_length-5],
						[rail_thick-1, 45, -explode*2-cable_chain_length-5],
						[rail_thick-1, 45.01, -explode*2-cable_chain_length-rail_length-10],
						[-15, 45, -explode*2-cable_chain_length-rail_length-25],
						[-15, 55, -explode*2-cable_chain_length-rail_length-40],
						[-15, 55.01, -explode*2-cable_chain_length-rail_length-motor_rail_length],
					], 20);
					right(vert_off) {
						up(cable_chain_length/2+zslidepos) {
							wiring([
								[0, 0, 0],
								[0.01, 0, -explode*2-cable_chain_length/2-10],
								[20, 0, -explode*2-cable_chain_length/2-10],
								[20, 15, -explode*2-cable_chain_length/2+15],
								[20, 30, -explode*2-cable_chain_length/2+15],
							], 20);
						}
					}
				}
				// Construction arrows.
				if(arrows && explode>50) {
					down(explode) {
						fwd(15) {
							yrot(-90) arrow(size=explode/2);
							right(vert_off) {
								up(zslidepos) {
									yrot(-90) arrow(size=explode/2);
								}
							}
						}
					}
				}
			}
		}
	}
}
//!final_assembly_6(explode=100, arrows=true);
//!final_assembly_6(zslidepos=-166/2+10);
//!final_assembly_6();


// Child 0: Left Z tower motherboard mount point.
// Child 1: Right Z tower motherboard mount.  (not generally used.)
// Child 2: Build plate mount
// Child 3: Right Z tower spool axle mount.
module final_assembly_7(xslidepos=0, yslidepos=0, zslidepos=0, explode=0, arrows=false)
{
	// view: [0, 0, 240] [55, 0, 25] 3000
	// desc: Attach the spool holder to the top of the other Z tower.
	final_assembly_6(xslidepos=xslidepos, yslidepos=yslidepos, zslidepos=zslidepos) {
		if ($children > 0) children(0);

		up(explode*2) {
			right(rail_height/2) {
				spool_holder();
				up(spool_holder_length-15/2*cos(30)+0.25) {
					if ($children > 3) children(3);
				}
			}

			// Construction arrows.
			if(arrows && explode>50) {
				down(explode*1.0) {
					right(rail_height/2+groove_height/2) {
						yrot(-90) arrow(size=explode/2);
					}
				}
			}
		}

		if ($children > 1) children(1);
		if ($children > 2) children(2);
	}
}
//!final_assembly_7(explode=100, arrows=true);
//!final_assembly_7();


// Child 0: Right Z tower motherboard mount.  (not generally used.)
// Child 1: Build plate mount
// Child 2: Right Z tower spool axle mount.
module final_assembly_8(xslidepos=0, yslidepos=0, zslidepos=0, explode=0, arrows=false)
{
	// view: [0, 0, 240] [55, 0, 25] 3000
	// desc: Attach the RAMPS motherboard mount to the end of the printer base.
	final_assembly_7(xslidepos=xslidepos, yslidepos=yslidepos, zslidepos=zslidepos) {
		fwd(explode*2) {
			ramps_mount();

			// Construction arrows.
			if(arrows && explode>50) {
				back(explode*1.0) {
					up(rail_height/2+groove_height/2) {
						zrot(-90) arrow(size=explode/2);
					}
				}
			}
		}
		if ($children > 0) children(0);
		if ($children > 1) children(1);
		if ($children > 2) children(2);
	}
}
//!final_assembly_8(explode=100, arrows=true);
//!final_assembly_8();


// Child 0: Right Z tower motherboard mount.  (not generally used.)
// Child 1: Right Z tower spool axle mount.
module final_assembly_9(xslidepos=0, yslidepos=0, zslidepos=80, explode=0, arrows=false)
{
	// view: [0, 0, 0] [80, 0, 20] 2500
	// desc: Lower the glass build platform into the support corner clips on the Y sled.  You should be able to carefully work the clips around the glass plate's corners.
	final_assembly_8(xslidepos=xslidepos, yslidepos=yslidepos, zslidepos=zslidepos) {
		if ($children > 0) children(0);

		up(explode) {
			// Construction arrows.
			if(arrows && explode>50) {
				down(explode*0.75) {
					up(rail_height/2+groove_height/2) {
						yrot(-90) arrow(size=explode/3);
					}
				}
			}

			build_platform();
		}

		if ($children > 1) children(1);
	}
}
//!final_assembly_9(explode=100, arrows=true);
//!final_assembly_9();


module final_assembly_10(xslidepos=0, yslidepos=0, zslidepos=0, explode=0, arrows=false)
{
	// view: [0, 0, 0] [80, 0, 20] 2500
	// desc: Cradle the spool axle in the spool holder top.
	final_assembly_9(xslidepos=xslidepos, yslidepos=yslidepos, zslidepos=zslidepos) {
		nil();
		up(explode) {
			spool_axle();
			if (!(arrows && explode>50)) {
				down(52.5/2-14) spool();
			}
		}
	}
}
//!final_assembly_10(explode=100, arrows=true);
//!final_assembly_10();


module final_assembly_11(xslidepos=0, yslidepos=0, zslidepos=0, explode=0, arrows=false)
{
	// view: [50, 0, 0] [60, 0, 0] 600
	// desc: Optionally clean up wiring using the wiring clips.
	wiring([
		for (a=[-15:5:15]) [100*cos(a)-100, 100*sin(a), a]
	], 19);
	right(explode) {
		xrot(-60) down(5) zrot(-45) wire_clip(d=9.5);

		// Construction arrows.
		if(arrows && explode>50) {
			left(explode*0.5) {
				arrow(size=explode/3);
			}
		}
	}
}
//!final_assembly_11(explode=100, arrows=true);
//!final_assembly_11();


module full_rendering()
{
	xpos = 100*cos(360*$t+120);
	ypos = 100*sin(360*$t+120);
	zpos = 0.65*(rail_length-rail_height/2)*cos(360*$t);

	final_assembly_10(xslidepos=xpos, yslidepos=ypos, zslidepos=zpos);
}



full_rendering();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
