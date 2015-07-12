include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rail_endcap()
{
	joiner_length=30;
	base_height = rail_height+groove_height;

	color("YellowGreen")
	prerender(convexity=10)
	difference() {
		union() {
			difference() {
				union() {
					// Bottom.
					translate([0, -joiner_length/2, rail_thick/2])
						cube(size=[rail_width, joiner_length, rail_thick], center=true);

					// Back.
					translate([0, -joiner_length+rail_thick/2, base_height/2]) zrot(90) {
						if (wall_style == "crossbeams")
							sparse_strut(h=base_height, l=rail_width-2*5, thick=rail_thick, strut=5);
						if (wall_style == "thinwall")
							thinning_wall(h=base_height, l=rail_width-joiner_width, thick=rail_thick, strut=joiner_width, bracing=false);
						if (wall_style == "corrugated")
							corrugated_wall(h=base_height, l=rail_width, thick=rail_thick, strut=joiner_width);
					}

					// Corner pieces.
					up(base_height) {
						xspread(rail_spacing+joiner_width) {
							down((base_height-rail_height)/2) {
								fwd(joiner_length/2) {
									cube(size=[joiner_width, joiner_length, (base_height-rail_height)], center=true);
								}
							}
						}
					}

					// Limit switch standoffs
					xflip_copy() {
						left(rail_width/2-joiner_width) {
							up(rail_height+groove_height-endstop_hole_hoff) {
								fwd(endstop_hole_inset) {
									zspread(endstop_hole_spacing) {
										yrot(90) {
											cylinder(
												r1=endstop_screw_size*1.1/2/cos(30)+0.5+endstop_standoff,
												r2=endstop_screw_size*1.1/2/cos(30)+0.5,
												h=endstop_standoff+0.05,
												center=true,
												$fn=24
											);
										}
									}
								}
							}
						}
					}
				}

				// Filament feed hole
				fwd(joiner_length/2) {
					up(rail_thick/2) {
						cylinder(h=rail_thick, d=1/4*25.4, center=true, $fn=24);
						zflip_copy(offset=rail_thick/2+0.05) {
							fillet_hole_mask(r=1/4*25.4/2, fillet=rail_thick/3, $fn=24);
						}
					}
				}

				// Clear space for joiners.
				translate([0, 0, base_height/2-(base_height-rail_height)/2]) {
					joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, a=joiner_angle, clearance=5);
				}
			}

			// Joiner clips.
			translate([0, 0, base_height/2-(base_height-rail_height)/2]) {
				joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=joiner_length, a=joiner_angle);
			}
		}

		// Limit switch mount holes.
		xflip_copy() {
			left((rail_width-joiner_width)/2) {
				up(rail_height+groove_height-endstop_hole_hoff) {
					fwd(endstop_hole_inset) {
						zspread(endstop_hole_spacing) {
							yrot(90) cylinder(r=endstop_screw_size*1.1/2, h=joiner_width+2*endstop_standoff+0.1, center=true, $fn=12);
							left(joiner_width/2+0.05) {
								yrot(90) zrot(90) metric_nut(size=endstop_screw_size);
							}
						}
					}
				}
			}
		}
	}
}
//!rail_endcap();



module rail_endcap_parts() { // make me
	zrot(-90) rail_endcap();
}


rail_endcap_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

