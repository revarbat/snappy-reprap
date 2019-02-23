include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rail_z_endcap()
{
	joiner_length = 55;
	w = z_joiner_spacing + joiner_width;
	l = rail_height;

	color("YellowGreen")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Bottom.
				translate([0, -l/2, rail_thick/2])
					cube(size=[w, l, rail_thick], center=true);

				// Back.
				translate([0, -l+joiner_width/2, rail_height/2]) zrot(90) {
					if (wall_style == "crossbeams")
						sparse_strut(h=rail_height, l=w-0.1, thick=joiner_width, strut=5);
					if (wall_style == "thinwall")
						thinning_wall(h=rail_height, l=w-0.1, thick=joiner_width, strut=5);
					if (wall_style == "corrugated")
						corrugated_wall(h=rail_height, l=w-0.1, thick=joiner_width, strut=5);
				}

			}

			// Clear space for joiners.
			up(rail_height/2-0.05) {
				joiner_pair_clear(spacing=z_joiner_spacing, h=rail_height, w=joiner_width, a=joiner_angle, clearance=1);
			}
		}

		// Joiner clips.
		up(rail_height/2) {
			xspread(z_joiner_spacing) {
				joiner(h=rail_height, w=joiner_width, l=l-5/2, a=joiner_angle);
				fwd(l+10) zrot(180) yrot(180) joiner(h=rail_height, w=joiner_width, l=13, a=joiner_angle);
			}
		}

		// Top joiner clips
		up(platform_length) {
			fwd(l-joiner_width/2) {
				difference() {
					zrot(90) xrot(90) joiner(h=rail_height, w=joiner_width, l=platform_length-rail_height+1, a=joiner_angle);
					down(platform_length/2+10) cube([rail_height/2, joiner_width+1, platform_length], center=true);
				}
			}
		}
	}
}
//!rail_z_endcap();



module rail_z_endcap_parts() { // make me
	zrot(-90) rail_z_endcap();
}


rail_z_endcap_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

