include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 1;
$fs = 2;

module motherboard_mount() {
    joiner_length = 25;
    side_joiner_len = 10;

    color("LightBlue")
    prerender(convexity=20)
    difference() {
        union() {
            // Bottom.
            up(rail_thick/2) {
                yrot(90) sparse_strut(h=rail_width, l=board_length+rail_height+5, thick=rail_thick, maxang=45, strut=10, max_bridge=500);
            }

            // Snap-tab joiners.
            fwd((board_length+5)/2) {
                up(joiner_length) {
                    xrot(90) joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
                }
            }

            back(rail_height/2+5) {
                up(rail_thick/2) {
                    yspread(board_hole_yspacing) {
                        // Hole backings
                        cube([max(board_width, rail_width), 10, rail_thick], center=true);
                        xspread(board_hole_xspacing) {
                            up(board_standoff_hgt) {
                                cylinder(h=rail_thick+board_standoff_hgt, d=board_screw_size+board_standoff_diam, center=true);
                            }
                        }
                    }
                }
            }
        }

        // Board mount screwholes
        back(rail_height/2+5) {
            up(rail_thick/2) {
                xspread(board_hole_xspacing) {
                    yspread(board_hole_yspacing) {
                        cylinder(h=rail_thick*4, d=board_screw_size, center=true, $fn=8);
                    }
                }
            }
        }

        // Shrinkage stress relief
        up(rail_thick/2) {
            yspread(24, n=6) {
                cube(size=[rail_width+1, 1, rail_thick-2], center=true);
            }
            xspread(20, n=5) {
                cube(size=[1, board_length+rail_height+10, rail_thick-2], center=true);
            }
        }
    }
}
!motherboard_mount();


module motherboard_mount_parts() { // make me
	zrot(90) motherboard_mount();
}


motherboard_mount_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
