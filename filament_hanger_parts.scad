include <config.scad>
use <GDMUtils.scad>


$fa=1;
$fs=1.5;


module filament_hanger()
{
	thick = 10;
	width = 15;
	length = 85;
	hanger = 65;
	lip = 10;

	color("lightblue")
	prerender(convexity=10)
	union() {
		// Hanger lip
		left(rail_thick+printer_slop*2+thick/2) {
			down(lip/2-0.05) {
				sz = [thick,width,lip];
				chamfer(chamfer=thick/4, size=sz, edges=[[0,0,0,0],[0,0,1,1],[0,0,0,0]]) {
					cube(sz, center=true);
				}
			}
		}

		// Hanger horizontal
		left((rail_thick+printer_slop*2)/2) {
			up(thick/2) {
				sz = [2*thick+rail_thick+printer_slop*2,width,thick];
				chamfer(chamfer=width/4, size=sz, edges=[[0,0,0,0],[1,1,0,0],[0,0,0,0]]) {
					cube(sz, center=true);
				}
			}
		}

		// Hanger vertical
		right(thick/2) {
			down(hanger/2) {
				sz = [thick,width,hanger+0.1];
				chamfer(chamfer=width/4, size=sz, edges=[[0,0,0,0],[0,0,1,0],[0,0,0,0]]) {
					cube(sz, center=true);
				}
			}
		}

		// Hanger brace
		yrot(-25) {
			right(thick/2) {
				down((hanger-20)/2) {
					cube([thick,width,hanger-15], center=true);
				}
			}
		}

		// Spool holder
		right((length+thick)/2+thick-0.05) {
			down(hanger-width/2-15) {
				sz = [length+thick,width,width];
				chamfer(chamfer=width/4, size=sz, edges=[[1,1,0,0],[0,0,1,0],[0,0,0,0]]) {
					cube(sz, center=true);
				}
			}
		}

		// Spool lip
		right(length+thick+lip/2+1) {
			down(hanger-width-15) {
				yrot(15) {
					sz = [lip,width,width];
					chamfer(chamfer=width/4, size=sz, edges=[[0,0,0,0],[0,1,0,0],[0,1,0,1]]) {
						cube(sz, center=true);
					}
				}
			}
		}
	}
}



module filament_hanger_parts() { // make me
	zrot(90)
	left((75+15)/2)
	fwd(65/2)
	up(15/2)
	xrot(90) filament_hanger();
}

filament_hanger_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

