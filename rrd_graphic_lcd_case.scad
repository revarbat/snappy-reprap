include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


case_wall = 3;

// LCD display
lcd_width = 79;
lcd_height = 52;
lcd_hoff = 0;
lcd_voff = 8.25;

// SD card slot (left side)
sd_slot_width = 28;
sd_slot_height = 5;
sd_slot_voff = 8.25;

// Full board
board_width = 93.5;
board_height = 87;
board_depth = 10;
board_thick = 1.5;
board_top_clearance = 10;
board_top_standoff = 4.5;
board_bot_standoff = 0;

// Connectors
conn_slot_width = 52;
conn_slot_height = 10;
conn_slot_gap = 8;
conn_slot_voff = 32.5;
conn_slot_hoff = 0;

// Control Dial
dial_diam = 8;
dial_height = 6.5;
dial_voff = -35.25;
dial_hoff = 36.5;

// Buzzer
buzzer_diam = 2;
buzzer_height = 9.5;
buzzer_voff = -35.25;
buzzer_hoff = 19;

// Reset
reset_diam = 6;
reset_height = 5;
reset_voff = -35.5;
reset_hoff = 3.5;


$fa = 2;
$fs = 1.5;


module reset_button(slop=0) {
	h = board_top_clearance + case_wall - reset_height + slop;
	up(h+1) {
		zflip() {
			cylinder(d=reset_diam+2+slop, h=h-3, center=false);
			cylinder(d=reset_diam+slop, h=h+1, center=false);
			up(h-3) cylinder(d1=reset_diam+2+slop, d2=reset_diam+slop, h=2, center=false);
		}
	}
}
//!reset_button();


module rrd_graphic_lcd_case_top()
{
	tab_h = sd_slot_height + case_wall + board_thick + 2;
	h = board_top_clearance + case_wall;

	difference() {
		union() {
			difference() {
				// Outer shell.
				union() {
					upcube([board_width+case_wall*2, board_height+case_wall*2, h-2]);
					upcube([board_width+case_wall-printer_slop, board_height+case_wall-printer_slop, h]);

					// SD slot backing
					back(sd_slot_voff) {
						right(board_width/2+case_wall/2) {
							upcube([case_wall, sd_slot_width-printer_slop*2, h]);
						}
					}
				}
				up(case_wall) {
					// Board supports
					difference() {
						upcube([board_width, board_height, h]);
						xspread(board_width) {
							yspread(board_height) {
								chamfer_mask_z(l=h*3, chamfer=4.0);
							}
						}
					}
					xspread(board_width-4) {
						// Clear upper standoff corners
						up(board_top_clearance-board_top_standoff-0.01) {
							back(board_height/2-4/2) {
								upcube([4, 4, h]);
							}
						}

						// Clear lower standoff corners
						up(board_top_clearance-board_bot_standoff-0.01) {
							fwd(board_height/2-4/2) {
								upcube([4, 4, h]);
							}
						}
					}
				}

				// LCD access
				back(lcd_voff) {
					right(lcd_hoff) {
						cube([lcd_width, lcd_height, h*2], center=true);
					}
				}
			}

			// Clip tabs
			up(h-2-0.01) {
				xspread(board_width-15-2*5) {
					yflip_copy() {
						fwd((board_height+case_wall-0.01)/2) {
							fwd(case_wall/2/2) down(0.5) upcube([15-0.5, case_wall/2, tab_h]);
							up(tab_h - case_wall*sqrt(2)/2) {
								yscale(0.5) {
									xrot(45) cube([15-0.5, case_wall, case_wall], center=true);
								}
							}
						}
					}
				}
			}

			// Rotary dial support
			left(dial_hoff) {
				back(dial_voff) {
					up(case_wall-0.01) {
						cylinder(d=dial_diam+4, h=board_top_clearance-dial_height, center=false);
					}
				}
			}

			// Reset button support
			left(reset_hoff) {
				back(reset_voff) {
					up(case_wall-0.01) {
						cylinder(d=reset_diam+6, h=board_top_clearance-reset_height, center=false);
					}
				}
			}
		}

		// Rotary dial hole
		left(dial_hoff) {
			back(dial_voff) {
				cylinder(d=dial_diam, h=h*3, center=true);
			}
		}

		// Buzzer sound hole.
		left(buzzer_hoff) {
			back(buzzer_voff) {
				cylinder(d=buzzer_diam, h=h*3, center=true);
			}
		}

		// Reset button hole
		left(reset_hoff) {
			back(reset_voff) {
				down(printer_slop/2) {
					reset_button(slop=3*printer_slop);
				}
			}
		}
	}

	// Reset button
	left(reset_hoff) {
		back(reset_voff) {
			reset_button(slop=0);
		}
	}
}
//!rrd_graphic_lcd_case_top();



module rrd_graphic_lcd_case_bottom()
{
	h = sd_slot_height + case_wall + board_thick + 2;
	joiner_length = 25;

	union() {
		xrot(45) {
			back(board_height/2+case_wall) {
				difference() {
					union() {
						upcube([board_width+case_wall*2, board_height+case_wall*2, h]);
						up(h/2) {
							fwd(board_height/2+case_wall) {
								xrot(45) cube([board_width+case_wall*2, h/sqrt(2), h/sqrt(2)], center=true);
							}
						}
					}
					up(case_wall) {
						difference() {
							trapezoid([board_width-2, board_height-sd_slot_height-2], [board_width-2, board_height-2], h-case_wall-2-board_thick+0.1, center=false);
							xspread(board_width-2) {
								yspread(board_height-2) {
									chamfer_mask_z(l=h+1, chamfer=3.0);
								}
							}
						}
						up(sd_slot_height) {
							upcube([board_width, board_height, h]);
							up(board_thick) {
								upcube([board_width+case_wall+printer_slop, board_height+case_wall+printer_slop, h]);
							}
						}
						back(sd_slot_voff) {
							left(board_width/2) {
								upcube([board_width/2, sd_slot_width, h]);
							}
						}
					}
					back(conn_slot_voff) {
						right(conn_slot_hoff) {
							xspread((conn_slot_width-conn_slot_gap)/2+conn_slot_gap) {
								cube([(conn_slot_width-conn_slot_gap)/2, conn_slot_height, h*2], center=true);
							}
						}
					}
					xspread(board_width-15-2*5) {
						yflip_copy() {
							fwd((board_height+case_wall-0.01)/2) {
								fwd(h/2) down(0.5) upcube([15, h, h+1]);
								up(case_wall*sqrt(2)/2) {
									yscale(0.5) {
										xrot(45) cube([15, case_wall, case_wall], center=true);
									}
								}
							}
						}
					}
				}
			}
		}
		back((board_height+2*case_wall)/sqrt(2)-0.01) {
			left(5/2) {
				xspread(board_width+2*case_wall-5) {
					zrot(-90) right_triangle([(board_height+2*case_wall)/sqrt(2), 5, (board_height+2*case_wall)/sqrt(2)], center=false);
				}
				right(conn_slot_hoff) zrot(-90) right_triangle([(board_height+2*case_wall)/sqrt(2), 5, (board_height+2*case_wall)/sqrt(2)], center=false);
			}
			fwd(8/2) upcube([board_width+2*case_wall, 8, rail_height/2]);
			right(platform_length/2/2-joiner_width/2-0.5) {
				back(joiner_length-0.01) {
					up(rail_height/2) joiner_pair(spacing=platform_length/2, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				}
			}
		}
	}
}
//!rrd_graphic_lcd_case_bottom();



module rrd_graphic_lcd_base_parts() { // make me
	fwd(40) rrd_graphic_lcd_case_bottom();
}



rrd_graphic_lcd_base_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

