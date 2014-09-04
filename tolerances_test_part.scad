include <config.scad>
use <GDMUtils.scad>
use <z_nut_cap_part.scad>
use <nut_capture.scad>



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
			assign(d = floor(abs(val)/pow(10, p)) % 10) {
				if (p == -1) {
					translate([-0.8*size/2, -size/2, 0])
						cube(size=[size*0.1, size*0.1, h], center=true);
				}
				digit_seven_segment(digit=d, size=size, h=h);
			}
		}
	}
}




module tolerances_test_part() { // make me
	for (i = [0:5]) {
		translate([-20*i, 0, 0])
			zrot(90)
				difference() {
					nut_capture(
						nut_size=lifter_nut_size,
						nut_thick=lifter_nut_thick,
						offset=lifter_nut_size/2+5,
						wall=3,
						slop=0.05*i
					);
					translate([lifter_nut_size/2+3, -6, 10]) {
						zrot(90) xrot(90) float_seven_segment(val=0.05*i, decim=2, size=8, h=1, suppress=true);
					}
				}
	}
	translate([ 20, 0, 2]) yrot(180) zrot(90) z_nut_cap();
}



tolerances_test_part();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

