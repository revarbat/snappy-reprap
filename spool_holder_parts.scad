include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 2;
$fs = 2;

module spool_holder()
{
	joiner_length=10;

	color("YellowGreen")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Side walls
				yspread(rail_width-joiner_width) {
					up(spool_holder_length/2+3) {
						yrot(90) {
							zrot(90) {
								if (wall_style == "crossbeams")
									sparse_strut(h=rail_height, l=spool_holder_length-6, thick=joiner_width, strut=5);
								if (wall_style == "thinwall")
									thinning_wall(h=rail_height, l=spool_holder_length-6, thick=joiner_width, strut=joiner_width, bracing=false);
								if (wall_style == "corrugated")
									corrugated_wall(h=rail_height, l=spool_holder_length-6, thick=joiner_width, strut=joiner_width);
							}
						}
					}

					top_half() {
						right(rail_height/2) {
							yrot(90) trapezoid([spool_holder_length/2, joiner_width], [10, joiner_width], h=groove_height);
						}
					}
				}

				// Back joiner
				up(6+rail_thick/2) {
					cube([rail_height, rail_width-joiner_width, rail_thick], center=true);
				}
			}

			// Chamfer top corners.
			xspread(rail_height) {
				up(spool_holder_length) {
					scale([1,1,0.75])
					yrot(45) {
						cube([sqrt(2)*15, rail_width+1, sqrt(2)*15], center=true);
					}
				}
			}

			// Clear space for joiners.
			up(0.05) {
				yrot(-90) zrot(90) joiner_pair_clear(spacing=rail_width-joiner_width, h=rail_height, w=joiner_width, a=joiner_angle, clearance=5);
			}

			// Spool Dowel notch
			yspread(rail_width-joiner_width) {
				up(spool_holder_length) {
					xrot(90) cylinder(h=joiner_width+1, d=10, center=true, $fn=6);
					yspread(joiner_width+3) {
						xrot(90) cylinder(h=joiner_width, d=15, center=true, $fn=6);
					}
				}
			}
		}

		// Joiner clip.
		yrot(-90) zrot(90) joiner_pair(spacing=rail_width-joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
	}
}


module spool_axle()
{
	color("YellowGreen")
	prerender(convexity=10)
	up(15/2*cos(30)) {
		difference() {
			xrot(90) cylinder(h=rail_width, d=15, center=true);
			down(16/2) cube([16, rail_width+1, 16], center=true);
		}
		xrot(90) cylinder(h=rail_width, d=10, center=true, $fn=6);
		xrot(90) cylinder(h=rail_width-joiner_width-3, d=15, center=true, $fn=6);
		yspread(rail_width-(joiner_width/2-3/2)/2) {
			xrot(90) cylinder(h=joiner_width/2-3/2, d=15, center=true, $fn=6);
		}
	}
}



module spool() {
	color([0.5, 0.5, 0.5])
	xrot(90) {
		difference() {
			union() {
				zspread(72-5) cylinder(h=5, d=205, center=true);
				cylinder(h=72, d=96, center=true);
			}
			cylinder(h=72+1, d=52.5, center=true);
			down(72/2-17/2) cylinder(h=17.1, d=90, center=true);
		}
	}
}


module spool_holder_parts() { // make me
	back(spool_holder_length/2) {
		up(rail_height/2) {
			xrot(90) {
				zrot(90) spool_holder();
			}
		}
	}
	fwd(10) spool_axle();
}


spool_holder_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

