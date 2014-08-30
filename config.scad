snappy_version = 0.90;


platform_length = 100;
platform_width  = 150;
platform_height =  40;
platform_thick  =   7;
rack_tooth_size =   5;  // mm per tooth.

rail_length  = 150;
rail_height  =  50;
rail_thick   =   7;

motor_rail_length = 100;

roller_thick =  12;
roller_diam  =  30;
roller_axle  =  15;
roller_angle =  30;
roller_base  =  12;

joiner_angle =  30;
joiner_width =   9;
joiner_slop  =   0.5;



rail_spacing = platform_width - joiner_width*4 - 10;
roller_spacing = rail_spacing-roller_diam+0.5;
rail_width = rail_spacing + joiner_width*2;



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

