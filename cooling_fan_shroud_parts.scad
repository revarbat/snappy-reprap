include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 2;
$fs = 2;

tilt = 10;
duct_h = cooling_duct_height - 8;

module cooling_fan_shroud()
{
	wall = 2;
	exit_width = 20;
	duct_ang = atan2(cooling_fan_size/2-exit_width/2, cooling_fan_size/2+extruder_fan_size);

	color("lightblue")
	yrot(-tilt) {
		difference() {
			union() {
				// Top joiner
				difference() {
					rotate([90+tilt, 0, 90]) {
						prerender(convexity=8) {
							half_joiner(h=rail_height/2, w=joiner_width, l=rail_height/2, a=joiner_angle);
						}
					}
					down(rail_height/2+6+wall/2) {
						cube(rail_height, center=true);
					}
				}

				down(6+duct_h/2) {
					right((cooling_fan_size+2*wall)/2-rail_height/2/2+extruder_fan_size) {
						difference() {
							union() {
								up((cooling_fan_thick)/2) {
									difference() {
										rrect([cooling_fan_size+2*wall, cooling_fan_size+2*wall, duct_h+cooling_fan_thick], r=10, center=true);
										up(duct_h/2+0.05) {
											zrot(45) {
												difference() {
													cube([cooling_fan_size*3, cooling_fan_size*3, cooling_fan_thick], center=true);
													cube([cooling_fan_size, cooling_fan_size, cooling_fan_thick+1], center=true);
												}
											}
										}
									}
								}
								yrot(-90) zrot(90) teardrop(r=cooling_fan_size/2+wall, h=duct_h, ang=duct_ang);
							}

							// Clear fan clip
							up((duct_h+cooling_fan_thick+wall)/2+0.05) {
								trapezoid([cooling_fan_size, cooling_fan_size], [cooling_fan_size-0.5, cooling_fan_size-0.5], h=cooling_fan_thick+wall, center=true);
							}

							// Clear horiz duct
							yrot(-90) zrot(90) teardrop(r=cooling_fan_size/2-1, h=duct_h-wall, ang=duct_ang);
						}
					}

					// duct supports
					left(cooling_fan_size*2) {
						zrot_copies([-3.8, 3.8]) {
							right(cooling_fan_size*2) {
								cube(size=[cooling_fan_size*2, wall, duct_h], center=true);
							}
						}
					}
				}

				// down-angle tip
				left(rail_height/2/2-3) {
					down(duct_h-wall+0.5) {
						trapezoid(size1=[1, exit_width+2*wall], size2=[duct_h*2, exit_width+2*wall], h=duct_h/2, center=true);
					}
				}
			}

			// Truncate exit tip
			left(rail_height/2/2) {
				left(200/2) cube(200, center=true);
				down(duct_h+6) {
					yrot(45) {
						cube([sqrt(2)*(duct_h-wall), exit_width+4*wall, sqrt(2)*(duct_h-wall)], center=true);
					}
				}
			}

			// Clear vertical fan duct
			down(6+duct_h/2) {
				right((cooling_fan_size+2*wall)/2-rail_height/2/2+extruder_fan_size) {
					up((wall+cooling_fan_thick+wall)/2+0.05) {
						zrot(360/8/2) cylinder(h=duct_h+cooling_fan_thick+wall+0.05, d=cooling_fan_size/cos(360/8/2)-2, center=true, $fn=8);
					}
				}
			}
		}
	}

	// Fan
	yrot(-tilt) {
		down(6+duct_h/2) {
			right((cooling_fan_size+2*wall)/2-rail_height/2/2+extruder_fan_size) {
				up((cooling_fan_thick)/2-wall) {
					children();
				}
			}
		}
	}
}



module cooling_fan_shroud_parts() { // make me
	up(duct_h+6) {
		yrot(tilt) cooling_fan_shroud();
	}
}



cooling_fan_shroud_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
