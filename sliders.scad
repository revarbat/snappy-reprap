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



module rail(l=30, w=joiner_width, h=groove_height, fillet=1.0, ang=groove_angle)
{
	difference() {
		// Rail backing.
		cube(size=[w, l, h], center=true);

		xflip_copy() {
			left(w/2) {
				up(h/2) {
					zflip() {
						xrot(90) fillet_planes_joint_mask(h=l+1, r=fillet, ang=90-ang, $fn=12);
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
				endfacets = 3;
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
rail(l=30);


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
