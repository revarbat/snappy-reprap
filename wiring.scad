use <GDMUtils.scad>


function normalize(v) = v/norm(v);


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


// Must be passed at least 3 points.
function fillet_path(pts, fillet) = concat(
	[pts[0], pts[0]],
	[
		for (
			p = [1 : len(pts)-2],
			pt = fillet3pts(pts[p-1], pts[p], pts[p+1], fillet)
		) pt
	],
	[pts[len(pts)-1], pts[len(pts)-1]]
);


function hex_offset_ring(wirediam, lev=0) =
    (lev == 0)? [[0,0,0]] : [
        for (
            sideang = [0:60:359.999],
            sidewire = [1:lev]
        ) [
            lev*wirediam*cos(sideang)+sidewire*wirediam*cos(sideang+120),
            lev*wirediam*sin(sideang)+sidewire*wirediam*sin(sideang+120)
        ]
    ];


function hex_offsets(wires, wirediam, lev=0, arr=[]) =
    (len(arr) >= wires)? arr :
        hex_offsets(
            wires=wires,
            wirediam=wirediam,
            lev=lev+1,
            arr=concat(arr, hex_offset_ring(wirediam, lev=lev))
        );


module wiring(path, wires, wirediam=2, fillet=10, wirenum=0, bezsteps=12) {
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
	for (i = [0:wires-1]) {
		extpath = [for (a = [0:(360.0/n):360]) [0.5*wirediam*cos(a), 0.5*wirediam*sin(a)]+offsets[i]];
		roty = matrix3_yrot(90-phi);
		rotz = matrix3_zrot(theta);
		color(colors[(i+wirenum)%len(colors)]) {
			extrude_2dpath_along_3dpath(extpath, poly);
		}
	}
}
// wiring([[50,0,-50], [50,50,-50], [0,50,-50], [0,0.01,-50], [0, 0, 0]], fillet=10, wires=32);


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
