include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <roller_parts.scad>
use <roller_cap_parts.scad>



module slider_sled(show_rollers=false)
{
	axle_rad = (roller_axle/2) - 0.2;
	axle_len = roller_thick;
	pedestal_lip = 1.5;
	cap_snap_len = 10*3/4;

	union() {
		difference() {
			union() {
				// Bottom strut.
				translate([0,0,platform_thick/2])
					yrot(90) sparse_strut(h=platform_width, l=platform_length, thick=platform_thick, maxang=45, strut=12, max_bridge=999);

				// Solid walls.
				zrot_copies([0, 180]) {
					translate([(platform_width-joiner_width)/2, 0, platform_height/2]) {
						thinning_wall(h=platform_height, l=platform_length-10, thick=joiner_width, strut=platform_thick, wall=3, bracing=false);
					}
				}
			}

			// Clear space for joiners.
			translate([0,0,platform_height/2]) {
				joiner_quad_clear(xspacing=platform_width-joiner_width, yspacing=platform_length, h=platform_height, w=joiner_width, a=joiner_angle);
			}
		}

		// Snap-tab joiners.
		translate([0,0,platform_height/2]) {
			joiner_quad(xspacing=platform_width-joiner_width, yspacing=platform_length, h=platform_height, w=joiner_width, l=5, a=joiner_angle);
		}

		grid_of(xa=[-roller_spacing/2,roller_spacing/2]) {
			grid_of(ya=[-(platform_length/2)/2, (platform_length/2)/2]) {
				// Roller pedestals
				translate([0,0,roller_base/2]) {
					cylinder(h=roller_base, r=axle_rad+pedestal_lip, center=true, $fn=32);
				}

				// Roller axles
				translate([0,0,axle_len/2+roller_base]) {
					difference() {
						cylinder(h=axle_len, r=axle_rad, center=true, $fn=32);
						cylinder(h=axle_len+0.05, r=axle_rad-2.5, center=true, $fn=16);
						translate([0, 0, -axle_len/2+(axle_len-cap_snap_len)/2])
							cylinder(h=axle_len-cap_snap_len+0.05, r=axle_rad-2.0, center=true, $fn=16);
					}
				}
			}
		}
	}
}


module slider_rollers()
{
	axle_len = roller_thick;

	grid_of(xa=[-roller_spacing/2,roller_spacing/2]) {
		grid_of(ya=[-(platform_length/2)/2, (platform_length/2)/2]) {
			translate([0,0,axle_len/2+roller_base]) {
				// Rollers
				roller();

				// Caps
				translate([0,0,axle_len/2]) xrot(180)
					roller_cap(r=roller_axle/2-3, h=10, lip=2, wall=3);
			}
		}
	}
}




slider_sled(show_rollers=true);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

