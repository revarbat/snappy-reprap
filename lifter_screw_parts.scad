include <config.scad>
use <GDMUtils.scad>
use <acme_screw.scad>

$fa=2;
$fs=2;

// Constructs a sine-wave threaded screw rod.  This method makes much
//  smoother threads than the naive linear_extrude method.
module wave_threaded_rod(
	d=10.5,
	l=100,
	pitch=3.175,
	thread_depth=1,
	vsteps=12
) {
	asteps = segs(d/2);
	zsteps = ceil(l/(pitch/vsteps)+1);
	poly_points = concat(
		[
			for (
				z = [0 : zsteps-1],
				astep = [0 : asteps-1]
			) let (
				va = (360 * z / vsteps) % 360,
				ra = 360 * astep / asteps,
				rx = 0.5 * d * cos(ra) + 0.5 * thread_depth * cos(va),
				ry = 0.5 * d * sin(ra) + 0.5 * thread_depth * sin(va),
				vz = z * pitch / vsteps - l / 2
			) [rx, ry, vz]
		],
		[[0, 0, -l/2], [0, 0, l/2]]
	);
	point_count = len(poly_points);
	pt_cnt = asteps * zsteps;
	poly_faces = concat(
		[for (astep = [0 : asteps-1]) [astep, (astep+1)%asteps, pt_cnt]],
		[for (astep = [0 : asteps-1]) [pt_cnt-astep-1, pt_cnt-(astep+1)%asteps-1, pt_cnt+1]],
		[
			for (
				v = [0 : zsteps-2],
				astep = [0 : asteps-1],
				i = [0 : 1]
			) let (
				p0 = v*asteps + astep,
				p1 = (v+1)*asteps + astep,
				p2 = (v+1)*asteps + ((astep+1) % asteps),
				p3 = v*asteps + ((astep+1) % asteps),
				tri = (i==0? [p0, p1, p2] : [p0, p2, p3])
			) tri
		]
	);
	intersection() {
		polyhedron(points=poly_points, faces=poly_faces, convexity=10);
		cube([d+2*thread_depth, d+2*thread_depth, l], center=true);
	}
}
//!wave_threaded_rod(d=60, l=10, pitch=5, thread_depth=2);


module lifter_screw(d=50, h=10, thread_depth=3, pitch=10, hole=30) {
	up (h/2) {
		difference() {
			zrot(130) acme_threaded_rod(d=d, l=h, thread_depth=thread_depth, pitch=pitch, thread_angle=45);
			difference() {
				cylinder(h=h+0.1, d=motor_shaft_size+printer_slop, center=true, $fn=24);
				if (motor_shaft_flatted) {
					left(motor_shaft_size-0.5) {
						cube(size=[motor_shaft_size, motor_shaft_size, h], center=true);
					}
				}
			}
			up(3) {
				difference() {
					cylinder(h=h+0.1, d=d-2*thread_depth-5, center=true);
					cylinder(h=h+0.1, d=motor_shaft_size+15, center=true);
				}
			}
			down(h/2-2/2) {
				cylinder(h=2+0.05, d1=motor_shaft_size+2, d2=motor_shaft_size, center=true);
			}
			up(h/2-3) {
				left(motor_shaft_size/2+2) {
					hull() {
						up(h/4/2) {
							zspread(h/4) {
								scale([1.1, 1.1, 1.1]) {
									zrot(180) yrot(90) metric_nut(size=set_screw_size, hole=false);
								}
							}
						}
					}
				}
				yrot(-90) cylinder(h=150, d=set_screw_size*1.05, center=false, $fn=12);
			}
		}
	}
}
//!lifter_screw(d=20, h=20, thread_depth=3, pitch=8);

module lifter_screw_parts() { // make me
	lifter_screw(d=60, h=16, thread_depth=3, pitch=8);
}
lifter_screw_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
