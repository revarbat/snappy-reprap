include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rails_90deg_joint()
{
	joiner_length=10;

	difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0,platform_length/2,rail_thick/2]) yrot(90)
						sparse_strut(h=rail_width, l=platform_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);

					// Back.
					translate([0,rail_thick/2,platform_length/2]) zrot(90) {
						thinning_wall(h=platform_length, l=rail_width, thick=rail_thick, strut=5);
					}

					// Side Walls
					grid_of(xa=[-(rail_spacing/2+joiner_width/2), (rail_spacing/2+joiner_width/2)]) {
						// Upper Walls.
						grid_of(
							ya=[rail_height/2],
							za=[(platform_length-rail_height-joiner_length)/2+rail_height]
						) {
							thinning_wall(h=platform_length-joiner_length-rail_height+2*rail_thick, l=rail_height, thick=joiner_width, strut=rail_thick);
						}

						// Lower Walls.
						grid_of(
							ya=[(platform_length-rail_height-joiner_length)/2+rail_height],
							za=[rail_height/2]
						) {
							thinning_wall(l=platform_length-joiner_length-rail_height+2*rail_thick, h=rail_height, thick=joiner_width, strut=rail_thick);
						}

						// Corner Walls.
						grid_of(
							ya=[rail_height/2],
							za=[rail_height/2]
						) {
							thinning_wall(l=rail_height, h=rail_height, thick=joiner_width, strut=rail_thick);
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

				// Clear space out near front clips.
				grid_of(
					xa=[-(rail_spacing+joiner_width)/2, (rail_spacing+joiner_width)/2],
					ya=[platform_length],
					za=[(rail_height)/4, (rail_height)*3/4]
				) {
					scale([1, tan(joiner_angle), 1]) xrot(45)
						cube(size=rail_height/2/sqrt(2), center=true);
				}

				// Clear space out near top clips.
				grid_of(
					xa=[-(rail_spacing+joiner_width)/2, (rail_spacing+joiner_width)/2],
					ya=[rail_height/4, rail_height*3/4],
					za=[platform_length]
				) {
					scale([1, 1, tan(joiner_angle)]) xrot(45)
						cube(size=rail_height/2/sqrt(2), center=true);
				}
			}

			// Front Joiner clips.
			translate([0, 0, rail_height/2]) {
				yrot_copies([0, 180]) {
					translate([rail_spacing/2+joiner_width/2, platform_length, 0]) {
						joiner(h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
					}
				}
			}

			// Top Joiner clips.
			translate([0, (rail_height)/2, platform_length]) {
				zrot_copies([0,180]) {
					translate([rail_spacing/2+joiner_width/2, 0, 0]) {
						xrot(90) joiner(h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
					}
				}
			}

			// Side mount slots.
			translate([0, platform_width/3, 0]) {
				grid_of(ya=[-platform_width/3/2, platform_width/3/2]) {
					zrot_copies([0,180]) {
						translate([rail_width/2-2.5, 0, 0]) {
							zrot(-90) lock_slot(h=25, wall=3);
						}
					}
				}
			}
		}
	}
}
//!rails_90deg_joint();



module rails_90deg_joint_point() { // make me
	rails_90deg_joint();
}



rails_90deg_joint_point();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

