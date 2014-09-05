use <GDMUtils.scad>

module nut_capture(nut_size=17.4, nut_thick=9.5, offset=18, slop=0.25, wall=3)
{
	nut_rad = nut_size/cos(30)/2;
	base = (offset - nut_rad);
	h = nut_rad*2 + base;
	w = nut_thick + wall*2;
	l = nut_size + wall*2;

	difference() {
		// Outer shell.
		translate([0, 0, h/2])
			cube(size=[l, w, h], center=true);

		translate([0, 0, base+nut_rad]) {
			// Nut slot.
			hull() {
				grid_of(za=[0, h]) {
					zrot(90) yrot(90) {
						cylinder(h=nut_thick+slop*2, r=nut_rad+slop, center=true, $fn=6);
					}
				}
			}
		
			// Rod access.
			hull() {
				grid_of(za=[0, h]) {
					zrot(90) yrot(90) {
						cylinder(h=w+1, r=nut_size/2-1, center=true, $fn=24);
					}
				}
			}
		}

		// Snap hole.
		translate([0, 0, h-3])
			cube(size=[l+1, nut_thick/2, 1.5], center=true);
	}
}
//!nut_capture(nut_size=17.4, nut_thick=9.5);



module nut_capture_cap(nut_size=17.4, nut_thick=9.5, wall=3, cap_thick=2)
{
	nut_rad = nut_size/cos(30)/2;
	h = nut_rad/2;
	l = nut_size + wall*2;
	w = nut_thick + wall*2;

	color("DeepSkyBlue") union() {
		// cap
		translate([0, 0, cap_thick/2])
			cube(size=[l, w, cap_thick], center=true);

		difference() {
			// Plug
			union() {
				translate([0, 0, -h/2])
					cube(size=[nut_size, nut_thick, h], center=true);
				translate([0, 0, -h/2])
					cube(size=[nut_size-2, w, h], center=true);
			}

			// Remove nut area.
			translate([0, 0, -nut_rad]) {
				zrot(90) yrot(90) {
					cylinder(h=nut_thick+1, r=nut_rad, center=true, $fn=6);
				}
			}

			// Remove Rod access.
			translate([0, 0, -nut_rad]) {
				zrot(90) yrot(90) {
					cylinder(h=w+1, r=nut_size/2-1, center=true, $fn=24);
				}
			}
		}

		// Snap ridges
		grid_of(
			xa=[-nut_size/2, nut_size/2],
			za=[-3]
		) {
			scale([2.0, nut_thick/2-1, 3.0])
				yrot(45) cube(size=[1/sqrt(2), 1, 1/sqrt(2)], center=true);
		}
	}
}
!nut_capture_cap(nut_size=17.4, nut_thick=9.5);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

