include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <roller_parts.scad>
use <cap_parts.scad>



module slider_sled(show_rollers=false)
{
	axle_rad = (roller_axle/2) - 0.2;
	axle_len = roller_thick;

	union() {
		difference() {
			// Bottom strut.
			translate([0,0,platform_thick/2])
				yrot(90) sparse_strut(h=platform_width, l=platform_length, thick=platform_thick, maxang=45, strut=12, max_bridge=999);

			// Remove bits from platform so snap tabs have freedom.
			zrot_copies([0,180]) {
				grid_of(
					xa=[-(platform_width-joiner_width/2-5)/2, (platform_width-joiner_width/2-5)/2],
					ya=[platform_length/2]
				) {
					xrot(joiner_angle) translate([-(joiner_width+10)/2,0,-1])
						cube(size=[joiner_width+10,platform_thick,platform_thick*3], center=false);
				}
			}
		}

		translate([0,0,platform_height/2]) {
			// Snap-tab joiners.
			zrot_copies([0,180]) {
				yrot_copies([0,180]) {
					translate([platform_width/2-joiner_width/2, platform_length/2, 0]) {
						joiner(h=platform_height, w=joiner_width, l=10, a=joiner_angle);
					}
				}
			}

			// Solid walls.
			grid_of(xa=[-(platform_width-joiner_width)/2, (platform_width-joiner_width)/2]) {
				thinning_wall(h=platform_height, l=platform_length-18, thick=joiner_width, strut=platform_thick, wall=3, bracing=false);
			}
		}

		grid_of(xa=[-roller_spacing/2,roller_spacing/2]) {
			grid_of(ya=[-(platform_length/2)/2, (platform_length/2)/2]) {
				// Roller pedestals
				translate([0,0,roller_base/2]) {
					cylinder(h=roller_base, r=axle_rad+1.5, center=true, $fn=32);
				}

				// Roller axles
				translate([0,0,axle_len/2+roller_base]) {
					tube(h=axle_len+0.05, r=axle_rad, wall=2.5, center=true, $fn=32);
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
					cap(r=roller_axle/2-3, h=10, lip=2, wall=3);
			}
		}
	}
}




slider_sled(show_rollers=true);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

