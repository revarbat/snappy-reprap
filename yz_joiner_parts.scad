include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <tslot.scad>


module yz_joiner()
{
	joiner_length=10;
	base_height = rail_height+roller_thick;
	endstop_delta = platform_length - base_height;
	motor_mount_spacing=43+joiner_width+10;

	color("Turquoise") difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					difference() {
						union() {
							translate([0, platform_length/2, rail_thick/2]) {
								yrot(90)
									sparse_strut(h=rail_width, l=platform_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
							}
							translate([0, rail_height+roller_thick/2, rail_thick/2]) {
								cube(size=[45+20, motor_mount_spacing+joiner_width, rail_thick], center=true);
							}
						}
						translate([0, rail_height+roller_thick/2, rail_thick/2]) {
							cube(size=[45, motor_mount_spacing-joiner_width, rail_thick+1], center=true);
						}
					}

					// Lower Back.
					translate([0, rail_thick/2, platform_length/2]) zrot(90) {
						sparse_strut(h=platform_length, l=rail_width-joiner_width, thick=rail_thick, strut=rail_thick);
					}

					// Side Walls
					mirror_copy([1, 0, 0]) {
						translate([(rail_spacing+joiner_width)/2, 0, 0]) {
							// Upper Wall.
							grid_of(
								ya=[(rail_height+5)/2],
								za=[(platform_length-rail_height-roller_thick-5)/2+rail_height+roller_thick]
							) {
								sparse_strut(h=platform_length-rail_height-roller_thick+5, l=rail_height+5, thick=joiner_width, strut=rail_thick);
							}

							// Lower Wall.
							grid_of(
								ya=[(platform_length-joiner_length+1)/2],
								za=[(rail_height+roller_thick)/2]
							) {
								sparse_strut(l=platform_length-joiner_length+1, h=rail_height+roller_thick, thick=joiner_width, strut=rail_thick);
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

			// corner brace
			grid_of(
				xa=[-(rail_width-joiner_width)/2, (rail_width-joiner_width)/2]
			) {
				translate([0, endstop_delta/2+base_height-0.05, endstop_delta/2+base_height-0.05]) {
					thinning_brace(h=endstop_delta+0.05, l=endstop_delta+0.05, thick=joiner_width, strut=5);
				}
			}
		}

		// Endstop mount holes
		grid_of(
			xa=[-(rail_spacing+joiner_width)/2, (rail_spacing+joiner_width)/2],
			za=[-endstop_hole_spacing/2, endstop_hole_spacing/2]
		) {
			translate([0, platform_length-10, rail_height-endstop_hole_spacing/2+roller_thick/2]) {
				yrot(90) cylinder(r=(endstop_screw_size+printer_slop)/2, h=joiner_width+1, center=true, $fn=12);
			}
		}
	}
}
//yz_joiner();



module yz_joiner_parts() { // make me
	translate([0, -platform_length/2, 0]) yz_joiner();
}



yz_joiner_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

