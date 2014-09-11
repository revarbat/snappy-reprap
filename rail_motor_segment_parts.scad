include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <NEMA.scad>
use <tslot.scad>


module rail_motor_segment()
{
	joiner_length = 10;
	motor_mount_spacing=43+joiner_width+10;

	color("SpringGreen") difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0,0,rail_thick/2]) {
						difference() {
							union() {
								yrot(90)
									sparse_strut(h=rail_width, l=motor_rail_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
								cube(size=[motor_mount_spacing+joiner_width, 45+20, rail_thick], center=true);
							}
							cube(size=[motor_mount_spacing-joiner_width, 45, rail_thick+1], center=true);
						}
					}

					// Walls.
					grid_of(xa=[-(rail_spacing/2+joiner_width/2), (rail_spacing/2+joiner_width/2)], za=[(rail_height+3)/2]) {
						//thinning_wall(h=rail_height+3, l=motor_rail_length-joiner_length, thick=joiner_width, strut=rail_thick, bracing=false);
						sparse_strut(h=rail_height+3, l=motor_rail_length-joiner_length, thick=joiner_width, strut=rail_thick);
					}
				}

				// Clear space for joiners.
				translate([0,0,rail_height/2]) {
					joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, a=joiner_angle);
				}
			}

			// Rail backing.
			grid_of([-(rail_spacing/2+joiner_width/2), (rail_spacing/2+joiner_width/2)])
				translate([0,0,rail_height+roller_thick/2])
					cube(size=[joiner_width, motor_rail_length, roller_thick], center=true);

			// Snap-tab joiners.
			translate([0,0,rail_height/2]) {
				joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, l=13, a=joiner_angle);
			}

			// Side mount slots.
			grid_of(ya=[-platform_length/4, platform_length/4]) {
				zrot_copies([0,180]) {
					translate([rail_width/2-5, 0, 0]) {
						zrot(-90) lock_slot(h=30, wall=3, backing=2.5);
					}
				}
			}

			zrot_copies([0, 180]) {
				translate([0, motor_rail_length/2-8, rail_height/4]) {
					difference() {
						// Side supports.
						cube(size=[rail_width, 3, rail_height/2], center=true);

						// Wiring access holes.
						grid_of(xa=[-rail_width/4, rail_width/4])
							cube(size=[8, 5, 10], center=true);
					}
				}
			}

			// Motor mount joiners.
			translate([0, 0, 30]) {
				xrot(90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=30, a=joiner_angle);
			}
		}

		// Rail grooves.
		translate([0,0,rail_height+roller_thick/2]) {
			grid_of([-(rail_spacing/2), (rail_spacing/2)]) {
				scale([tan(roller_angle),1,1]) yrot(45) {
					cube(size=[roller_thick*sqrt(2)/2,motor_rail_length+1,roller_thick*sqrt(2)/2], center=true);
				}
			}
		}
	}
}
//!rail_motor_segment();



module rail_motor_segment_parts() { // make me
	rail_motor_segment();
}


rail_motor_segment_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

