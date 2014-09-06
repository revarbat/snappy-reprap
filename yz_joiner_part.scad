include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <tslot.scad>


module yz_joiner()
{
	joiner_length=10;
	base_height = rail_height+roller_thick;
	endstop_delta = platform_length - base_height;

	color("Turquoise") difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0,platform_length/2,rail_thick/2]) yrot(90)
						sparse_strut(h=rail_width, l=platform_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);

					// Lower Back.
					translate([0,rail_thick/2,rail_height/2]) zrot(90) {
						thinning_wall(h=rail_height, l=rail_width-joiner_width, thick=rail_thick, strut=rail_thick);
					}

					// Upper Back.
					translate([0, rail_thick/2, rail_height+(platform_length-rail_height-rail_thick)/2]) zrot(90) {
						thinning_wall(h=platform_length-rail_height+rail_thick, l=rail_width-joiner_width, thick=rail_thick, strut=rail_thick);
					}

					// Side Walls
					mirror_copy([1, 0, 0]) {
						translate([(rail_spacing+joiner_width)/2, 0, 0]) {
							// Upper Walls.
							grid_of(
								ya=[rail_height/2],
								za=[(platform_length-rail_height-joiner_length)/2+rail_height]
							) {
								thinning_wall(h=platform_length-joiner_length-rail_height+2*rail_thick, l=rail_height, thick=joiner_width, strut=rail_thick, bracing=false);
							}

							// Lower Walls.
							grid_of(
								ya=[(platform_length-rail_height-joiner_length)/2+rail_height],
								za=[rail_height/2]
							) {
								thinning_wall(l=platform_length-joiner_length-rail_height+2*rail_thick, h=rail_height, thick=joiner_width, strut=rail_thick, bracing=false);
							}

							// Corner Walls.
							grid_of(
								ya=[rail_height/2],
								za=[rail_height/2]
							) {
								thinning_wall(l=rail_height, h=rail_height, thick=joiner_width, strut=rail_thick, bracing=false);
							}

							// Rail tops.
							translate([0, rail_height, rail_height]) {
								translate([0, (platform_length-rail_height)/2, roller_thick/2])
									cube(size=[joiner_width, platform_length-rail_height, roller_thick], center=true);
								translate([0, roller_thick/2, (platform_length-rail_height)/2])
									cube(size=[joiner_width, roller_thick, platform_length-rail_height], center=true);
							}
						}
					}
				}

				// Clear space for front joiners.
				translate([0, platform_length, rail_height/2]) {
					joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, a=joiner_angle);
				}

				// Clear space for top joiners.
				translate([0, rail_height/2, platform_length]) {
					xrot(90) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, a=joiner_angle);
				}
			}

			// Front joiners.
			translate([0, platform_length, rail_height/2]) {
				joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}

			// Top joiners.
			translate([0, rail_height/2, platform_length]) {
				xrot(90) joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}

			translate([0, rail_height+roller_thick/2, 0]) {
				// Motor mount joiners.
				translate([0, 0, 50]) {
					zrot(90) xrot(90) joiner_pair(spacing=43+joiner_width+10, h=rail_height, w=joiner_width, l=50, a=joiner_angle);
				}

				// Motor mount support struts
				zrot_copies([0, 180]) {
					translate([0, (43+joiner_width+10)/2, rail_thick/2]){
						cube(size=[rail_width, joiner_width, rail_thick], center=true);
					}
				}
			}

			// Side mount slots.
			translate([0, platform_length/2, 0]) {
				grid_of(ya=[-platform_length/4, platform_length/4]) {
					zrot_copies([0,180]) {
						translate([rail_width/2-joiner_width/2, 0, 0]) {
							zrot(-90) lock_slot(h=30, wall=3, backing=joiner_width/2-2);
						}
					}
				}
			}

			translate([0, motor_rail_length+2, rail_height/4]) {
				difference() {
					// Side supports.
					cube(size=[rail_width, 3, rail_height/2], center=true);

					// Wiring access holes.
					grid_of(xa=[-rail_width/4, rail_width/4])
						cube(size=[8, 5, 10], center=true);
				}
			}

			// Y-axis endstop switch mount
			translate([-(rail_width-4)/2, endstop_delta/2+base_height-0.05, endstop_delta/2+base_height-0.05]) {
				difference() {
					cube(size=[4, endstop_delta+0.05, endstop_delta+0.05], center=true);
					translate([0, endstop_delta/2, endstop_delta/2]) xrot(45)
						cube(size=15, center=true);
					translate([0, endstop_delta/2-5, -endstop_delta/2+15]) {
						grid_of(za=[-5, 5]) {
							yrot(90) {
								cylinder(h=10, r=2.5/2, center=true, $fn=12);
							}
						}
					}
					translate([0, -(endstop_delta/2-15), (endstop_delta/2-5)]) {
						grid_of(ya=[-5, 5]) {
							yrot(90) {
								cylinder(h=10, r=2.5/2, center=true, $fn=12);
							}
						}
					}
				}
			}
		}
	}
}
//yz_joiner();



module yz_joiner_part() { // make me
	yz_joiner();
}



yz_joiner_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

