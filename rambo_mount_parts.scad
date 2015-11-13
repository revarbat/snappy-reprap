include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 2;
$fs = 2;


// Motherboard dimensions (RAMBo)
board_width         = 105.0;  // mm
board_length        = 110.0;  // mm
board_thick         =  40.0;  // mm


l = 150;
joiner_length = board_thick + rail_thick;


module rambo_mount() {
    color("LightBlue")
    prerender(convexity=20)
    difference() {
        union() {
            // Back.
			fwd(joiner_length) {
				up(l/2) {
					zrot(90) sparse_strut(h=l, l=rail_width, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
					cube([rail_width, rail_thick, 10], center=true);
					cube([10, rail_thick, l], center=true);
				}
			}
			up(2/2) {
				fwd((joiner_length-5)/2+5) {
					cube([rail_width, joiner_length-5, 2], center=true);
				}
			}

			difference() {
				// Snap-tab joiners.
				up(rail_height/2) {
					joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				}

				// Wiring access hole.
				up(rail_height/2) {
					fwd((joiner_length-10)/2+10) {
						cube([rail_spacing+2*joiner_width+1, joiner_length-10, 20], center=true);
					}
				}
			}

			// Motherboard standoffs
			fwd(joiner_length-10/2) {
				up((board_length+5)/2+rail_height) {
					zspread(board_length*0.5) {
						xspread(board_width+1) {
							cube([3, rail_thick+5, 10], center=true);
						}
					}
					down((board_length+1)/2) {
						cube([10, rail_thick+5, 3], center=true);
					}
				}
			}
        }

		// Motherboard clip clearance
		up((board_length+5)/2+rail_height) {
			fwd(joiner_length-10/2-2) {
				xrot(-90) trapezoid([board_width, board_length], [board_width-0.5, board_length-0.5], h=10);
			}
		}

        // Shrinkage stress relief
		fwd(joiner_length) {
			up(l/2) {
				zspread(22, n=6) {
					cube(size=[rail_width+1, rail_thick-2, 1], center=true);
				}
				xspread(30, n=4) {
					cube(size=[1, rail_thick-2, board_length+rail_height+10], center=true);
				}
			}
        }
    }
}
//!rambo_mount();


module rambo_mount_parts() { // make me
	up(joiner_length+rail_thick/2) {
		back(l/2) {
			xrot(90) rambo_mount();
		}
	}
}


rambo_mount_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
