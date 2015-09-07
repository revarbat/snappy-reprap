include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 2;
$fs = 2;

module extruder_fan_shroud()
{
	wall = 2;
	lip = 2;
	w = extruder_fan_size + 2*wall + 2*lip;
	h = jhead_groove_thick + jhead_vent_span - 2;
	base_thickness = jhead_shelf_thick;
	ventlen = extruder_length/4-12;

	color("lightpink")
	difference() {
		union() {
			difference() {
				union() {
					difference() {
						up(base_thickness/2) {
							cube([w, w, base_thickness], center=true);
							left(extruder_length/4/2) {
								cube([extruder_length/4, w, base_thickness], center=true);
							}
						}
						cylinder(h=2*base_thickness+1, r=extruder_fan_size/2, center=true);
					}
					up(0.05) {
						bottom_half(extruder_fan_size*1.5) {
							difference() {
								union() {
									zflip() onion(h=(h+wall), r=(extruder_fan_size+2*wall)/2, maxang=35);
									left(ventlen/2) {
										chamfcube([ventlen, jhead_groove_diam, 2*(h+wall)], chamfer=sqrt(2)*wall, chamfaxes=[1,0,0], center=true);
									}
								}
								zflip() onion(h=h, r=extruder_fan_size/2, maxang=35);
								left((ventlen+10)/2) {
									chamfcube([ventlen+10, jhead_groove_diam-2*wall, 2*h], chamfer=wall, center=true);
								}
							}
						}
					}
				}

				// Bottom joiner clearance
				left(w/8) {
					down(h+5+wall) {
						yrot(-90) zrot(90) half_joiner_clear(h=rail_height/2, w=joiner_width, a=joiner_angle);
					}
				}
			}

			// Bottom joiner
			left(w/8) {
				down(h+5+wall) {
					yrot(-90) {
						zrot(90) {
							half_joiner2(h=rail_height/2, w=joiner_width, l=5+wall, a=joiner_angle);
						}
					}
				}
			}
		}
		left(extruder_length/4-printer_slop) {
			cylinder(d=jhead_barrel_diam, h=jhead_vent_span*4, center=true);
			cube([jhead_barrel_diam*6/8+2*printer_slop, w+1, jhead_vent_span*5], center=true);
		}
	}
	left(w/8) {
		down(h+5+wall) {
			children();
		}
	}
}



module extruder_fan_shroud_parts() { // make me
	xrot(180) down(jhead_shelf_thick) extruder_fan_shroud();
}



extruder_fan_shroud_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
