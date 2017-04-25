include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 2;
$fs = 2;

spool_w = 80 + joiner_width;
spool_notch = 3;

module spool_holder()
{
	joiner_length=10;

	color("YellowGreen")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Side walls
				yspread(spool_w) {
					up(spool_holder_length/2+3) {
						yrot(90) {
							zrot(90) {
								if (wall_style == "crossbeams")
									sparse_strut(h=rail_height, l=spool_holder_length-6, thick=joiner_width, strut=joiner_width);
								if (wall_style == "thinwall")
									thinning_wall(h=rail_height, l=spool_holder_length-6, thick=joiner_width, strut=joiner_width);
								if (wall_style == "corrugated")
									corrugated_wall(h=rail_height, l=spool_holder_length-6, thick=joiner_width, strut=joiner_width);
							}
						}
					}
				}

				// Back joiner
				up(6+joiner_width/2) {
					yrot(90) {
						if (wall_style == "crossbeams")
							sparse_strut(h=rail_height, l=spool_w+joiner_width/2-1, thick=joiner_width, strut=joiner_width);
						if (wall_style == "thinwall")
							thinning_wall(h=rail_height, l=spool_w+joiner_width/2-1, thick=joiner_width, strut=joiner_width);
						if (wall_style == "corrugated")
							corrugated_wall(h=rail_height, l=spool_w+joiner_width/2-1, thick=joiner_width, strut=joiner_width);
					}
				}
			}

			// Chamfer top corners.
			xspread(rail_height) {
				up(spool_holder_length) {
					scale([1,1,0.75])
					yrot(45) {
						cube([sqrt(2)*15, spool_w+joiner_width+1, sqrt(2)*15], center=true);
					}
				}
			}

			// Clear space for joiners.
			up(0.05) {
				yrot(90) zrot(-90) {
					joiner_pair_clear(spacing=z_joiner_spacing, h=rail_height, w=joiner_width, a=joiner_angle, clearance=1);
				}
			}

			// Spool Dowel notch
			yspread(spool_w) {
				up(spool_holder_length) {
					difference() {
						xrot(90) cylinder(h=joiner_width+1, d=15, center=true, $fn=6);
						cube(size=[20, spool_notch, 20], center=true);
					}
					xrot(90) cylinder(h=spool_notch+1, d=10, center=true, $fn=6);
				}
			}
		}

		// Joiner clip.
		yspread(z_joiner_spacing) {
			yrot(90) zrot(-90) {
				joiner(h=rail_height, w=joiner_width, l=6+joiner_length/2, a=joiner_angle);
			}
		}
	}
}
//!spool_holder();


module spool_axle()
{
	color("YellowGreen")
	prerender(convexity=10)
	up(15/2*cos(30)) {
		top_half(spool_w+joiner_width+1) xrot(90) cylinder(h=spool_w+joiner_width, d=15, center=true);
		difference() {
			xrot(90) cylinder(h=spool_w+joiner_width, d=15, center=true, $fn=6);
			yspread(spool_w) cube(size=[20, spool_notch+printer_slop, 20], center=true);
		}
		xrot(90) cylinder(h=spool_w+joiner_width, d=10, center=true, $fn=6);
	}
}
//!spool_axle();



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

