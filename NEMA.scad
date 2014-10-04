use <GDMUtils.scad>



module nema11_stepper(h=24, shaft=5, shaft_len=20)
{
	motor_width = 28.2;
	plinth_height = 1.5;
	plinth_diam = 22;
	screw_spacing = 23.11;
	screw_size = 2.6;
	screw_depth = 3.0;

	difference() {
		color([0.4, 0.4, 0.4]) {
			translate([0, 0, -h/2]) {
				rrect(size=[motor_width, motor_width, h], r=2, center=true);
			}
		}
		grid_of(
			xa = [-screw_spacing/2, screw_spacing/2],
			ya = [-screw_spacing/2, screw_spacing/2],
			za = [-screw_depth/2+0.05]
		) {
			cylinder(r=screw_size/2, h=screw_depth, center=true, $fn=8);
		}
	}
	color("silver") {
		translate([0, 0, plinth_height/2])
			cylinder(h=plinth_height, r=plinth_diam/2, center=true);
		translate([0, 0, shaft_len/2])
			cylinder(h=shaft_len, r=shaft/2, center=true, $fn=12);
	}
}
//!nema11_stepper();



module nema14_stepper(h=24, shaft=5, shaft_len=24)
{
	motor_width = 35.2;
	plinth_height = 2;
	plinth_diam = 22;
	screw_spacing = 26;
	screw_size = 3;
	screw_depth = 4.5;

	difference() {
		color([0.4, 0.4, 0.4]) {
			translate([0, 0, -h/2]) {
				rrect(size=[motor_width, motor_width, h], r=2, center=true);
			}
		}
		grid_of(
			xa = [-screw_spacing/2, screw_spacing/2],
			ya = [-screw_spacing/2, screw_spacing/2],
			za = [-screw_depth/2+0.05]
		) {
			cylinder(r=screw_size/2, h=screw_depth, center=true, $fn=8);
		}
	}
	color("silver") {
		translate([0, 0, plinth_height/2])
			cylinder(h=plinth_height, r=plinth_diam/2, center=true);
		translate([0, 0, shaft_len/2])
			cylinder(h=shaft_len, r=shaft/2, center=true, $fn=12);
	}
}
//!nema14_stepper();



module nema17_stepper(h=34, shaft=5, shaft_len=20)
{
	motor_width = 42.3;
	plinth_height = 2;
	plinth_diam = 22;
	screw_spacing = 30.99;
	screw_size = 3;
	screw_depth = 4.5;

	difference() {
		color([0.4, 0.4, 0.4]) {
			translate([0, 0, -h/2]) {
				rrect(size=[motor_width, motor_width, h], r=2, center=true);
			}
		}
		grid_of(
			xa = [-screw_spacing/2, screw_spacing/2],
			ya = [-screw_spacing/2, screw_spacing/2],
			za = [-screw_depth/2+0.05]
		) {
			cylinder(r=screw_size/2, h=screw_depth, center=true, $fn=8);
		}
	}
	color("silver") {
		translate([0, 0, plinth_height/2])
			cylinder(h=plinth_height, r=plinth_diam/2, center=true);
		translate([0, 0, shaft_len/2])
			cylinder(h=shaft_len, r=shaft/2, center=true, $fn=12);
	}
}
//!nema17_stepper();



module nema23_stepper(h=50, shaft=6.35, shaft_len=25)
{
	motor_width = 57.0;
	plinth_height = 1.6;
	plinth_diam = 38.1;
	screw_spacing = 47.14;
	screw_size = 5.1;
	screw_depth = 4.8;

	screw_inset = motor_width - screw_spacing + 1;
	difference() {
		union() {
			color([0.4, 0.4, 0.4]) {
				translate([0, 0, -h/2]) {
					rrect(size=[motor_width, motor_width, h], r=2, center=true);
				}
			}
			color("silver") {
				translate([0, 0, plinth_height/2])
					cylinder(h=plinth_height, r=plinth_diam/2, center=true, $fn=32);
				translate([0, 0, shaft_len/2])
					cylinder(h=shaft_len, r=shaft/2, center=true, $fn=24);
			}
		}
		grid_of(
			xa = [-screw_spacing/2, screw_spacing/2],
			ya = [-screw_spacing/2, screw_spacing/2]
		) {
			translate([0, 0, -screw_depth/2+1])
				cylinder(r=screw_size/2, h=screw_depth+2, center=true, $fn=12);
			translate([0, 0, -screw_depth-h/2])
				cube(size=[screw_inset, screw_inset, h], center=true);
		}
	}
}
//!nema23_stepper();



module nema34_stepper(h=75, shaft=12.7, shaft_len=32)
{
	motor_width = 86;
	plinth_height = 2.03;
	plinth_diam = 73.0;
	screw_spacing = 69.6;
	screw_size = 5.5;
	screw_depth = 9;

	screw_inset = motor_width - screw_spacing + 1;
	difference() {
		union() {
			color([0.4, 0.4, 0.4]) {
				translate([0, 0, -h/2]) {
					rrect(size=[motor_width, motor_width, h], r=2, center=true);
				}
			}
			color("silver") {
				translate([0, 0, plinth_height/2])
					cylinder(h=plinth_height, r=plinth_diam/2, center=true, $fn=32);
				translate([0, 0, shaft_len/2])
					cylinder(h=shaft_len, r=shaft/2, center=true, $fn=24);
			}
		}
		grid_of(
			xa = [-screw_spacing/2, screw_spacing/2],
			ya = [-screw_spacing/2, screw_spacing/2]
		) {
			translate([0, 0, -screw_depth/2+1])
				cylinder(r=screw_size/2, h=screw_depth+2, center=true, $fn=12);
			translate([0, 0, -screw_depth-h/2])
				cube(size=[screw_inset, screw_inset, h], center=true);
		}
	}
}
//!nema34_stepper();



module nema17_mount_holes(depth=5, len=5)
{
	plinth_diam = 22;
	screw_spacing = 30.99;
	screw_size = 3;

	union() {
		grid_of(
			xa=[-screw_spacing/2, screw_spacing/2],
			ya=[-screw_spacing/2, screw_spacing/2]
		) {
			hull() {
				translate([0, -len/2, 0]) 
					cylinder(h=depth, r=screw_size/2, center=true, $fn=8);
				translate([0, len/2, 0]) 
					cylinder(h=depth, r=screw_size/2, center=true, $fn=8);
			}
		}
	}
	hull() {
		translate([0, -len/2, 0]) 
			cylinder(h=depth, r=plinth_diam/2, center=true);
		translate([0, len/2, 0]) 
			cylinder(h=depth, r=plinth_diam/2, center=true);
	}
}
//!nema17_mount_holes(depth=5, len=5);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

