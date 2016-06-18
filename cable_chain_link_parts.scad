include <config.scad>
use <GDMUtils.scad>
use <cable_chain.scad>
use <wiring.scad>

pi = 3.1415926535;

module cable_chain_link()
{
	color("SpringGreen")
	union () {
		cable_chain_mount1();
		cable_chain_barrel();
		cable_chain_mount2();
	}
}
//!cable_chain_link();


// Only works in XZ plane, currently.
module cable_chain_assembly(topend, botend, vect, travel, off, wires=0)
{
	vert = abs(topend[2] - botend[2]);
	l1 = cable_chain_length/2 - cable_chain_height/3;
	l2 = cable_chain_length/2 - cable_chain_pivot/2 - 2.75 + 0.1;
	l = l1 + l2;
	basex = topend[0] - botend[0];
	botlen = (travel/2 + off - basex)/2;
	toplen = travel/2 - botlen;
	links = ceil(travel/2/l) + floor(vert*pi/2/l);
	botlinks = ceil(botlen/l);
	toplinks = ceil(toplen/l);
	curllinks = links - botlinks - toplinks;
	aveang = 2*asin((l/2)/(vert/2));
	botang = (toplen-(toplinks*l));
	topang = aveang - botang;
	vect = vect/norm(vect);
	linkvect = l*vect;
	topbase = topend + vect*off;
	if (botlinks > 0) {
		for (i = [0:botlinks-1]) {
			translate(botend + (linkvect*(i+0.5))) {
				zrot(90) {
					down(cable_chain_height / 2) {
						cable_chain_link();
					}
					if (wires > 0) {
						wiring([
							[0, -l1-1, 0],
							[0, 0, 0],
							[0, l2+1, 0],
						], wires, fillet=1);
					}
				}
			}
		}
	}
	if (toplinks > 0) {
		for (i = [0:toplinks-1]) {
			translate(topbase + (linkvect * (i + 0.5))) {
				zrot(90) {
					xrot(180) {
						down(cable_chain_height / 2) {
							cable_chain_link();
						}
						if (wires > 0) {
							wiring([
								[0, -l1-1, 0],
								[0, 0, 0],
								[0, l2+1, 0],
							], wires, fillet=1);
						}
					}
				}
			}
		}
	}
	bottip = botend + (linkvect * botlinks);
	toptip = topbase + (linkvect * toplinks);
	cent = (toptip + bottip) / 2;
	translate(cent) {
		delta = toptip - bottip;
		rad = distance(bottip, toptip) / 2;
		aveang = 2 * asin(l / (2 * rad));
		centang = (180-(aveang*curllinks))/2;
		offang = 90-atan2(delta[2], delta[0]);
		right(rad*sin(centang)) {
			yrot(centang+offang) {
				for (i = [0 : curllinks-1]) {
					ang = 270 - i * aveang;
					translate(rad * [cos(ang), 0, sin(ang)]) {
						zrot(90) {
							xrot((i+0.5) * aveang) {
								back(l2) {
									down(cable_chain_height / 2) {
										cable_chain_link();
									}
									if (wires > 0) {
										wiring([
											[0, -l1-1, 0],
											[0, 0, 0],
											[0, l2+1, 0],
										], wires, fillet=1);
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
//!cable_chain_assembly([0,0,75], [0,0,0], [-1,0,0], 200, 100*sin(360*$t));


module cable_chain_link_parts() { // make me
	xspread(cable_chain_width+2, n=4) {
		yspread(cable_chain_length+2, n=4) {
			cable_chain_link();
		}
	}
}


cable_chain_link_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
