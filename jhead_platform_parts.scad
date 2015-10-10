include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>


$fa = 2;
$fs = 2;


module jhead_platform()
{
	platform_vert_off = rail_height+groove_height+rail_offset;
	l = extruder_length;
	w = rail_width;
	h = rail_height;
	thick = jhead_groove_thick;
	motor_width = nema_motor_width(17);
	idler_backside = (jhead_barrel_diam+8)/2+8;
	idler_back_thick = 3.5;

	color("SteelBlue")
	prerender(convexity=10)
	zrot(-90)
	union() {
		difference() {
			union() {
				// Bottom.
				up(thick/2) {
					cube(size=[w, l, thick], center=true);
				}

				// Walls.
				xspread(rail_spacing+joiner_width) {
					up(h/6) {
						cube(size=[joiner_width, l/3-5, h/3], center=true);
					}
				}

				// Rubber band clip
				right((rail_spacing)/2) {
					up(h/3-0.05) {
						difference() {
							right_half(30) {
								right(2) {
									scale([1,0.75,1]) {
										cylinder(h=8, d1=joiner_width, d2=joiner_width+6);
										up(8) cylinder(h=1, d=joiner_width+6);
									}
								}
							}
							up(8+1) {
								xrot(90) fillet_mask(r=joiner_width/2, h=joiner_width*2);
							}
						}
					}
				}

				// Wall Triangles
				zring(n=2) {
					xflip_copy() {
						up((h+groove_height)/2) {
							fwd(l/2-l/2/2-0+0.05) {
								right((rail_spacing+joiner_width)/2) {
									difference() {
										thinning_brace(h=h+groove_height, l=l/2, thick=joiner_width, strut=groove_height/sqrt(2));
										up((h+groove_height)/2) cube([l+1, w+1, 4], center=true);
									}
								}
							}
						}
					}
				}

				// Jhead base
				fwd(extruder_shaft_len/4/2) {
					up((jhead_shelf_thick+jhead_groove_thick)/2) {
						cube([rail_width, extruder_shaft_len*0.75, jhead_shelf_thick+jhead_groove_thick], center=true);
					}
					up(jhead_shelf_thick+jhead_groove_thick) {
						up(motor_width*0.37/2) {
							cube([jhead_barrel_diam+8, extruder_shaft_len*0.75, motor_width*0.37], center=true);
						}
					}
				}

				// Lower idler mount blocks
				up(jhead_groove_thick+jhead_shelf_thick) {
					xspread(jhead_barrel_diam+8+9) {
						up(5/2-0.05) {
							fwd(2/2) {
								cube([15, extruder_shaft_len/2+2, 5], center=true);
							}
						}
					}
				}

				// Motor face plate.
				fwd(extruder_shaft_len/2-2/2) {
					right(extruder_drive_diam/2-0.5) {
						up(thick+jhead_shelf_thick+motor_width/2/2) {
							cube([motor_width, 2, motor_width/2], center=true);
						}
					}
				}


				// Motor supports
				fwd(motor_length/2+extruder_shaft_len/2) {
					right(extruder_drive_diam/2-0.5) {
						up(20/2) {
							xspread(motor_width-5) {
								yspread(rail_height-15) {
									cube([20, 15, 20], center=true);
								}
							}
						}
					}
				}
			}

			// Clear motor and extruder parts
			up(jhead_groove_thick+jhead_shelf_thick) {
				up(motor_width/2) {
					left(0.5) {
						right(extruder_drive_diam/2) {
							xrot(90) cylinder(h=extruder_shaft_len+1, d=extruder_drive_diam+1, center=true);
							fwd(extruder_shaft_len/2) {
								xrot(90) nema17_mount_holes(depth=2*2+0.05, l=0);
								fwd(motor_length/2) {
									cube([motor_width, motor_length, motor_width], center=true);
								}
							}
						}
						left(extruder_idler_diam/2) {
							back(1) {
								xrot(90) cylinder(h=extruder_shaft_len-2+0.05, d=extruder_idler_diam+2, center=true);
								left((extruder_idler_diam+2)/2) {
									cube([extruder_idler_diam+2, extruder_shaft_len-2+0.05, extruder_idler_diam+2], center=true);
								}
							}
						}
					}
				}
				up(jhead_cap_height+2*printer_slop) {
					cube([jhead_barrel_diam, filament_diam+4*printer_slop, 0.6], center=true);
					up(0.3) {
						cube([filament_diam+4*printer_slop, filament_diam+4*printer_slop, 0.6], center=true);
					}
				}
			}

			// Motor cooling convection hole.
			fwd(motor_width/2+extruder_shaft_len/2) {
				right(extruder_drive_diam/2-0.5) {
					cylinder(d=motor_width*0.85, h=thick*10, center=true);
				}
			}

			// Filament feed
			cylinder(d=filament_diam+4*printer_slop, h=100, center=true, $fn=12);
			up(jhead_groove_thick+jhead_shelf_thick+motor_width*0.37-1+0.05) {
				cylinder(d1=filament_diam+4*printer_slop, d2=filament_diam*3, h=2, center=true, $fn=12);
			}

			// Jhead groove slot
			up(jhead_groove_thick/2) {
				back(extruder_length/4/2) {
					yspread(extruder_length/4) {
						cylinder(h=jhead_groove_thick+0.1, d=jhead_groove_diam+printer_slop, center=true);
					}
					cube([jhead_groove_diam+printer_slop, extruder_length/4, jhead_groove_thick+0.1], center=true);
				}
			}

			// Jhead shelf slot
			up(jhead_groove_thick) {
				up((jhead_shelf_thick+jhead_cap_height+2*printer_slop)/2) {
					back(extruder_length/4/2) {
						yspread(extruder_length/4) {
							cylinder(h=jhead_shelf_thick+jhead_cap_height+2*printer_slop+0.1, d=jhead_barrel_diam+printer_slop, center=true);
						}
						cube([jhead_barrel_diam+printer_slop, extruder_length/4, jhead_shelf_thick+jhead_cap_height+2*printer_slop+0.1], center=true);
					}
				}
			}

			up((jhead_shelf_thick+jhead_groove_thick)/2) {
				// Extruder fan hole.
				back(extruder_length/4) {
					cylinder(h=jhead_shelf_thick+jhead_groove_thick+1, d=extruder_fan_size+2*printer_slop+2*2, center=true);
				}

				// Wire access slot
				back(extruder_length/4-extruder_fan_size/2+8/2) {
					xspread(w*0.5) {
						cylinder(h=jhead_shelf_thick+jhead_groove_thick+1, d=8, center=true);
					}
					cube([w*0.5, 8, jhead_shelf_thick+jhead_groove_thick+1], center=true);
				}
			}

			// Bottom idler holder
			xflip_copy() {
				up(jhead_groove_thick+idler_back_thick+printer_slop/2) {
					left(idler_backside-idler_back_thick) {
						intersection() {
							yrot_copies([0,-98]) {
								teardrop(r=idler_back_thick+printer_slop/2, h=extruder_shaft_len/2+printer_slop, ang=40, $fs=1);
							}
							up(idler_back_thick) {
								cube([2*idler_back_thick+printer_slop, extruder_shaft_len/2+printer_slop, 4*idler_back_thick+printer_slop], center=true);
							}
						}
						down(idler_back_thick/3) {
							yrot_copies([0,-8]) {
								left((idler_back_thick+printer_slop/2)/2) {
									up(50/2) {
										cube([idler_back_thick+printer_slop/2, extruder_shaft_len/2+printer_slop, 50], center=true);
									}
								}
							}
						}
					}
				}
			}

			// Clear space for joiners.
			up(rail_height/2+0.005) {
				joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=l+0.001, h=h, w=joiner_width, clearance=5, a=joiner_angle);
			}
		}

		// Rail end joiners.
		up(rail_height/2) {
			joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=l-0.05, h=h, w=joiner_width, l=10, a=joiner_angle);
		}

		// Motor joiner clips
		right(extruder_drive_diam/2-0.5) {
			fwd(extruder_shaft_len/2+motor_length/2) {
				difference() {
					up(jhead_groove_thick+jhead_shelf_thick+motor_width/2) {
						xrot(90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=motor_width/2+jhead_shelf_thick, a=joiner_angle);
					}
					cube([motor_mount_spacing+joiner_width+1, rail_height/3, motor_width*0.75], center=true);
				}
			}
		}

		// Fan Shroud Joiners
		up(thick+jhead_shelf_thick+extruder_fan_thick-6) {
			back(extruder_length/4) {
				xspread(extruder_fan_size+2*joiner_width) {
					xrot(90) half_joiner2(h=extruder_fan_size/2, w=joiner_width, a=joiner_angle);
				}
			}
		}
	}
}



module jhead_platform_parts() { // make me
	jhead_platform();
}



jhead_platform_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
