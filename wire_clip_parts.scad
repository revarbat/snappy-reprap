include <config.scad>
use <GDMUtils.scad>

$fa=2;
$fs=1.5;

pi = 3.141592653589793236;

module wire_clip(
	d = 8,
	h = 10,
	wall = 1,
	gap = 2,
	angle = 30
) {
	gap_adj = gap / cos(angle);
	up(h/2) {
		difference() {
			tube(r=d/2+wall, h=h, wall=wall, center=true);
			linear_extrude(height=10.01, twist=tan(angle)*360*h/(d*pi), slices=h, center=true, convexity=4) {
				difference() {
					circle(d=d+2*wall+1, $fn=24);
					circle(d=d-1, $fn=24);
					zrot(180*gap_adj/(d*pi)) {
						right(d/2+wall/2) circle(d=wall+0.1, $fn=8);
						back(d) square(d*2, center=true);
					}
					zrot(-180*gap_adj/(d*pi)) {
						right(d/2+wall/2) circle(d=wall+0.1, $fn=8);
						fwd(d) square(d*2, center=true);
					}
				}
			}
		}
	}
}

module wire_clip_parts() { // make me
	for (diam=[3, 4, 5, 6, 8, 10]) {
		yspread(15, n=5) {
			right(diam*10-80) wire_clip(d=diam);
		}
	}
}

wire_clip_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
