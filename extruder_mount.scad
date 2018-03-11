include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <acme_screw.scad>
use <joiners.scad>


$fa = 2;
$fs = 1;


motor_width = nema_motor_width(17);
motor_plinth_diam = nema_motor_plinth_diam(17);
motor_plinth_height = nema_motor_plinth_height(17);
motor_mount_spacing = motor_width + 2*joiner_width;


module extruder_additive(groove_thick, groove_diam, shelf, cap, barrel, filament, drive_gear, shaft, idler, slop=printer_slop)
{
	motor_z = groove_thick + 5 + motor_width/2;
	right(drive_gear/2-0.5) {
		// Center block
		left((motor_mount_spacing+joiner_width)/2/2) {
			upcube([(motor_mount_spacing+joiner_width)/2, shaft, motor_z-10]);
		}
		left(drive_gear/2-0.5) {
			upcube([barrel+2*8, shaft, motor_z-adjust_screw_diam/2-1]);
		}

		// Idler compression screw socket
		left((motor_mount_spacing+joiner_width)/2+adjust_screw_pitch*3/2) {
			upcube([3*adjust_screw_pitch+0.01, adjust_screw_diam+2*3, motor_z+adjust_screw_diam/2+3]);
		}

		// Motor supports
		fwd(motor_length/2+shaft/2) {
			upcube([motor_mount_spacing+0.01, motor_length+joiner_width-0.01, motor_z-10]);
		}

		// Motor mount top joiners
		fwd(motor_length/2+shaft/2) {
			up(motor_z) {
				difference() {
					xrot(90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=motor_z, a=joiner_angle);
					xspread(motor_mount_spacing+joiner_width) {
						yspread(rail_height) {
							chamfer_mask_z(l=rail_height*2, chamfer=joiner_width/3);
						}
					}
				}
			}
		}
	}
}


module extruder_subtractive(groove_thick, groove_diam, shelf, cap, barrel, filament, drive_gear, shaft, idler, slop=printer_slop)
{
	idler_backside = 20;
	idler_back_thick = 3.5;
	motor_z = groove_thick + 5 + motor_width/2;

	up(motor_z) {
		left(0.5) {
			// Motor space
			right(drive_gear/2) {
				fwd(shaft/2) {
					fwd(motor_length/2) {
						cube([motor_width+slop*2, motor_length+slop*2, motor_width+slop*2], center=true);
					}
					xrot(-90) cylinder(d=motor_plinth_diam, h=motor_plinth_height, center=false);
				}
			}

			// Drive gear space
			right(drive_gear/2) {
				xrot(90) cylinder(h=shaft+1, d=drive_gear+1, center=true);
			}

			// Idler bearing space
			fwd(motor_length/2/2) {
				left(idler/2) {
					xrot(90) cylinder(h=shaft/2+slop+motor_length/2+5, d=idler+2, center=true);
					left((idler-2)/2) {
						cube([(idler-2), shaft/2+slop+motor_length/2+5, idler+2], center=true);
					}
				}
			}
		}
	}

	// Bottom motor cooling convection hole.
	fwd(motor_length/2+shaft/2) {
		right(drive_gear/2-0.5) {
			down(0.05) {
				cylinder(d=motor_width*0.75, h=motor_z+0.1, center=false);
			}
		}
	}

	// Side motor cooling convection Holes
	fwd(motor_length/2+shaft/2) {
		right(drive_gear/2-0.5) {
			up(3) trapezoid([motor_mount_spacing+joiner_width+1-2*3, motor_length/2], [motor_mount_spacing+joiner_width+1, motor_length/2], h=3.01);
			up(groove_thick) upcube([motor_mount_spacing+joiner_width+1, motor_length/2, motor_width*0.40]);
		}
	}

	// Back motor cooling convection Holes
	fwd(motor_length/2+shaft/2) {
		right(drive_gear/2-0.5) {
			front_half() {
				up(3) trapezoid([motor_width/2, motor_mount_spacing-joiner_width+1-2*3], [motor_width/2, motor_mount_spacing-joiner_width+1], h=3.01);
				up(groove_thick) upcube([motor_width/2, motor_mount_spacing-joiner_width+1, motor_width/2]);
			}
		}
	}

	// Idler compression screw threads
	up(motor_z) {
		right(drive_gear/2+1.5) {
			left(motor_mount_spacing/2+6*adjust_screw_pitch/2) {
				yrot(90) acme_threaded_rod(d=adjust_screw_diam+2*printer_slop, l=6*adjust_screw_pitch, thread_depth=adjust_thread_depth, pitch=adjust_screw_pitch, thread_angle=adjust_screw_angle);
				upcube([6*adjust_screw_pitch, adjust_screw_diam/2, adjust_screw_diam/2]);
			}
		}
	}

	// Filament feed
	cylinder(d=filament+4*slop, h=motor_z, center=false, $fn=12);
	up(motor_z-5.5-1+0.05) {
		cylinder(d1=filament+4*slop, d2=filament*3, h=2, center=true, $fn=12);
		fwd(motor_length/2/2) {
			up(2/2-0.01) upcube([filament*4, shaft/2+slop+motor_length/2+1, idler/2]);
		}
	}

	// E3Dv6 groove slot
	down(0.05) {
		hull() {
			cylinder(h=groove_thick+0.1, d=groove_diam+slop, center=false);
			fwd(motor_length/2+shaft/2) cylinder(h=groove_thick+0.1, d=groove_diam+slop, center=false);
		}
	}

	// E3Dv6 shelf slot
	up(groove_thick) {
		hull() {
			cylinder(h=shelf+cap+2*slop+0.1, d=barrel+slop, center=false);
			fwd(motor_length/2+shaft/2) cylinder(h=shelf+cap+2*slop+0.1, d=barrel+slop, center=false);
		}
	}

	// Bridging cheat for filament feed hole
	up(groove_thick+shelf+cap+2*slop) {
		upcube([barrel, filament+4*slop, 0.5+0.01]);
		up(0.5) {
			upcube([filament+4*slop, filament+4*slop, 0.5]);
		}
	}

	// Bottom idler holder
	up(groove_thick+idler_back_thick+slop/2) {
		left(idler_backside-idler_back_thick-1) {
			intersection() {
				hull() {
					yrot_copies([0,-98]) {
						teardrop(r=idler_back_thick+slop/2, h=shaft/2+slop, ang=40, $fn=36);
					}
				}
				up(idler_back_thick) {
					cube([2*idler_back_thick+slop, shaft/2+slop, 4*idler_back_thick+slop], center=true);
				}
			}
			down(idler_back_thick/3) {
				yrot_copies([0,-4,-8]) {
					left((idler_back_thick+slop/2)/2) {
						upcube([idler_back_thick+slop/2, shaft/2+slop, motor_width*0.75]);
					}
				}
			}
		}
	}

	// Locking piece clearing
	up(groove_thick) {
		fwd(shaft/2/2+motor_length/2/2-slop) {
			right(drive_gear/2-0.5-(barrel+5)/2) {
				upcube([motor_mount_spacing-joiner_width-barrel-5, motor_length/2, motor_z-groove_thick]);
			}
		}
	}
}


module extruder_platform(l, w, h, thick)
{
	side_joiner_len = 5.01;

	//color("SteelBlue")
	prerender(convexity=10)
	zrot(-90)
	union() {
		difference() {
			union() {
				difference() {
					union() {
						up(thick/2) {
							difference() {
								// Bottom.
								union() {
									yrot(90) sparse_strut(h=w-0.05, l=l-7.1, thick=thick, maxang=75, strut=10, max_bridge=500);
									cube([w, extruder_shaft_len/2, thick], center=true);
								}

								// chamfer corners of base
								xspread(w) {
									yspread(l-6.1) {
										chamfer_mask_z(l=rail_height*2, chamfer=joiner_width/3);
									}
								}
							}
						}

						// Walls.
						up((rail_height/2-5)/2-0.005) {
							xspread(w-platform_thick) {
								thinning_wall(h=rail_height/2-5-0.01, l=[l-15, l-12], thick=platform_thick, strut=5);
							}
						}

						// Joiner backing
						block_w = (w + joiner_width - z_joiner_spacing)/2;
						up(rail_height/2) {
							xflip_copy() {
								yflip_copy() {
									fwd((extruder_length-platform_thick)/2) {
										right((w-block_w)/2) {
											skew_xy(yang=-bridge_arch_angle) {
												difference() {
													cube(size=[block_w-0.1, platform_thick, rail_height], center=true);
													left(block_w/2) back(platform_thick/2) chamfer_mask_z(l=rail_height*2, chamfer=platform_thick/2);
													right(block_w/2) fwd(platform_thick/2) chamfer_mask_z(l=rail_height*2, chamfer=platform_thick/2);
												}
											}
										}
									}
								}
							}
						}

						// Joiner bracing triangles
						tri_w = platform_thick;
						tri_h = rail_height - (rail_height/2-5);
						up(rail_height/2-5-0.05) {
							xflip_copy() {
								yflip_copy() {
									fwd((extruder_length-joiner_width)/2) {
										right((w-tri_w)/2) {
											skew_xy(yang=-bridge_arch_angle) {
												zrot(90) {
													right_half() {
														trapezoid([tri_h*2, tri_w], [0.1, tri_w], h=tri_h, center=false);
													}
												}
											}
										}
									}
								}
							}
						}
					}

					// Clear space for joiners.
					zrot_copies([0, 180]) {
						back(l/2) {
							xrot(-bridge_arch_angle) {
								up(rail_height/2+0.05) {
									joiner_pair_clear(spacing=z_joiner_spacing, h=h, w=joiner_width, clearance=1, a=joiner_angle);
								}
							}
						}
					}
				}

				// Rail end joiners.
				zrot_copies([0, 180]) {
					back(l/2+0.11) {
						top_half() {
							xrot(-bridge_arch_angle) {
								up(rail_height/2) {
									joiner_pair(spacing=z_joiner_spacing, h=h, w=joiner_width, l=7, a=joiner_angle);
								}
								down(joiner_width/2) {
									xspread(z_joiner_spacing) {
										fwd(joiner_width/2) cube(joiner_width, center=true);
									}
								}
							}
						}
					}
				}
			}

			// Clear space for Side half joiners
			up(rail_height/2/2) {
				yspread((extruder_length-30-0.02)/3, n=4) {
					zring(r=w/2+side_joiner_len-0.05, n=2) {
						zrot(-90) {
							half_joiner_clear(h=rail_height/2, w=joiner_width, a=joiner_angle);
						}
					}
				}
			}
		}

		// Side half joiners
		up(rail_height/2/2) {
			yspread((extruder_length-30-0.01)/3, n=4) {
				zring(r=w/2+side_joiner_len, n=2) {
					zrot(-90) {
						chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
							half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len+platform_thick/2, a=joiner_angle);
						}
					}
				}
			}
		}
	}
}



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
