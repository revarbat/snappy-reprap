include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <NEMA.scad>
use <tslot.scad>


module rail_motor_segment()
{
	joiner_length = 10;
	side_joiner_len = 10;

	color("SpringGreen")
	render(convexity=20)
	difference() {
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
					joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width+5, a=joiner_angle);
				}
			}

			// Rail backing.
			grid_of([-(rail_spacing/2+joiner_width/2), (rail_spacing/2+joiner_width/2)])
				translate([0,0,rail_height+groove_height/2])
					cube(size=[joiner_width, motor_rail_length, groove_height], center=true);

			// Snap-tab joiners.
			translate([0,0,rail_height/2]) {
				joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=motor_rail_length, h=rail_height, w=joiner_width, l=13, a=joiner_angle);
			}

			// Side mount slots.
			zrot_copies([0,180]) {
				translate([rail_width/2-5, 0, 0]) {
					translate([side_joiner_len+joiner_width/2, 0, rail_height/2/2]) {
						translate([0, -platform_length/4, 0]) {
							zrot(-90) half_joiner(h=rail_height/2, w=joiner_width, l=side_joiner_len, a=joiner_angle);
						}
						translate([0, platform_length/4, 0]) {
							zrot(-90) half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len, a=joiner_angle, slop=printer_slop);
						}
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
			translate([0, 0, rail_height-5-15]) {
				xrot(90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=rail_height-5-15, a=joiner_angle);
			}
		}

		// Rail grooves.
		translate([0,0,rail_height+groove_height/2]) {
			grid_of([-(rail_spacing/2), (rail_spacing/2)]) {
				scale([tan(groove_angle),1,1]) yrot(45) {
					cube(size=[groove_height*sqrt(2)/2,motor_rail_length+1,groove_height*sqrt(2)/2], center=true);
				}
			}
		}
	}
}
//!rail_motor_segment();



module rail_motor_segment_parts() { // make me
	zrot(90) rail_motor_segment();
}


rail_motor_segment_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

