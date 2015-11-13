include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 2;
$fs = 2;


// Motherboard dimensions (RAMBo)
board_width         = 101.55;  // mm
board_length        =  53.55;  // mm
board_thick         =  50.0;  // mm


l = board_length + rail_height + 5;
//l = board_length + 10;
joiner_length = board_thick + rail_thick;



module ramps_mount() {
    color("LightBlue")
    prerender(convexity=20)
    difference() {
        union() {
            // Back.
			fwd(joiner_length) {
				up(l/2) {
					zrot(90) sparse_strut(h=l, l=rail_width, thick=rail_thick, maxang=60, strut=10, max_bridge=500);
					cube([10, rail_thick, l], center=true);
				}
				up(rail_height+5/2+board_length/2) {
					cube([rail_width, rail_thick, 10], center=true);
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
				up(rail_height+5/2+board_length/2) {
					xspread(board_width) {
						cube([5, rail_thick+10, 10], center=true);
					}
					zspread(board_length) {
						cube([10, rail_thick+10, 5], center=true);
					}
				}
			}
        }

		// Motherboard clip clearance
		up(rail_height+5/2+board_length/2) {
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
//!ramps_mount();


module ramps_mount_parts() { // make me
	up(joiner_length+rail_thick/2) {
		back(l/2) {
			xrot(90) ramps_mount();
		}
	}
}


ramps_mount_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
