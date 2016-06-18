use <GDMUtils.scad>


function normalize(v) = v/norm(v);


function fillet3pts(p0, p1, p2, r) = let(
        v0 = normalize(p0-p1),
        v1 = normalize(p2-p1),
        a = vector3d_angle(v0,v1),
        tr = r/tan(a/2),
        tp0 = p1+v0*tr,
        tp1 = p1+v1*tr,
        w=-2.7e-5*a*a + 8.5e-3*a - 3e-3,
        cp0 = tp0+w*(p1-tp0),
        cp1 = tp1+w*(p1-tp1)
    ) [tp0, tp0, cp0, cp1, tp1, tp1];


// Must be passed at least 3 points.
function fillet_path(pts, fillet) = concat(
    [pts[0], pts[0]],
    [
        for (p = [1 : len(pts)-2])
            for (pt = fillet3pts(pts[p-1], pts[p], pts[p+1], fillet))
                pt
    ],
    [pts[len(pts)-1], pts[len(pts)-1]]
);


module wiring(path, wires, fillet=10, wirenum=0) {
    vect = path[1]-path[0];
    theta = atan2(vect[1], vect[0]);
    xydist = hypot(vect[1], vect[0]);
    phi = atan2(vect[2],xydist);
    colors = [
        [0.3, 0.3, 0.3], [1.0, 0.2, 0.2], [0.2, 1.0, 0.2], [1.0, 1.0, 0.2],
        [0.3, 0.3, 1.0], [1.0, 1.0, 1.0], [0.5, 0.4, 0.0], [0.6, 0.6, 0.6],
        [0.2, 1.0, 1.0], [0.8, 0.0, 0.8], [0.0, 0.6, 0.6], [1.0, 0.7, 0.7],
        [1.0, 0.5, 1.0]
    ];
    offsets = [
        [-1.00, -1.00,  0.00],
        [ 1.00, -1.00,  0.00],
        [ 1.00,  1.00,  0.00],
        [-1.00,  1.00,  0.00],
        [-2.66,  0.00,  0.00],
        [ 2.66,  0.00,  0.00],
        [ 0.00, -2.66,  0.00],
        [ 0.00,  2.66,  0.00]
    ];
    offsets = concat(
        [[0,0,0]],
        [for (a = [0:60:359]) [2*cos(a), 2*sin(a), 0]],
        [for (a = [30:60:359]) [3.464*cos(a), 3.464*sin(a), 0]]
    );
    extpath = [for (a = [0:30:360]) [cos(a), sin(a)]];
    bezpath = fillet_path(path, fillet);
    poly = simplify3d_path(path3d(bezier_polyline(bezpath, 8)));
    for (i = [0:wires-1]) {
        roty = matrix3_yrot(90-phi);
        rotz = matrix3_zrot(theta);
        offset = (rotz * roty) * offsets[i];
        translate(offset)
            color(colors[i+wirenum])
                extrude_2dpath_along_3dpath(extpath, poly);
    }
}


