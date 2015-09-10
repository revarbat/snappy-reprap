snappy_version = 1.0;


// 0 = Thinning Walls (Thin in the middle, thick at edges.  Prettier smooth solid walls.)
// 1 = Corrugated closed walls. (Zig-zagged solid walls. Less shrinkage stress.)
// 2 = Crossbeam walls. (Open sparse struts. Far less shrinkage stress. Recommended.)
wall_styling = 0;


platform_length = 100;  // mm.  Must be a multiple of rack_tooth_size.
platform_width  = 150;  // mm
platform_height =  40;  // mm
platform_thick  =   7;  // mm

rail_length     = 150;  // mm
rail_height     =  50;  // mm
rail_thick      =   7;  // mm
rail_offset     =  12;  // mm

motor_rail_length = 100; // mm

groove_angle    =  30;   // degrees
groove_height   =  12;   // mm

joiner_angle    =  30;   // degrees
joiner_width    =  10;   // mm

rack_tooth_size     =  5;    // mm per tooth.
rack_height         = 10;    // mm
rack_base           =  2;    // mm
gear_base           = 10;    // mm
gear_teeth          =  8;
set_screw_size      =  3;    // mm size of set screw in drive gears, couplers, etc
motor_length        = 39.25; // mm length of NEMA17 motor.
motor_shaft_size    =  5;    // mm diameter of NEMA17 motor shaft.
motor_shaft_length  = 20;    // mm length of NEMA17 motor shaft.
motor_shaft_flatted = true;  // Is motor shaft keyed? (RECOMMENDED)

// Currently configured for 3/8" ACME threaded rod.
lifter_rod_diam     =   9.5;   // mm
lifter_rod_length   = 300.0;   // mm
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
endstop_hole_inset   =  8.0; // mm
endstop_hole_hoff    = 10.0; // mm
endstop_click_voff   =  3.0; // mm
endstop_screw_size   =  2.5; // mm
endstop_standoff     =  1.0; // mm
endstop_length       = 19.9; // mm
endstop_thick        =  6.7; // mm
endstop_depth        = 11.0; // mm

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

// Cable chain dimensions
cable_chain_height = 13;  // mm
cable_chain_width  = 25;  // mm
cable_chain_length = 26;  // mm
cable_chain_pivot  =  6;  // mm
cable_chain_bump   =  1;  // mm
cable_chain_wall   =  3;  // mm

spool_holder_length = 150.0;  // mm

jhead_vent_span     =  20.0;  // mm
jhead_barrel_diam   =  16.0;  // mm
jhead_shelf_thick   =   4.8;  // mm
jhead_groove_thick  =   4.6;  // mm
jhead_groove_diam   =  12.0;  // mm
jhead_cap_height    =   8.2;  // mm
jhead_cap_diam      =  12.0;  // mm

extruder_length      = 130.0;  // mm
extruder_thick       =   5.0;  // mm
extruder_shaft_len   =  25.0;  // mm
extruder_drive_diam  =  12.5;  // mm

/*
// 626 bearing
extruder_idler_diam  =  19.0;  // mm
extruder_idler_axle  =   6.0;  // mm
extruder_idler_width =   6.0;  // mm
*/

/*
// SAE bearing 5/8"OD x 1/4"ID x 1/5"W
extruder_idler_diam  =  15.9;  // mm
extruder_idler_axle  =   6.3;  // mm
extruder_idler_width =   5.0;  // mm
*/

// 686 bearing
extruder_idler_diam  =  13.0;  // mm
extruder_idler_axle  =   6.0;  // mm
extruder_idler_width =   5.0;  // mm

extruder_fan_size    =  40.0;  // mm
extruder_fan_thick   =  10.0;  // mm

cooling_fan_size     =  40.0;  // mm
cooling_fan_thick    =  10.0;  // mm
cooling_duct_height  =  15.0;  // mm

filament_diam        =   1.75; // mm

// This is the slop needed to make parts fit more exactly, and might be
// printer dependant.  Printing a slop calibration plate should help
// dial this setting in for your printer.
printer_slop =   0.25;  // mm



// Commonly used derived values.  Don't change these.
rail_spacing = platform_width - joiner_width*4 - 10;
rail_width = rail_spacing + joiner_width*2;
motor_mount_spacing=43+joiner_width+10;
side_mount_spacing = platform_length+10*2;
platform_z = rail_height+groove_height+rail_offset;
cantilever_length = (motor_rail_length+2*platform_length-2*platform_z-extruder_length)/2;
motor_top_z = platform_z-platform_thick-rack_base-rack_height-gear_base-2;

wall_styles = ["thinwall", "corrugated", "crossbeams"];
wall_style = wall_styles[wall_styling];


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
