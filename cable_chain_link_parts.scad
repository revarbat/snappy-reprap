include <config.scad>
use <GDMUtils.scad>
use <cable_chain.scad>


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


module cable_chain_link_parts() { // make me
	xspread(cable_chain_length+3, n=5) {
		yspread(cable_chain_width+3, n=5) {
			zrot(90) cable_chain_link();
		}
	}
}


cable_chain_link_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

