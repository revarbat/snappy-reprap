snappy_version = 0.93;


// 0 = Thinning Walls (Thin in the middle, thick at edges.  Prettier smooth solid walls.)
// 1 = Corrugated closed walls. (Zig-zagged solid walls. Less shrinkage stress.)
// 2 = Crossbeam walls. (Open sparse struts. Far less shrinkage stress. Recommended.)
wall_styling = 0;


platform_length = 100; // mm.  Must be a multiple of rack_tooth_size.
platform_width  = 150; // mm
platform_height =  40; // mm
platform_thick  =   7; // mm

rail_length   = 150;    // mm
rail_height   =  50;    // mm
rail_thick    =   7;    // mm
rail_offset   =  12;    // mm

motor_rail_length = 100; // mm
extruder_length   = 150; // mm
extruder_thick    =   5; // mm

groove_angle  =  30;    // degrees
groove_height =  12;    // mm

joiner_angle  =  30;    // degrees
joiner_width  =  10;    // mm

rack_tooth_size    =  5; // mm per tooth.
rack_height        = 10; // mm
rack_base          =  2; // mm
gear_base          = 10; // mm
set_screw_size     =  3; // mm size of set screw in drive gears, couplers, etc
motor_length       = 39.25; // mm length of NEMA17 motor.
motor_shaft_size   =  5; // mm diameter of NEMA17 motor shaft.
motor_shaft_length = 20; // mm length of NEMA17 motor shaft.
motor_shaft_flatted = true;  // Is motor shaft keyed? (RECOMMENDED)

// Currently configured for 3/8" ACME threaded rod.
lifter_rod_diam     =   9.5; // mm
lifter_rod_length   = 300.0; // mm
lifter_rod_pitch    =   3.175; // mm lift per revolution

/*
// Mechanical endstop boards.
endstop_hole_spacing = 19; // mm
endstop_hole_inset   =  4; // mm
endstop_hole_hoff    = 10; // mm
endstop_click_voff   =  4; // mm
endstop_screw_size   =  3; // mm
endstop_standoff     =  2; // mm
*/

// Mechanical endstop bare microswitch.
endstop_hole_spacing =  9.5; // mm
endstop_hole_inset   =  8; // mm
endstop_hole_hoff    = 10; // mm
endstop_click_voff   =  3; // mm
endstop_screw_size   =  2.5; // mm
endstop_standoff     =  2; // mm

// Standard Mk2b Heated Build Platform from RepRapDiscount.com
hbp_width       = 215;   // mm
hbp_length      = 215;   // mm
hbp_hole_width  = 208.5; // mm
hbp_hole_length = 208.5; // mm
hbp_screwsize   =   3;   // mm

// Standard 200mm square borosilicate glass build platform
glass_width     = 214;   // mm
glass_length    = 200;   // mm
glass_thick     =   3;   // mm

// Fan shroud dimensions
fan_size         = 60;  // mm
fan_screw_size   =  4;  // mm
fan_mount_length = 15;  // mm
fan_mount_width  = 10;  // mm
fan_mount_screw  =  3;  // mm
fan_shroud_angle = 60;  // degrees

// Cable chain dimensions
cable_chain_height = 13;  // mm
cable_chain_width  = 25;  // mm
cable_chain_length = 26;  // mm
cable_chain_pivot  =  6;  // mm
cable_chain_bump   =  1;  // mm
cable_chain_wall   =  3;  // mm

// Motherboard dimensions (RAMBo)
board_hole_xspacing =  95.25;  // mm
board_hole_yspacing =  96.50;  // mm
board_width         = 105;     // mm
board_length        = 110;     // mm
board_thick         =  25;     // mm
board_screw_size    =   3;     // mm
board_standoff_hgt  =   2.5;   // mm
board_standoff_diam =   5;     // mm

// This is the slop needed to make parts fit more exactly, and might be
// printer dependant.  Printing a slop calibration plate should help
// dial this setting in for your printer.
printer_slop =   0.25; // mm



// Commonly used derived values.  Don't change these.
rail_spacing = platform_width - joiner_width*4 - 10;
rail_width = rail_spacing + joiner_width*2;
motor_mount_spacing=43+joiner_width+10;
side_mount_spacing = platform_length-25;
cantilever_length = (motor_rail_length+2*rail_length+2*platform_length-2*rail_height-2*motor_rail_length-extruder_length-groove_height)/2;
platform_z = rail_height+groove_height+rail_offset;
motor_top_z = platform_z-platform_thick-rack_base-rack_height-gear_base-2;

wall_styles = ["thinwall", "corrugated", "crossbeams"];
wall_style = wall_styles[wall_styling];


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
