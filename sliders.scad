include <config.scad>
use <GDMUtils.scad>


module slider(l=30, w=joiner_width, h=groove_height, base=10, wall=5, ang=groove_angle, slop=0.2)
{
	w = w + 2*wall;
	h = h + base;

	difference() {
		// Overall slider shell
		up(h/2) cube([joiner_width+2*wall, l, h], center=true);

		up(base-printer_slop) {
			// Clear slider gap
			up((groove_height+5)/2) {
				cube([joiner_width+slop, l+1, groove_height+5], center=true);
			}

			// Horiz edge bevel
			yspread(l) {
				scale([1, 1, tan(30)]) {
					xrot(45) cube([joiner_width+slop, 2*sqrt(2), 2*sqrt(2)], center=true);
				}
			}
		}

		// Back top bevel
		up(h) {
			xspread(w) {
				yrot(45) {
					cube([wall/2*sqrt(2), l+1, wall/2*sqrt(2)], center=true);
				}
			}
		}
	}
	up(base) {
		up(groove_height/2) {
			xflip_copy() {
				left((joiner_width+slop)/2) {
					difference() {
						// Rails
						right_half() {
							scale([tan(ang), 1, 1]) {
								yrot(45) cube([groove_height*sin(45), l, groove_height*sin(45)], center=true);
							}
						}

						// Rail bevels
						yflip_copy() {
							right(sqrt(2)*groove_height/2) {
								fwd(l/2) {
									zrot(45) cube(groove_height, center=true);
								}
							}
						}
					}
				}
			}
		}
	}
}
//slider(l=30, base=10, wall=4, slop=0.2);



module rail(l=30, w=joiner_width, h=groove_height, chamfer=1.0, ang=groove_angle)
{
	attack_ang = 30;
	attack_len = 2;

	fudge = 1.177;
	chamf = sqrt(2) * chamfer;
	cosa = cos(ang*fudge);
	sina = sin(ang*fudge);

	z1 = h/2;
	z2 = z1 - chamf * cosa;
	z3 = z1 - attack_len * sin(attack_ang);
	z4 = 0;

	x1 = w/2;
	x2 = x1 - chamf * sina;
	x3 = x1 - chamf;
	x4 = x1 - attack_len * sin(attack_ang);
	x5 = x2 - attack_len * sin(attack_ang);
	x6 = x1 - z1 * sina;
	x7 = x4 - z1 * sina;

	y1 = l/2;
	y2 = y1 - attack_len * cos(attack_ang);

	polyhedron(
		convexity=4,
		points=[
			[-x5, -y1,  z3],
			[ x5, -y1,  z3],
			[ x7, -y1,  z4],
			[ x4, -y1, -z1-0.05],
			[-x4, -y1, -z1-0.05],
			[-x7, -y1,  z4],

			[-x3, -y2,  z1],
			[ x3, -y2,  z1],
			[ x2, -y2,  z2],
			[ x6, -y2,  z4],
			[ x1, -y2, -z1-0.05],
			[-x1, -y2, -z1-0.05],
			[-x6, -y2,  z4],
			[-x2, -y2,  z2],

			[ x5,  y1,  z3],
			[-x5,  y1,  z3],
			[-x7,  y1,  z4],
			[-x4,  y1, -z1-0.05],
			[ x4,  y1, -z1-0.05],
			[ x7,  y1,  z4],

			[ x3,  y2,  z1],
			[-x3,  y2,  z1],
			[-x2,  y2,  z2],
			[-x6,  y2,  z4],
			[-x1,  y2, -z1-0.05],
			[ x1,  y2, -z1-0.05],
			[ x6,  y2,  z4],
			[ x2,  y2,  z2],
		],
		faces=[
			[0, 1, 2],
			[0, 2, 5],
			[2, 3, 4],
			[2, 4, 5],

			[0, 13, 6],
			[0, 6, 7],
			[0, 7, 1],
			[1, 7, 8],
			[1, 8, 9],
			[1, 9, 2],
			[2, 9, 10],
			[2, 10, 3],
			[3, 10, 11],
			[3, 11, 4],
			[4, 11, 12],
			[4, 12, 5],
			[5, 12, 13],
			[5, 13, 0],

			[14, 15, 16],
			[14, 16, 19],
			[16, 17, 18],
			[16, 18, 19],

			[14, 27, 20],
			[14, 20, 21],
			[14, 21, 15],
			[15, 21, 22],
			[15, 22, 23],
			[15, 23, 16],
			[16, 23, 24],
			[16, 24, 17],
			[17, 24, 25],
			[17, 25, 18],
			[18, 25, 26],
			[18, 26, 19],
			[19, 26, 27],
			[19, 27, 14],

			[6, 21, 20],
			[6, 20, 7],
			[7, 20, 27],
			[7, 27, 8],
			[8, 27, 26],
			[8, 26, 9],
			[9, 26, 25],
			[9, 25, 10],
			[10, 25, 24],
			[10, 24, 11],
			[11, 24, 23],
			[11, 23, 12],
			[12, 23, 22],
			[12, 22, 13],
			[13, 22, 21],
			[13, 21, 6],
		]
	);
}
//!rail(l=30, w=joiner_width, h=groove_height);


module old_rail(l=30, w=joiner_width, h=groove_height, fillet=1.0, ang=groove_angle)
{
	difference() {
		// Rail backing.
		down(0.05/2) cube(size=[w, l, h+0.05], center=true);

		xflip_copy() {
			left(w/2) {
				up(h/2) {
					zflip() {
						xrot(90) fillet_planes_joint_mask(h=l+1, r=fillet, ang=90-ang, $fn=6);
					}
				}
			}
		}

		// Rail grooves.
		xflip_copy() {
			right(w/2) {
				// main groove
				scale([tan(ang),1,1]) yrot(45) {
					cube(size=[h*sqrt(2)/2,l+1,h*sqrt(2)/2], center=true);
				}

				// fillets
				endfacets = 1;
				facelen = h/2/cos(ang);
				inset = h/2*tan(ang);
				yflip_copy() {
					fwd(l/2) {
						scale([1, 2, 1]) {
							up(h/2) {
								// top end fillets
								difference() {
									cube([w*2, fillet*2, fillet*2], center=true);
									back(fillet) down(fillet) {
										yrot(90) cylinder(r=fillet, h=w*3, center=true, $fn=endfacets*4);
									}
								}

								// top corner end fillets
								down(fillet/sin(ang)) {
									yrot(45+ang/2) {
										difference() {
											cube([w*2, fillet*2, fillet*2], center=true);
											back(fillet) down(fillet) {
												yrot(90) cylinder(r=fillet, h=w*3, center=true, $fn=endfacets*4);
											}
										}
									}
								}
							}

							// groove fillets
							left(inset) {
								difference() {
									zflip_copy() {
										left(fillet/cos(ang)) {
											yrot(-ang) {
												right(fillet) {
													down(facelen*1.5/2) {
														cube([fillet*2, fillet*2, facelen*1.5], center=true);
													}
												}
											}
										}
									}
									zflip_copy() {
										left(fillet/cos(ang)) {
											yrot(-ang) {
												right(fillet) {
													down(facelen) {
														back(fillet) left(fillet) {
															cylinder(r=fillet, h=facelen*3, center=true, $fn=endfacets*4);
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}


/*
difference() {
	rail(l=30, w=joiner_width, h=groove_height, chamfer=1.0, ang=groove_angle);
	old_rail(l=30, w=joiner_width, h=groove_height, fillet=1.0, ang=groove_angle);
}
*/


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
