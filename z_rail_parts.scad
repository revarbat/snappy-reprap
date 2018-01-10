include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>
use <sliders.scad>
use <acme_screw.scad>

$fa=2;
$fs=2;

// connectby valid options: "", "fwd", "back"
module z_rail(explode=0, connectby="")
{
	side_joiner_len = 2;
	l = rail_length - 2 * printer_slop;
	motor_width = nema_motor_width(17);

	up(
		(connectby=="fwd")? -rail_height/2 :
		(connectby=="back")? -rail_height/2 :
		0
	) back(
		(connectby=="back")? -l/2 :
		(connectby=="fwd")? l/2 :
		0
	) {
		color([0.9, 0.7, 1.0])
		prerender(convexity=20)
		union() {
			difference() {
				union() {
					difference() {
						union() {
							// Bottom.
							up(rail_thick/2) yrot(90)
								sparse_strut(h=z_joiner_spacing-joiner_width, l=l-1, thick=rail_thick, maxang=70, strut=7, max_bridge=500);

							// Side Supports
							up(rail_height/2) {
								yspread((l-2*5-5)/2, n=3) {
									difference() {
										cube(size=[z_joiner_spacing, 4, rail_height], center=true);
										down(rail_height/2-rail_thick-10/2) cube(size=[16, 11, 10], center=true);
										up(rail_height/2 + groove_height/2) {
											xrot(90) {
												cylinder(d=z_joiner_spacing, h=10, center=true);
											}
										}
									}
								}
							}

							// Side walls
							xspread(z_joiner_spacing) {
								up(rail_height/2) {
									if (wall_style == "crossbeams")
										sparse_strut(h=rail_height, l=l-10, thick=joiner_width, strut=5);
									if (wall_style == "thinwall")
										thinning_wall(h=rail_height, l=l-10, thick=joiner_width, strut=5);
									if (wall_style == "corrugated")
										corrugated_wall(h=rail_height, l=l-10, thick=joiner_width, strut=5);
								}
							}

							// Rails.
							up(rail_height+groove_height/2-0.01) {
								xspread(z_joiner_spacing) {
									rail(l=l, w=joiner_width-0.01, h=groove_height);
								}
							}

							// Side wiring access hole frame
							if (wall_style == "corrugated") {
								up(10/2+rail_thick) {
									xspread(z_joiner_spacing) {
										yspread(motor_rail_length-2*28) {
											cube(size=[6, 16+4, 10+4], center=true);
										}
									}
								}
							}
						}

						// Side wiring access hole
						if (wall_style != "crossbeams") {
							up(10/2+rail_thick) {
								xspread(z_joiner_spacing) {
									yspread(motor_rail_length-2*28) {
										cube(size=[10, 16, 10], center=true);
									}
								}
							}
						}

						// Clear space for joiners.
						up(rail_height/2) {
							fwd(l/2-0.05) zrot(180) xspread(z_joiner_spacing) joiner_clear(h=rail_height, w=joiner_width, clearance=1, a=joiner_angle);
							back(l/2-0.05) xspread(z_joiner_spacing) yrot(180) joiner_clear(h=rail_height, w=joiner_width, clearance=1, a=joiner_angle);
						}
					}

					// Snap-tab joiners.
					up(rail_height/2+0.05) {
						fwd(l/2) zrot(180) xspread(z_joiner_spacing) joiner(h=rail_height, w=joiner_width, l=10, a=joiner_angle);
						back(l/2) xspread(z_joiner_spacing) yrot(180) joiner(h=rail_height, w=joiner_width, l=10, a=joiner_angle);
					}
				}

				// Clear space for Side half joiners
				up(rail_height/2/2) {
					yspread(l-2*joiner_width-1-0.05) {
						zring(r=z_joiner_spacing/2+joiner_width/2+side_joiner_len+0.05, n=2) {
							zrot(-90) {
								chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
									half_joiner_clear(h=rail_height/2, w=joiner_width, a=joiner_angle, clearance=0.01);
								}
							}
						}
					}
				}
			}

			// Side half joiners
			up(rail_height/2/2) {
				yspread(l-2*joiner_width-1-0.05) {
					zring(r=z_joiner_spacing/2+joiner_width/2+side_joiner_len+0.1, n=2) {
						zrot(-90) {
							chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
								half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len+joiner_width/2, a=joiner_angle);
							}
						}
					}
				}
			}
		}

		up(rail_height/2) {
			fwd(l/2+explode) {
				if ($children > 0) children(0);
			}
			back(l/2+explode) {
				if ($children > 1) children(1);
			}
		}
		up(rail_height/2/2) {
			back(l/2-10) {
				left(z_joiner_spacing/2+joiner_width/2+side_joiner_len) {
					if ($children > 2) children(2);
				}
				right(z_joiner_spacing/2+joiner_width/2+side_joiner_len) {
					if ($children > 3) children(3);
				}
			}
			fwd(l/2-10) {
				left(z_joiner_spacing/2+joiner_width/2+side_joiner_len) {
					if ($children > 4) children(4);
				}
				right(z_joiner_spacing/2+joiner_width/2+side_joiner_len) {
					if ($children > 5) children(5);
				}
			}
		}
	}
}
//!z_rail();



module z_rail_parts() { // make me
	zrot(90) z_rail();
}



z_rail_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

