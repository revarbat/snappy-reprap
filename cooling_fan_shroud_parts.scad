include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 1;
$fs = 2;

tilt = 15;
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
								up((cooling_fan_thick+wall)/2) {
									difference() {
										rrect([cooling_fan_size+2*wall, cooling_fan_size+2*wall, duct_h+cooling_fan_thick+wall], r=10, center=true);
										up(duct_h/2+0.05) {
											zrot(45) {
												difference() {
													cube([cooling_fan_size*3, cooling_fan_size*3, cooling_fan_thick+wall], center=true);
													cube([cooling_fan_size, cooling_fan_size, cooling_fan_thick+wall], center=true);
												}
											}
										}
									}
								}
								yrot(-90) zrot(90) teardrop(r=cooling_fan_size/2+wall, h=duct_h, ang=duct_ang);
							}
							up((duct_h+cooling_fan_thick+wall)/2+0.05) {
								trapezoid([cooling_fan_size, cooling_fan_size], [cooling_fan_size-0.5, cooling_fan_size-0.5], h=cooling_fan_thick+wall, center=true);
							}
							yrot(-90) zrot(90) teardrop(r=cooling_fan_size/2, h=duct_h-2*wall, ang=duct_ang);
						}
						zring(r=cooling_fan_size/2+wall/2+0.05, n=20) {
							cube([wall, wall, duct_h], center=true);
						}
					}
					intersection() {
						right(8.5) {
							up(duct_h/2-2/2) {
								xspread(10,n=5) {
									cube([2, cooling_fan_size, wall+0.6], center=true);
								}
							}
						}
						right((cooling_fan_size+2*wall)/2-rail_height/2/2+extruder_fan_size) {
							yrot(-90) zrot(90) teardrop(r=cooling_fan_size/2+wall, h=duct_h, ang=duct_ang);
						}
					}
					left(cooling_fan_size*2) {
						zrot_copies([-3.4, 3.4]) {
							right(cooling_fan_size*2) {
								trapezoid([cooling_fan_size*2, wall], [cooling_fan_size*1.5, wall*2], h=duct_h-wall/2, center=true);
							}
						}
					}
				}
			}
			left(rail_height/2/2) {
				left(200/2) cube(200, center=true);
				down(duct_h+6) {
					yrot(45) {
						cube([sqrt(2)*(duct_h-wall), exit_width+3*wall, sqrt(2)*(duct_h-wall)], center=true);
					}
				}
			}
			down(6+duct_h/2) {
				right((cooling_fan_size+2*wall)/2-rail_height/2/2+extruder_fan_size) {
					up((wall+cooling_fan_thick+wall)/2+0.05) {
						cylinder(h=duct_h+cooling_fan_thick+wall-wall+0.05, d=cooling_fan_size, center=true);
					}
				}
			}
		}
	}
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
