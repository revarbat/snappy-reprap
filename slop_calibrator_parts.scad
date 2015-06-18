use <GDMUtils.scad>



module digit_seven_segment(digit=0, size=10, h=1)
{
	segs = [
		[1, 1, 1, 1, 1, 0, 0, 1, 1, 1],
		[1, 1, 0, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 1, 1, 0, 1, 1, 0, 1, 1],
		[1, 0, 1, 0, 0, 0, 1, 0, 1, 0],
		[1, 0, 0, 0, 1, 1, 1, 0, 1, 1],
		[1, 0, 1, 1, 0, 1, 1, 1, 1, 1],
		[0, 0, 1, 1, 1, 1, 1, 0, 1, 1]
	];
	rots = [0, 0, 90, 0, 0, 90, 90];
	offs = [[0.5, 0.5], [0.5, -0.5], [0.0, -1.0], [-0.5, -0.5], [-0.5, 0.5], [0.0, 1.0], [0.0, 0.0]];
	for (i = [0:6]) {
		if (segs[i][digit] != 0) {
			scale([size/2, size/2, h]) {
				translate([offs[i][0], offs[i][1], 0]) {
					rotate([0, 0, rots[i]]) {
						cube(size=[0.25, 1.0, 1.0], center=true);
					}
				}
			}
		}
	}
}



module float_seven_segment(val=0.0, decim=2, size=10, h=1, suppress=false)
{
	mag = max(floor(log(abs(val))), suppress?-1:0);
	if (val < 0.0) {
		translate([-0.8*size*(mag+1.5), 0, 0]) {
			cube(size=[size/2, size*0.1, h], center=true);
		}
	}
	for (p = [mag:-1:-decim]) {
		translate([-0.8*size*(p+0.5), 0, 0]) {
			d = floor(abs(val)/pow(10, p)+0.000001) % 10;
			if (p == -1) {
				translate([-0.8*size/2, -size/2, 0])
					cube(size=[size*0.1, size*0.1, h], center=true);
			}
			digit_seven_segment(digit=d, size=size, h=h);
		}
	}
}




module slop_calibrator_parts() { // make me
	rows = 5;
	cols = 2;
	r = 5;
	h = 15;
	step = 0.05;
	spacing = r*2+10;
	for (col = [0:cols-1]) {
		translate([-col*spacing*1.25+(cols-1)*spacing*1.25/2, 0, h/2]) {
			difference() {
				cube(size=[spacing, rows*spacing, h], center=true);
				for (row = [0:rows-1]) {
					slop = (step*rows*col)+step*row;
					translate([0, spacing*row-(rows-1)*spacing/2, 0]) {
						cube(size=[(r+slop)*2, (r+slop)*2, h+1], center=true);
						translate([spacing/2, -7, 0]) {
							zrot(90) xrot(90) float_seven_segment(val=slop, decim=2, size=8, h=1, suppress=true);
						}
					}
				}
			}
		}
	}
	translate([(cols+1)*1.25*spacing/2, 0, h/2]) {
		cube(size=[r*2, r*2, h], center=true);
		translate([0,0,-h/4])
			cube(size=[(r+2)*2, (r+2)*2, h/2], center=true);
	}
}



slop_calibrator_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

