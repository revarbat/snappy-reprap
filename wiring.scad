use <GDMUtils.scad>


// Generate bezier curve to fillet 2 line segments between 3 points.
// Returns two path points with surrounding cubic bezier control points.
function fillet3pts(p0, p1, p2, r) = let(
		v0 = normalize(p0-p1),
		v1 = normalize(p2-p1),
		a = vector3d_angle(v0,v1),
		mr = min(distance(p0,p1), distance(p2,p1))*0.9,
		tr = min(r/tan(a/2), mr),
		tp0 = p1+v0*tr,
		tp1 = p1+v1*tr,
		w=-2.7e-5*a*a + 8.5e-3*a - 3e-3,
		nw=max(0, w),
		cp0 = tp0+nw*(p1-tp0),
		cp1 = tp1+nw*(p1-tp1)
	) [tp0, tp0, cp0, cp1, tp1, tp1];


// Takes a 3D polyline path and fillets it into a 3d cubic bezier path.
function fillet_path(pts, fillet) = concat(
	[pts[0], pts[0]],
	(len(pts) < 3)? [] : [
		for (
			p = [1 : len(pts)-2],
			pt = fillet3pts(pts[p-1], pts[p], pts[p+1], fillet)
		) pt
	],
	[pts[len(pts)-1], pts[len(pts)-1]]
);




// Returns an array of 1 or 6 points that form a ring, based on wire diam and ring level.
// Level 0 returns a single point at 0,0.  All greater levels return 6 points.
function hex_offset_ring(wirediam, lev=0) =
	(lev == 0)? [[0,0]] : [
		for (
			sideang = [0:60:359.999],
			sidewire = [1:lev]
		) [
			lev*wirediam*cos(sideang)+sidewire*wirediam*cos(sideang+120),
			lev*wirediam*sin(sideang)+sidewire*wirediam*sin(sideang+120)
		]
	];


// Returns an array of 2D centerpoints for each of a bundle of wires of given diameter.
// The lev and arr variables are used for internal recursion.
function hex_offsets(wires, wirediam, lev=0, arr=[]) =
	(len(arr) >= wires)? arr :
		hex_offsets(
			wires=wires,
			wirediam=wirediam,
			lev=lev+1,
			arr=concat(arr, hex_offset_ring(wirediam, lev=lev))
		);


// Returns a 3D object representing a bundle of wires that follow a given path,
// with the corners filleted to a given radius.  There are 17 base wire colors.
// If you have more than 17 wires, colors will get re-used.
// Arguments:
//   path:     The 3D polyline path that the wire bundle should follow.
//   wires:    The number of wires in the wiring bundle.
//   wirediam: The diameter of each wire in the bundle.
//   fillet:   The radius that the path corners will be filleted to.
//   wirenum:  The first wire's offset into the color table.
//   bezsteps: The corner fillets in the path will be converted into this number of segments.
// Usage:
//   wiring([[50,0,-50], [50,50,-50], [0,50,-50], [0,0,-50], [0,0,0]], fillet=10, wires=13);
module wiring(path, wires, wirediam=2, fillet=10, wirenum=0, bezsteps=3) {
	vect = path[1]-path[0];
	theta = atan2(vect[1], vect[0]);
	xydist = hypot(vect[1], vect[0]);
	phi = atan2(vect[2],xydist);
	colors = [
		[0.2, 0.2, 0.2], [1.0, 0.2, 0.2], [0.0, 0.8, 0.0], [1.0, 1.0, 0.2],
		[0.3, 0.3, 1.0], [1.0, 1.0, 1.0], [0.7, 0.5, 0.0], [0.5, 0.5, 0.5],
		[0.2, 0.9, 0.9], [0.8, 0.0, 0.8], [0.0, 0.6, 0.6], [1.0, 0.7, 0.7],
		[1.0, 0.5, 1.0], [0.5, 0.6, 0.0], [1.0, 0.7, 0.0], [0.7, 1.0, 0.5],
		[0.6, 0.6, 1.0],
	];
	offsets = hex_offsets(wires, wirediam);
	bezpath = fillet_path(path, fillet);
	poly = simplify3d_path(path3d(bezier_polyline(bezpath, bezsteps)));
	n = max(segs(wirediam), 8);
	r = wirediam/2;
	for (i = [0:wires-1]) {
		extpath = [for (a = [0:(360.0/n):360]) [r*cos(a), r*sin(a)] + offsets[i]];
		roty = matrix3_yrot(90-phi);
		rotz = matrix3_zrot(theta);
		color(colors[(i+wirenum)%len(colors)]) {
			extrude_2dpath_along_3dpath(extpath, poly);
		}
	}
}



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
