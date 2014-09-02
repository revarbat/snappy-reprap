include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <tslot.scad>


module rail_with_motor_mount()
{
	joiner_length = 10;

	color("SpringGreen") difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0,0,rail_thick/2]) yrot(90)
						sparse_strut(h=rail_width, l=motor_rail_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);

					// Walls.
					grid_of(xa=[-(rail_spacing/2+joiner_width/2), (rail_spacing/2+joiner_width/2)], za=[(rail_height+3)/2]) {
						thinning_wall(h=rail_height+3, l=motor_rail_length-joiner_length, thick=joiner_width, strut=rail_thick);
					}
				}

				// Clear space out near clips.
				grid_of(
					xa=[-(rail_spacing+joiner_width)/2, (rail_spacing+joiner_width)/2],
					ya=[-motor_rail_length/2, motor_rail_length/2],
					za=[(rail_height)/4, (rail_height)*3/4]
				) {
					scale([1, tan(joiner_angle), 1]) xrot(45)
						cube(size=rail_height/2/sqrt(2), center=true);
				}
			}

			// Rail backing.
			grid_of([-(rail_spacing/2+joiner_width/2), (rail_spacing/2+joiner_width/2)])
				translate([0,0,rail_height+roller_thick/2])
					cube(size=[joiner_width, motor_rail_length, roller_thick], center=true);

			// Joiner clips.
			translate([0,0,rail_height/2]) {
				zrot_copies([0,180]) {
					yrot_copies([0,180]) {
						translate([rail_spacing/2+joiner_width/2, motor_rail_length/2, 0]) {
							joiner(h=rail_height, w=joiner_width, l=13, a=joiner_angle);
						}
					}
				}
			}

			// Side mount slots.
			grid_of(ya=[-platform_length/4, platform_length/4]) {
				zrot_copies([0,180]) {
					translate([rail_width/2-5, 0, 0]) {
						zrot(-90) lock_slot(h=30, wall=3, backing=2.5);
					}
				}
			}

			// Side supports.
			zrot_copies([0, 180]) {
				translate([0, motor_rail_length/2-8, rail_height/4])
					cube(size=[rail_width, 3, rail_height/2], center=true);
			}

			// Motor clip mounts.
			zrot_copies([0, 180]) {
				translate([(43+joiner_width+10)/2, 0, 30]) {
					xrot(90) {
						joiner(h=rail_height, w=joiner_width, l=30, a=joiner_angle);
					}
				}
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
//!rail_with_motor_mount();



module rail_with_motor_mount_part() { // make me
	rail_with_motor_mount();
}


rail_with_motor_mount_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

