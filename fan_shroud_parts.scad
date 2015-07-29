include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


$fa = 1;
$fs = 2;

module fan_shroud()
{
	wall = 2;
	lip = 2;
	w = extruder_fan_size + 2*wall +2*lip;
	h = jhead_groove_thick + jhead_vent_span;
	base_thickness = jhead_shelf_thick;
	ventlen = extruder_length/4-12;

	color("lightpink")
	difference() {
		union() {
			difference() {
				up(base_thickness/2) {
					cube([w, w, base_thickness], center=true);
					left(extruder_length/4/2) {
						cube([extruder_length/4, jhead_barrel_diam, base_thickness], center=true);
					}
				}
				cylinder(h=2*base_thickness+1, r=extruder_fan_size/2, center=true);
			}
			bottom_half(99) {
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
		left(extruder_length/4-printer_slop) {
			cylinder(d=jhead_barrel_diam, h=jhead_vent_span*4, center=true);
			cube([jhead_barrel_diam*7/8, jhead_barrel_diam*2, jhead_vent_span*5], center=true);
		}
	}
}



module fan_shroud_parts() { // make me
	xrot(180) down(jhead_shelf_thick) fan_shroud();
}



fan_shroud_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
