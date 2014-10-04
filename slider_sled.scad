include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>



module slider_sled()
{
	union() {
		difference() {
			union() {
				// Bottom
				translate([0,0,platform_thick/2])
					yrot(90) sparse_strut(h=platform_width, l=platform_length, thick=platform_thick, maxang=45, strut=12, max_bridge=999);

				// Walls.
				zrot_copies([0, 180]) {
					translate([(platform_width-joiner_width)/2, 0, platform_height/2]) {
						if (wall_style == "crossbeams")
							sparse_strut(h=platform_height, l=platform_length-10, thick=joiner_width, strut=5);
						if (wall_style == "thinwall")
							thinning_wall(h=platform_height, l=platform_length-10, thick=joiner_width, strut=platform_thick, wall=3, bracing=false);
						if (wall_style == "corrugated")
							corrugated_wall(h=platform_height, l=platform_length-10, thick=joiner_width, strut=platform_thick, wall=3);
					}
				}
			}

			// Clear space for joiners.
			translate([0,0,platform_height/2]) {
				joiner_quad_clear(xspacing=platform_width-joiner_width, yspacing=platform_length, h=platform_height, w=joiner_width+5, a=joiner_angle);
			}
		}

		// Snap-tab joiners.
		translate([0,0,platform_height/2]) {
			joiner_quad(xspacing=platform_width-joiner_width, yspacing=platform_length, h=platform_height, w=joiner_width, l=5, a=joiner_angle);
		}

		mirror_copy([1,0,0]) {
			// slider ridges.
			translate([-(rail_spacing)/2, 0, 0]) {
				translate([6/2,0,rail_offset/2])
					cube(size=[6, platform_length, rail_offset], center=true);
				grid_of(
					ya=[-platform_length*7/16, 0, platform_length*7/16],
					za=[rail_offset+groove_height/2]
				) {
					translate([6/2,0,0])
						cube(size=[6, platform_length/8, groove_height], center=true);
					scale([tan(groove_angle),1,1]) {
						yrot(45) {
							chamfcube(size=[groove_height/sqrt(2), platform_length/8, groove_height/sqrt(2)], chamfer=2, chamfaxes=[1,0,1], center=true);
						}
					}
				}
			}
		}
	}
}



slider_sled();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

