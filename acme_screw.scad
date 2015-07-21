include <config.scad>
use <GDMUtils.scad>


// Constructs an acme threaded screw rod.  This method makes much
//  smoother threads than the naive linear_extrude method.
module acme_threaded_rod(
	d=10.5,
	l=100,
	pitch=3.175,
	thread_depth=1,
	thread_angle=14.5
) {
	astep = 360/segs(d/2);
	asteps = ceil(360/astep);
	threads = ceil(l/pitch)+2;
	pa_delta = (thread_depth*1.25)*sin(thread_angle)/2;
	poly_points = [
		for (
			thread = [0 : threads-1],
			astep = [0 : asteps-1],
			i = [0 : 3]
		) let (
			r = max(0, d/2 - ((i==1||i==2)? 0 : (thread_depth*1.25))),
			a = astep / asteps,
			rx = r * cos(360 * a),
			ry = r * sin(360 * a),
			tz = (thread + a - threads/2 + (i<2? -0.25 : 0.25)) * pitch + (i%2==0? -pa_delta : pa_delta)
		) [rx, ry, tz]
	];
	point_count = len(poly_points);
	poly_faces = concat(
		[
			for (thread = [0 : threads-1])
			for (astep = [0 : asteps-1])
			for (j = [0 : 3])
			for (i = [0 : 1])
			let(
				p0 = (thread*asteps + astep)*4 + j,
				p1 = p0 + 4,
				p2 = (thread*asteps + astep)*4 + ((j+1)%4),
				p3 = p2 + 4,
				tri = (i==0? [p0, p3, p1] : [p0, p2, p3])
			)
			if (p0 < point_count-4) tri
		],
		[
			[0, 3, 2],
			[0, 2, 1],
			[point_count-4, point_count-3, point_count-2],
			[point_count-4, point_count-2, point_count-1]
		]
	);
	intersection() {
		union() {
			polyhedron(points=poly_points, faces=poly_faces, convexity=10);
			cylinder(h=(threads+0.5)*pitch, d=d-2*thread_depth, center=true);
		}
		cube([d+1, d+1, l], center=true);
	}
}
//!acme_threaded_rod(d=3/8*25.4, l=20, pitch=1/8*25.4, thread_depth=1.3, thread_angle=29, $fn=32);


module acme_threaded_nut(
	od=17.4,
	id=10.5,
	h=10,
	pitch=3.175,
	thread_depth=1,
	slop=printer_slop
) {
	difference() {
		cylinder(r=od/2/cos(30), h=h, center=true, $fn=6);
		zspread(slop) {
			acme_threaded_rod(d=id+2*slop, l=h+1, pitch=pitch, thread_depth=thread_depth);
		}
	}
}


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
