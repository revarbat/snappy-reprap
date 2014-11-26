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
	grid_of(count=[5, 4], spacing=[23, 27]) {
		cable_chain_link();
	}
}


cable_chain_link_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

