// Convenience modules.


// Optionally pre-render if someone sets $do_prerender=true
//$do_prerender = true;
module prerender(convexity=10) {
	if ($do_prerender == true) {
		render(convexity=convexity) {
			children();
		}
	} else {
		children();
	}
}


module redlines(lines) {
	for (line = lines) {
		delta = line[1]-line[0];
		dist = norm(delta);
		theta = atan2(delta[1],delta[0]);
		phi = atan2(delta[2],norm([delta[0],delta[1]]));
		translate(line[0]) {
			zrot(theta) yrot(90-phi) color("Red") cylinder(d=0.5, h=dist);
		}
	}
	color([1, 1, 0, 0.2]) children();
}


//////////////////////////////////////////////////////////////////////
// Transformations.
//////////////////////////////////////////////////////////////////////


// Moves/translates children.
//   x = X axis translation.
//   y = Y axis translation.
//   z = Z axis translation.
// Example:
//   move([10,20,30]) sphere(r=1);
//   move(y=10) sphere(r=1);
//   move(x=10, z=20) sphere(r=1);
module move(a=[0,0,0], x=0, y=0, z=0) {
	translate(a) translate([x,y,z]) children();
}


// Moves/translates children the given amount along the X axis.
// Example:
//   xmove(10) sphere(r=1);
module xmove(x=0) { translate([x,0,0]) children(); }


// Moves/translates children the given amount along the Y axis.
// Example:
//   ymove(10) sphere(r=1);
module ymove(y=0) { translate([0,y,0]) children(); }


// Moves/translates children the given amount along the Z axis.
// Example:
//   zmove(10) sphere(r=1);
module zmove(z=0) { translate([0,0,z]) children(); }


// Moves children left by the given amount in the -X direction.
// Example:
//   left(10) sphere(r=1);
module left(x=0) { translate([-x,0,0]) children(); }


// Moves children right by the given amount in the +X direction.
// Example:
//   right(10) sphere(r=1);
module right(x=0) { translate([x,0,0]) children(); }


// Moves children forward by x amount in the -Y direction.
// Example:
//   forward(10) sphere(r=1);
module forward(y=0) { translate([0,-y,0]) children(); }
module fwd(y=0) { translate([0,-y,0]) children(); }


// Moves children back by the given amount in the +Y direction.
// Example:
//   back(10) sphere(r=1);
module back(y=0) { translate([0,y,0]) children(); }


// Moves children down by the given amount in the -Z direction.
// Example:
//   down(10) sphere(r=1);
module down(z=0) { translate([0,0,-z]) children(); }


// Moves children up by the given amount in the +Z direction.
// Example:
//   up(10) sphere(r=1);
module up(z=0) { translate([0,0,z]) children(); }


// Rotates children around the Z axis by the given number of degrees.
// Example:
//   xrot(90) cylinder(h=10, r=2, center=true);
module xrot(a=0) { rotate([a, 0, 0]) children(); }


// Rotates children around the Y axis by the given number of degrees.
// Example:
//   yrot(90) cylinder(h=10, r=2, center=true);
module yrot(a=0) { rotate([0, a, 0]) children(); }


// Rotates children around the Z axis by the given number of degrees.
// Example:
//   zrot(90) cube(size=[9,1,4], center=true);
module zrot(a=0) { rotate([0, 0, a]) children(); }


// Scales children by the given factor in the X axis.
// Example:
//   xscale(3) sphere(r=100, center=true);
module xscale(x) {scale([x,0,0]) children();}


// Scales children by the given factor in the Y axis.
// Example:
//   yscale(3) sphere(r=100, center=true);
module yscale(y) {scale([0,y,0]) children();}


// Scales children by the given factor in the Z axis.
// Example:
//   zscale(3) sphere(r=100, center=true);
module zscale(z) {scale([0,0,z]) children();}


// Mirrors the children along the X axis, kind of like xscale(-1)
module xflip() mirror([1,0,0]) children();


// Mirrors the children along the Y axis, kind of like yscale(-1)
module yflip() mirror([0,1,0]) children();


// Mirrors the children along the Z axis, kind of like zscale(-1)
module zflip() mirror([0,0,1]) children();


// Skews children on the X-Y plane, keeping constant in Z.
//   xang = skew angle towards the X direction.
//   yang = skew angle towards the Y direction.
// Examples:
//   skew_xy(xang=15) cube(size=10);
//   skew_xy(xang=15, yang=30) cube(size=10);
module skew_xy(xang=0, yang=0)
{
	multmatrix(m = [
		[1,         0,  tan(xang),        0],
		[0,         1,  tan(yang),        0],
		[0,         0,          1,        0],
		[0,         0,          0,        1]
	]) {
		children();
	}
}
module zskew(xa=0,ya=0) skew_xy(xang=xa,yang=ya) children();


// Skews children on the Y-Z plane, keeping constant in X.
//   yang = skew angle towards the Y direction.
//   zang = skew angle towards the Z direction.
// Examples:
//   skew_yz(yang=15) cube(size=10);
//   skew_yz(yang=15, zang=30) cube(size=10);
module skew_yz(yang=0, zang=0)
{
	multmatrix(m = [
		[1,         0,          0,        0],
		[tan(yang), 1,          0,        0],
		[tan(zang), 0,          1,        0],
		[0,         0,          0,        1]
	]) {
		children();
	}
}
module xskew(ya=0,za=0) skew_yz(yang=ya,zang=za) children();


// Skews children on the X-Z plane, keeping constant in Y.
//   xang = skew angle towards the X direction.
//   zang = skew angle towards the Z direction.
// Examples:
//   skew_xz(xang=15) cube(size=10);
//   skew_xz(xang=15, zang=30) cube(size=10);
module skew_xz(xang=0, zang=0)
{
	multmatrix(m = [
		[1, tan(xang),          0,        0],
		[0,         1,          0,        0],
		[0, tan(zang),          1,        0],
		[0,         0,          0,        1]
	]) {
		children();
	}
}
module yskew(xa=0,za=0) skew_xz(xang=xa,zang=za) children();



//////////////////////////////////////////////////////////////////////
// Mutators.
//////////////////////////////////////////////////////////////////////


// Performs hull operations between consecutive pairs of children,
// then unions all of the hull results.
module chain_hull() {
	union() {
		if ($children == 1) {
			children();
		} else if ($children > 1) {
			for (i =[1:$children-1]) {
				hull() {
					children(i-1);
					children(i);
				}
			}
		}
	}
}



//////////////////////////////////////////////////////////////////////
// Duplicators and Distributers.
//////////////////////////////////////////////////////////////////////


// Makes a copy of the children, mirrored across the given axes.
//   v = The normal vector of the plane to mirror across.
// Example:
//   mirror_copy([1,-1,0]) yrot(30) cylinder(h=10, r=1, center=true);
module mirror_copy(v=[0,0,1])
{
	union() {
		children();
		mirror(v) children();
	}
}
module xflip_copy() {children(); mirror([1,0,0]) children();}
module yflip_copy() {children(); mirror([0,1,0]) children();}
module zflip_copy() {children(); mirror([0,0,1]) children();}


// Given a number of euller angles, rotates copies of the given children to each of those angles.
// Example:
//   rot_copies(rots=[[0,0,0],[45,0,0],[0,45,120],[90,-45,270]])
//     translate([6,0,0]) cube(size=[9,1,4], center=true);
module rot_copies(rots=[[0,0,0]])
{
	for (rot = rots)
		rotate(rot)
			children();
}


// Given an array of angles, rotates copies of the children to each of those angles around the X axis.
//   rots = Optional array of angles, in degrees, to make copies at.
//   count = Optional number of evenly distributed copies, rotated around a circle.
//   offset = Angle offset in degrees, for use with count.
// Example:
//   xrot_copies(rots=[0,15,30,60,120,240]) translate([0,6,0]) cube(size=[4,9,1], center=true);
//   xrot_copies(count=6, offset=15) translate([0,6,0]) cube(size=[4,9,1], center=true);
module xrot_copies(rots=[0], offset=0, count=undef)
{
	if (count != undef) {
		for (i = [0 : count-1]) {
			a = (i / count) * 360.0;
			rotate([a+offset, 0, 0]) {
				children();
			}
		}
	} else {
		for (a = rots) {
			rotate([a+offset, 0, 0]) {
				children();
			}
		}
	}
}


// Given an array of angles, rotates copies of the children to each of those angles around the Y axis.
//   rots = Optional array of angles, in degrees, to make copies at.
//   count = Optional number of evenly distributed copies, rotated around a circle.
//   offset = Angle offset in degrees, for use with count.
// Example:
//   yrot_copies(rots=[0,15,30,60,120,240]) translate([6,0,0]) cube(size=[9,4,1], center=true);
//   yrot_copies(count=6, offset=15) translate([6,0,0]) cube(size=[9,4,1], center=true);
module yrot_copies(rots=[0], offset=0, count=undef)
{
	if (count != undef) {
		for (i = [0 : count-1]) {
			a = (i / count) * 360.0;
			rotate([0, a+offset, 0]) {
				children();
			}
		}
	} else {
		for (a = rots) {
			rotate([0, a+offset, 0]) {
				children();
			}
		}
	}
}


// Given an array of angles, rotates copies of the children to each of those angles around the Z axis.
//   rots = Optional array of angles, in degrees, to make copies at.
//   count = Optional number of evenly distributed copies, rotated around a circle.
//   offset = Angle offset in degrees, for use with count.
// Example:
//   zrot_copies(rots=[0,15,30,60,120,240]) translate([6,0,0]) cube(size=[9,1,4], center=true);
//   zrot_copies(count=6, offset=15) translate([6,0,0]) cube(size=[9,1,4], center=true);
module zrot_copies(rots=[0], offset=0, count=undef)
{
	if (count != undef) {
		for (i = [0 : count-1]) {
			a = (i / count) * 360.0;
			rotate([0, 0, a+offset]) {
				children();
			}
		}
	} else {
		for (a = rots) {
			rotate([0, 0, a+offset]) {
				children();
			}
		}
	}
}


// Makes copies of the given children at each of the given offsets.
//   offsets = array of XYZ offset vectors. Default [[0,0,0]]
// Example:
//   translate_copies([[-5,-5,0], [5,-5,0], [0,-5,7], [0,5,0]])
//     sphere(r=3,center=true);
module translate_copies(offsets=[[0,0,0]])
{
	for (off = offsets)
		translate(off)
			children();
}
module place_copies(a=[[0,0,0]]) {for (p = a) translate(p) children();}


// Evenly distributes n duplicate children along an XYZ line.
//   p1 = starting point of line.  (Default: [0,0,0])
//   p2 = ending point of line.  (Default: [10,0,0])
//   n = number of copies to distribute along the line. (Default: 2)
// Examples:
//   line_of(p1=[0,0,0], p2=[-10,15,20], n=5) cube(size=[3,1,1],center=true);
//
module line_of(p1=[0,0,0], p2=[10,0,0], n=2)
{
	delta = (p2 - p1) / (n-1);
	for (i = [0:n-1]) translate(p1+delta*i) children();
}
module spread(p1,p2,n=3) for (i=[0:n-1]) translate(p1+i*(p2-p1)/(n-1)) children();


// Evenly distributes n duplicate children around an arc/circle on the XY plane.
//   n = number of copies to distribute around the circle. (Default: 6)
//   r = radius of circle (Default: 1)
//   rx = radius of ellipse on X axis. Used instead of r.
//   ry = radius of ellipse on Y axis. Used instead of r.
//   d = diameter of circle. (Default: 2)
//   dx = diameter of ellipse on X axis. Used instead of d.
//   dy = diameter of ellipse on Y axis. Used instead of d.
//   rot = whether to rotate the copied children.  (Default: false)
//   sa = starting angle. (Default: 0.0)
//   ea = ending angle. Will distribute copies CCW from sa to ea. (Default: 360.0)
// Examples:
//   circle_of(d=8,n=5)
//     cube(size=[3,1,1],center=true);
//   circle_of(r=10,n=12,rot=true)
//     cube(size=[3,1,1],center=true);
//   circle_of(rx=15,ry=10,n=12,rot=true)
//     cube(size=[3,1,1],center=true);
//   circle_of(r=10,n=5,rot=true,sa=30.0,ea=150.0)
//     cube(size=[3,1,1],center=true);
//
module circle_of(
		n=6,
		r=1, rx=undef, ry=undef,
		d=undef, dx=undef, dy=undef,
		sa=0.0, ea=360.0,
		rot=false
) {
	r = (d == undef)?r:(d/2.0);
	rx = (dx == undef)?rx:(dx/2.0);
	ry = (dy == undef)?rx:(dy/2.0);
	rx = (rx == undef)?r:rx;
	ry = (ry == undef)?r:ry;
	sa = ((sa % 360.0) + 360.0) % 360.0; // make 0 < ang < 360
	ea = ((ea % 360.0) + 360.0) % 360.0; // make 0 < ang < 360
	n = (abs(ea-sa)<0.01)?(n+1):n;
	delt = (((ea<=sa)?360.0:0)+ea-sa)/(n-1);
	for (ang = [sa:delt:(sa+delt*(n-1))])
		if (abs(abs(ang-sa)-360.0) > 0.01)
			translate([cos(ang)*rx,sin(ang)*ry,0])
				rotate([0,0,rot?atan2(sin(ang)*ry,cos(ang)*rx):0])
					children();
}


module xring(n=2,r=0,rot=true) {if (n>0) for (i=[0:n-1]) {a=i*360/n; xrot(a) back(r) xrot(rot?0:-a) children();}}
module yring(n=2,r=0,rot=true) {if (n>0) for (i=[0:n-1]) {a=i*360/n; yrot(a) right(r) yrot(rot?0:-a) children();}}
module zring(n=2,r=0,rot=true) {if (n>0) for (i=[0:n-1]) {a=i*360/n; zrot(a) right(r) zrot(rot?0:-a) children();}}


// Spreads out n copies of the given children along the X axis.
//   spacing = spacing between copies. (Default: 1.0)
//   n = Number of copies to spread out. (Default: 2)
// Examples:
//   xspread(25) sphere(1);
//   xspread(25,3) sphere(1)
//   xspread(25, n=3) sphere(1)
//   xspread(spacing=20, n=4) sphere(1)
module xspread(spacing=1,n=2) for (i=[0:n-1]) right((i-(n-1)/2.0)*spacing) children();


// Spreads out n copies of the given children along the Y axis.
//   spacing = spacing between copies. (Default: 1.0)
//   n = Number of copies to spread out. (Default: 2)
// Examples:
//   yspread(25) sphere(1);
//   yspread(25,3) sphere(1)
//   yspread(25, n=3) sphere(1)
//   yspread(spacing=20, n=4) sphere(1)
module yspread(spacing=1,n=2) for (i=[0:n-1]) back((i-(n-1)/2.0)*spacing) children();


// Spreads out n copies of the given children along the Z axis.
//   spacing = spacing between copies. (Default: 1.0)
//   n = Number of copies to spread out. (Default: 2)
// Examples:
//   zspread(25) sphere(1);
//   zspread(25,3) sphere(1)
//   zspread(25, n=3) sphere(1)
//   zspread(spacing=20, n=4) sphere(1)
module zspread(spacing=1,n=2) for (i=[0:n-1]) up((i-(n-1)/2.0)*spacing) children();


// Makes a 3D grid of duplicate children.
//   xa = array or range of X-axis values to offset by. (Default: [0])
//   ya = array or range of Y-axis values to offset by. (Default: [0])
//   za = array or range of Z-axis values to offset by. (Default: [0])
//   count = Optional number of copies to have per axis. (Default: none)
//   spacing = spacing of copies per axis. Use with count. (Default: 0)
// Examples:
//   grid_of(xa=[0,2,3,5],ya=[3:5],za=[-4:2:6]) sphere(r=0.5,center=true);
//   grid_of(ya=[-6:3:6],za=[4,7]) sphere(r=1,center=true);
//   grid_of(count=3, spacing=10) sphere(r=1,center=true);
//   grid_of(count=[3, 1, 2], spacing=10) sphere(r=1,center=true);
//   grid_of(count=[3, 4], spacing=[10, 8]) sphere(r=1,center=true);
//   grid_of(count=[3, 4, 2], spacing=[10, 8, 5]) sphere(r=1,center=true, $fn=24);
module grid_of(xa=[0], ya=[0], za=[0], count=[], spacing=[])
{
	count = (len(count) == undef)? [count,1,1] :
			((len(count) == 1)? [count[0], 1, 1] :
			((len(count) == 2)? [count[0], count[1], 1] :
			((len(count) == 3)? count : undef)));

	spacing = (len(spacing) == undef)? [spacing,spacing,spacing] :
			((len(spacing) == 1)? [spacing[0], 0, 0] :
			((len(spacing) == 2)? [spacing[0], spacing[1], 0] :
			((len(spacing) == 3)? spacing : undef)));

	if (count != undef && spacing != undef) {
		for (x = [-(count[0]-1)/2 : (count[0]-1)/2 + 0.1]) {
			for (y = [-(count[1]-1)/2 : (count[1]-1)/2 + 0.1]) {
				for (z = [-(count[2]-1)/2 : (count[2]-1)/2 + 0.1]) {
					translate([x*spacing[0], y*spacing[1], z*spacing[2]]) {
						children();
					}
				}
			}
		}
	} else {
		for (xoff = xa) {
			for (yoff = ya) {
				for (zoff = za) {
					translate([xoff,yoff,zoff]) {
						children();
					}
				}
			}
		}
	}
}


module top_half   (s=100) difference() {children();  down(s/2) cube(s, center=true);}
module bottom_half(s=100) difference() {children();    up(s/2) cube(s, center=true);}
module left_half  (s=100) difference() {children(); right(s/2) cube(s, center=true);}
module right_half (s=100) difference() {children();  left(s/2) cube(s, center=true);}
module front_half (s=100) difference() {children();  back(s/2) cube(s, center=true);}
module back_half  (s=100) difference() {children();   fwd(s/2) cube(s, center=true);}



//////////////////////////////////////////////////////////////////////
// Masking shapes.
//////////////////////////////////////////////////////////////////////


module angle_half_pie_mask(
	ang=45, h=1,
	r=undef, r1=undef, r2=undef,
	d=1.0, d1=undef, d2=undef,
) {
	r  = (r  != undef)? r  : (d/2);
	r1 = (r1 != undef)? r1 : ((d1 != undef)? (d1/2) : r);
	r2 = (r2 != undef)? r2 : ((d2 != undef)? (d2/2) : r);
	rm = max(r1,r2);
	difference() {
		cylinder(h=h, r1=r1, r2=r2, center=true);
		translate([0, -rm/2, 0])
			cube(size=[rm*2+1, rm, h+1], center=true);
		zrot(ang) {
			translate([0, rm/2, 0]) {
				cube(size=[rm*2.1, rm, h+1], center=true);
			}
		}
	}
}


module angle_pie_mask(
	ang=45, h=1,
	r=undef, r1=undef, r2=undef,
	d=1.0, d1=undef, d2=undef,
) {
	a1 = min(ang, 180.0);
	a2 = max(0.0, ang-180.0);
	r  = (r  != undef)? r  : (d/2);
	r1 = (r1 != undef)? r1 : ((d1 != undef)? (d1/2) : r);
	r2 = (r2 != undef)? r2 : ((d2 != undef)? (d2/2) : r);
	union() {
		angle_half_pie_mask(h=h, r1=r1, r2=r2, ang=a1);
		if (a2 > 0.0) {
			zrot(180) angle_half_pie_mask(h=h, r1=r1, r2=r2, ang=a2);
		}
	}
}


// Creates a shape that can be used to chamfer a 90 degree edge.
// Difference it from the object to be chamfered.  The center of the mask
// object should align exactly with the edge to be chamfered.
module chamfer_mask(h=1.0, r=1.0)
{
	zrot(45) cube(size=[r*sqrt(2.0), r*sqrt(2.0), h], center=true);
}


// Chamfers the edges of a cuboid region containing the given children.
//   chamfer = inset of the chamfer from the edge. (Default: 1)
//   size = The size of the rectangular cuboid we want to chamfer.
//   edges = which edges do we want to chamfer.
//           [
//               [Y+Z+, Y-Z+, Y-Z-, Y+Z-],
//               [X+Z+, X-Z+, X-Z-, X+Z-],
//               [X+Y+, X-Y+, X-Y-, X+Y-]
//           ]
// Example:
//   chamfer(chamfer=2, size=[10,40,90], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
//     cube(size=[10,40,90], center=true);
//   }
module chamfer(chamfer=1, size=[1,1,1], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]])
{
	difference() {
		union() {
			children();
		}
		union() {
			if (edges[0][0] != 0)
				translate([0,  size[1]/2,  size[2]/2])
					xrot(45) cube(size=[size[0]+0.1, chamfer*sqrt(2), chamfer*sqrt(2)], center=true);
			if (edges[0][1] != 0)
				translate([0, -size[1]/2,  size[2]/2])
					xrot(45) cube(size=[size[0]+0.1, chamfer*sqrt(2), chamfer*sqrt(2)], center=true);
			if (edges[0][2] != 0)
				translate([0,  size[1]/2, -size[2]/2])
					xrot(45) cube(size=[size[0]+0.1, chamfer*sqrt(2), chamfer*sqrt(2)], center=true);
			if (edges[0][3] != 0)
				translate([0, -size[1]/2, -size[2]/2])
					xrot(45) cube(size=[size[0]+0.1, chamfer*sqrt(2), chamfer*sqrt(2)], center=true);

			if (edges[1][0] != 0)
				translate([ size[0]/2, 0,  size[2]/2])
					yrot(45) cube(size=[chamfer*sqrt(2), size[1]+0.1, chamfer*sqrt(2)], center=true);
			if (edges[1][1] != 0)
				translate([-size[0]/2, 0,  size[2]/2])
					yrot(45) cube(size=[chamfer*sqrt(2), size[1]+0.1, chamfer*sqrt(2)], center=true);
			if (edges[1][2] != 0)
				translate([ size[0]/2, 0, -size[2]/2])
					yrot(45) cube(size=[chamfer*sqrt(2), size[1]+0.1, chamfer*sqrt(2)], center=true);
			if (edges[1][3] != 0)
				translate([-size[0]/2, 0, -size[2]/2])
					yrot(45) cube(size=[chamfer*sqrt(2), size[1]+0.1, chamfer*sqrt(2)], center=true);

			if (edges[2][0] != 0)
				translate([ size[0]/2,  size[1]/2, 0])
					zrot(45) cube(size=[chamfer*sqrt(2), chamfer*sqrt(2), size[2]+0.1], center=true);
			if (edges[2][1] != 0)
				translate([-size[0]/2,  size[1]/2, 0])
					zrot(45) cube(size=[chamfer*sqrt(2), chamfer*sqrt(2), size[2]+0.1], center=true);
			if (edges[2][2] != 0)
				translate([ size[0]/2, -size[1]/2, 0])
					zrot(45) cube(size=[chamfer*sqrt(2), chamfer*sqrt(2), size[2]+0.1], center=true);
			if (edges[2][3] != 0)
				translate([-size[0]/2, -size[1]/2, 0])
					zrot(45) cube(size=[chamfer*sqrt(2), chamfer*sqrt(2), size[2]+0.1], center=true);
		}
	}
}


// Creates a shape that can be used to fillet a 90 degree edge.
// Difference it from the object to be filletted.  The center of the mask
// object should align exactly with the edge to be filletted.
module fillet_mask(h=1.0, r=1.0)
{
	render(convexity=4)
	difference() {
		cube(size=[r*2, r*2, h], center=true);
		grid_of(count=[2,2], spacing=r*2-0.05) {
			cylinder(h=h+1, r=r, center=true);
		}
	}
}


// Example:
//   fillet_edge_joint_mask(fillet=100, ang=90);
module fillet_edge_joint_mask(fillet=1.0, ang=90)
{
	dy = fillet * tan(ang/2);
	th = max(dy, fillet*2);
	render(convexity=4)
	difference() {
		down(dy) {
			up(th/2) {
				forward(fillet) {
					cube(size=[fillet*2, fillet*4, th], center=true);
				}
			}
		}
		down(dy) {
			forward(fillet) {
				grid_of(count=2, spacing=fillet*2) {
					sphere(r=fillet);
				}
				xrot(ang) {
					up(fillet*2) {
						cube(size=[fillet*8, fillet*8, fillet*4], center=true);
					}
				}
			}
		}
	}
}


// Creates a shape that can be used to fillet a convex edge at any angle.
// Difference it from the object to be filletted.  The center of the mask
// object should align exactly with the edge to be filletted.
module fillet_planes_joint_mask(h=1.0, r=1.0, ang=90)
{
	x = r*sin(90-(ang/2))/sin(ang/2);
	render(convexity=4)
	difference() {
		cylinder(h=h, r=abs(x), center=true, $fn=32);
		translate([x, r, 0]) {
			cylinder(h=h+1, r=r, center=true);
		}
	}
}
//!fillet_planes_joint_mask(h=50.0, r=10.0, ang=240, $fn=32);


// Creates a shape that you can use to round 90 degree corners on a fillet.
// Difference it from the object to be filletted.  The center of the mask
// object should align exactly with the corner to be filletted.
//   r = radius of corner fillet.
// Example:
//   $fa=1; $fs=1;
//   difference() {
//     cube(size=[6,10,16], center=true);
//     translate([0, 5, 8]) yrot(90) fillet_mask(h=7, r=3);
//     translate([3, 0, 8]) xrot(90) fillet_mask(h=11, r=3);
//     translate([3, 5, 0]) fillet_mask(h=17, r=3);
//     translate([3, 5, 8]) corner_fillet_mask(r=3);
//   }
module corner_fillet_mask(r=1.0)
{
	render(convexity=4)
	difference() {
		cube(size=r*2, center=true);
		grid_of(count=[2,2,2], spacing=r*2-0.05) {
			sphere(r=r, center=true);
		}
	}
}


// Create a mask that can be used to round the end of a cylinder.
// Difference it from the cylinder to be filletted.  The center of the
// mask object should align exactly with the center of the end of the
// cylinder to be filletted.
//   r = radius of cylinder to fillet. (Default: 1.0)
//   fillet = radius of the edge filleting. (Default: 0.25)
//   xtilt = angle of tilt of end of cylinder in the X direction. (Default: 0)
//   ytilt = angle of tilt of end of cylinder in the Y direction. (Default: 0)
// Example:
//   $fa=2; $fs=2;
//   difference() {
//     cylinder(r=50, h=100, center=true);
//     translate([0, 0, 50])
//       fillet_cylinder_mask(r=50, fillet=10, xtilt=30, ytilt=30);
//   }
module fillet_cylinder_mask(r=1.0, fillet=0.25, xtilt=0, ytilt=0)
{
	dhx = 2*r*sin(xtilt);
	dhy = 2*r*sin(ytilt);
	dh = hypot(dhy, dhx);
	down(dh/2) {
		skew_xz(zang=xtilt) {
			skew_yz(zang=ytilt) {
				down(fillet) {
					difference() {
						up((dh+2*fillet)/2) {
							cube(size=[r*2+10, r*2+10, dh+2*fillet], center=true);
						}
						torus(or=r, ir=r-2*fillet);
						cylinder(r=r-fillet, h=2*fillet, center=true);
					}
				}
			}
		}
	}
}



// Create a mask that can be used to round the edge of a circular hole.
// Difference it from the hole to be filletted.  The center of the
// mask object should align exactly with the center of the end of the
// hole to be filletted.
//   r = radius of hole to fillet. (Default: 1.0)
//   fillet = radius of the edge filleting. (Default: 0.25)
//   xtilt = angle of tilt of end of cylinder in the X direction. (Default: 0)
//   ytilt = angle of tilt of end of cylinder in the Y direction. (Default: 0)
// Example:
//   $fa=2; $fs=2;
//   difference() {
//     cube([150,150,100], center=true);
//     cylinder(r=50, h=100.1, center=true);
//     up(50) fillet_hole_mask(r=50, fillet=10, xtilt=0, ytilt=0);
//   }
module fillet_hole_mask(r=1.0, fillet=0.25, xtilt=0, ytilt=0)
{
	skew_xz(zang=xtilt) {
		skew_yz(zang=ytilt) {
			difference() {
				cylinder(r=r+fillet, h=2*fillet, center=true);
				down(fillet) torus(ir=r, or=r+2*fillet);
			}
		}
	}
}



//////////////////////////////////////////////////////////////////////
// Compound Shapes.
//////////////////////////////////////////////////////////////////////


// For when you MUST pass a child to a module, but you want it to be nothing.
module nil() difference() {cube(0.1, center=true); cube(0.2, center=true);}


// Makes a cube with chamfered edges.
//   size = size of cube [X,Y,Z].  (Default: [1,1,1])
//   chamfer = chamfer inset along axis.  (Default: 0.25)
module chamfcube(
		size=[1,1,1],
		chamfer=0.25,
		chamfaxes=[1,1,1],
		chamfcorners=false
) {
	ch_width = sqrt(2)*chamfer;
	ch_offset = 1;
	difference() {
		cube(size=size, center=true);
		for (xs = [-1,1]) {
			for (ys = [-1,1]) {
				if (chamfaxes[0] == 1) {
					translate([0,xs*size[1]/2,ys*size[2]/2]) {
						rotate(a=[45,0,0]) cube(size=[size[0]+0.1,ch_width,ch_width], center=true);
					}
				}
				if (chamfaxes[1] == 1) {
					translate([xs*size[0]/2,0,ys*size[2]/2]) {
						rotate(a=[0,45,0]) cube(size=[ch_width,size[1]+0.1,ch_width], center=true);
					}
				}
				if (chamfaxes[2] == 1) {
					translate([xs*size[0]/2,ys*size[1]/2],0) {
						rotate(a=[0,0,45]) cube(size=[ch_width,ch_width,size[2]+0.1], center=true);
					}
				}
				if (chamfcorners) {
					for (zs = [-1,1]) {
						translate([xs*size[0]/2,ys*size[1]/2,zs*size[2]/2]) {
							scale([chamfer,chamfer,chamfer]) {
								polyhedron(
									points=[
										[0,-1,-1], [0,-1,1], [0,1,1], [0,1,-1],
										[-1,0,-1], [-1,0,1], [1,0,1], [1,0,-1],
										[-1,-1,0], [-1,1,0], [1,1,0], [1,-1,0]
									],
									faces=[
										[ 8,  4,  9,  5],
										[ 9,  3, 10,  2],
										[10,  7, 11,  6],
										[11,  0,  8,  1],
										[ 0,  7,  3,  4],
										[ 1,  5,  2,  6],

										[ 1,  8,  5],
										[ 5,  9,  2],
										[ 2, 10,  6],
										[ 6, 11,  1],

										[ 0,  4,  8],
										[ 4,  3,  9],
										[ 3,  7, 10],
										[ 7,  0, 11],
									]
								);
							}
						}
					}
				}
			}
		}
	}
}


// Makes a cube with rounded (filletted) vertical edges.
//   size = size of cube [X,Y,Z].  (Default: [1,1,1])
//   r = radius of edge/corner rounding.  (Default: 0.25)
// Examples:
//   rrect(size=[9,4,1], r=1, center=true);
//   rrect(size=[5,7,3], r=1, $fn=24);
module rrect(size=[1,1,1], r=0.25, center=false)
{
	$fn = ($fn==undef)?max(18,floor(180/asin(1/r)/2)*2):$fn;
	xoff=abs(size[0])/2-r;
	yoff=abs(size[1])/2-r;
	offset = center?[0,0,0]:size/2;
	translate(offset) {
		union(){
			grid_of([-xoff,xoff],[-yoff,yoff])
				cylinder(r=r,h=size[2],center=true,$fn=$fn);
			cube(size=[xoff*2,size[1],size[2]], center=true);
			cube(size=[size[0],yoff*2,size[2]], center=true);
		}
	}
}


// Makes a cube with rounded (filletted) edges and corners.
//   size = size of cube [X,Y,Z].  (Default: [1,1,1])
//   r = radius of edge/corner rounding.  (Default: 0.25)
// Examples:
//   rcube(size=[9,4,1], r=0.333, center=true, $fn=24);
//   rcube(size=[5,7,3], r=1);
module rcube(size=[1,1,1], r=0.25, center=false)
{
	$fn = ($fn==undef)?max(18,floor(180/asin(1/r)/2)*2):$fn;
	xoff=abs(size[0])/2-r;
	yoff=abs(size[1])/2-r;
	zoff=abs(size[2])/2-r;
	offset = center?[0,0,0]:size/2;
	translate(offset) {
		union() {
			grid_of([-xoff,xoff],[-yoff,yoff],[-zoff,zoff])
				sphere(r=r,center=true,$fn=$fn);
			grid_of(xa=[-xoff,xoff],ya=[-yoff,yoff])
				cylinder(r=r,h=zoff*2,center=true,$fn=$fn);
			grid_of(xa=[-xoff,xoff],za=[-zoff,zoff])
				rotate([90,0,0])
					cylinder(r=r,h=yoff*2,center=true,$fn=$fn);
			grid_of(ya=[-yoff,yoff],za=[-zoff,zoff])
				rotate([90,0,0])
				rotate([0,90,0])
					cylinder(r=r,h=xoff*2,center=true,$fn=$fn);
			cube(size=[xoff*2,yoff*2,size[2]], center=true);
			cube(size=[xoff*2,size[1],zoff*2], center=true);
			cube(size=[size[0],yoff*2,zoff*2], center=true);
		}
	}
}


// Creates a cylinder with chamferred edges.
//   h = height of cylinder. (Default: 1.0)
//   r = radius of cylinder. (Default: 1.0)
//   chamfer = X axis inset of the edge chamfer. (Default: 0.25)
//   center = boolean.  If true, cylinder is centered. (Default: false)
//   top = boolean.  If true, chamfer the top edges. (Default: True)
//   bottom = boolean.  If true, chamfer the bottom edges. (Default: True)
// Example:
//   chamferred_cylinder(h=50, r=20, chamfer=5, angle=45, bottom=false, center=true);
module chamferred_cylinder(h=1, r=1, chamfer=0.25, angle=45, center=false, top=true, bottom=true)
{
	off = center? 0 : h/2;
	up(off) {
		difference() {
			cylinder(r=r, h=h, center=true);
			if (top) {
				translate([0, 0, h/2]) {
					rotate_extrude(convexity = 4) {
						translate([r, 0, 0]) {
							scale([1, tan(angle), 1]) {
								zrot(45) square(size=sqrt(2)*chamfer, center=true);
							}
						}
					}
				}
			}
			if (bottom) {
				translate([0, 0, -h/2]) {
					rotate_extrude(convexity = 4) {
						translate([r, 0, 0]) {
							scale([1, tan(angle), 1]) {
								zrot(45) square(size=sqrt(2)*chamfer, center=true);
							}
						}
					}
				}
			}
		}
	}
}


// Creates a cylinder with filletted (rounded) ends.
//   h = height of cylinder. (Default: 1.0)
//   r = radius of cylinder. (Default: 1.0)
//   fillet = radius of the edge filleting. (Default: 0.25)
//   center = boolean.  If true, cylinder is centered. (Default: false)
// Example:
//   rcylinder(h=50, r=20, fillet=5, center=true, $fa=1, $fs=1);
module rcylinder(h=1, r=1, fillet=0.25, center=false)
{
	off = center? 0 : h/2;
	up(off) {
		grid_of(count=[1,1,2], spacing=h-2*fillet) {
			torus(or=r, ir=r-2*fillet);
			cylinder(r=r-fillet, h=fillet*2, center=true);
		}
		cylinder(r=r, h=h-2*fillet, center=true);
	}
}


// Creates a pyramidal prism with a given number of sides.
//   n = number of pyramid sides.
//   h = height of the pyramid.
//   l = length of one side of the pyramid. (optional)
//   r = radius of the base of the pyramid. (optional)
//   d = diameter of the base of the pyramid. (optional)
//   circum = base circumscribes the circle of the given radius or diam.
// Example:
//   pyramid(h=3, d=4, n=6, circum=true);
module pyramid(n=4, h=1, l=1, r=undef, d=undef, circum=false)
{
	cm = circum? 1/cos(180/n) : 1.0;
	radius = (r!=undef)? r*cm : ((d!=undef)? d*cm/2 : (l/(2*sin(180/n))));
	zrot(180/n) cylinder(r1=radius, r2=0, h=h, $fn=n, center=false);
}


// Creates a vertical prism with a given number of sides.
//   n = number of sides.
//   h = height of the prism.
//   l = length of one side of the prism. (optional)
//   r = radius of the prism. (optional)
//   d = diameter of the prism. (optional)
//   circum = prism circumscribes the circle of the given radius or diam.
// Example:
//   prism(n=6, h=3, d=4, circum=true);
module prism(n=3, h=1, l=1, r=undef, d=undef, circum=false, center=false)
{
	cm = circum? 1/cos(180/n) : 1.0;
	radius = (r!=undef)? r*cm : ((d!=undef)? d*cm/2 : (l/(2*sin(180/n))));
	zrot(180/n) cylinder(r=radius, h=h, center=center, $fn=n);
}


// Creates a trapezoidal prism.
//   size1 = [width, length] of the bottom of the prism.
//   size2 = [width, length] of the top of the prism.
//   h = Height of the prism.
//   center = vertically center the prism.
// Example:
//   trapezoid(size1=[1,4], size2=[4,1], h=4, center=false);
//   trapezoid(size1=[2,6], size2=[4,0], h=4, center=false);
module trapezoid(size1=[1,1], size2=[1,1], h=1, center=false)
{
	ave = (size1 + size2)/2;
	render(convexity=3)
	up(center? 0 : h/2) {
		linear_extrude(height=h/2, scale=[size2[0]/ave[0],size2[1]/ave[1]])
			square(ave, center=true);
		mirror([0,0,1])
			linear_extrude(height=h/2, scale=[size1[0]/ave[0],size1[1]/ave[1]])
				square(ave, center=true);
	}
}


module onion(h=1, r=1, d=undef, maxang=45)
{
	rr = (d!=undef)? (d/2.0) : r;
	xx = rr*cos(maxang);
	yy = rr*sin(maxang);
	hh = h-yy;
	if (maxang < 0.01) {
		cylinder(h=h, r=rr);
		sphere(r=rr);
	} else if (hh <= 0) {
		up(h) bottom_half(2.1*rr) down(h) sphere(r=rr);
	} else {
		x2 = hh/tan(90-maxang);
		if (x2 <= xx) {
			up(yy) {
				bottom_half(2.1*rr) down(yy) sphere(r=rr);
				down(0.05) cylinder(h=hh+0.05, r1=xx, r2=xx-x2);
			}
		} else {
			h2 = xx*tan(90-maxang);
			up(yy) {
				bottom_half(2.1*rr) down(yy) sphere(r=rr);
				down(0.05) cylinder(h=h2+0.05, r1=xx, r2=0);
			}
		}
	}
}


// Makes a hollow tube with the given outer size and wall thickness.
//   h = height of tube. (Default: 1)
//   r = Outer radius of tube.  (Default: 1)
//   r1 = Outer radius of bottom of tube.  (Default: value of r)
//   r2 = Outer radius of top of tube.  (Default: value of r)
//   wall = horizontal thickness of tube wall. (Default 0.5)
// Example:
//   tube(h=3, r=4, wall=1, center=true);
//   tube(h=6, r=4, wall=2, $fn=6);
//   tube(h=3, r1=5, r2=7, wall=2, center=true);
module tube(h=1, r=1, r1=undef, r2=undef, wall=0.5, center=false)
{
	r1 = (r1==undef)? r : r1;
	r2 = (r2==undef)? r : r2;
	difference() {
		cylinder(h=h, r1=r1, r2=r2, center=center);
		cylinder(h=h+0.03, r1=r1-wall, r2=r2-wall, center=center);
	}
}


// Creates a torus with a given outer radius and inner radius.
//   or = outer radius of the torus.
//   ir = inside radius of the torus.
// Example:
//   torus(or=30, ir=20, $fa=1, $fs=1);
module torus(or=1, ir=0.5)
{
	rotate_extrude(convexity = 4)
		translate([(or-ir)/2+ir, 0, 0])
			circle(r = (or-ir)/2);
}


// Makes a linear slot with rounded ends, appropriate for bolts to slide along.
//   p1 = center of starting circle of slot.  (Default: [0,0,0])
//   p2 = center of ending circle of slot.  (Default: [1,0,0])
//   h = height of slot shape. (default: 1.0)
//   r = radius of slot circle. (default: 0.5)
//   r1 = bottom radius of slot cone. (use instead of r)
//   r2 = top radius of slot cone. (use instead of r)
//   d = diameter of slot circle. (default: 1.0)
//   d1 = bottom diameter of slot cone. (use instead of d)
//   d2 = top diameter of slot cone. (use instead of d)
module slot(
	p1=[0,0,0], p2=[1,0,0], h=1.0,
	r=undef, r1=undef, r2=undef,
	d=1.0, d1=undef, d2=undef
) {
	r  = (r  != undef)? r  : (d/2);
	r1 = (r1 != undef)? r1 : ((d1 != undef)? (d1/2) : r);
	r2 = (r2 != undef)? r2 : ((d2 != undef)? (d2/2) : r);
	delta = p2 - p1;
	echo(delta);
	theta = atan2(delta[1], delta[0]);
	echo(theta);
	xydist = sqrt(pow(delta[0],2) + pow(delta[1],2));
	phi = atan2(delta[2], xydist);
	echo(phi);
	dist = sqrt(pow(delta[2],2) + xydist*xydist);
	echo(dist);
	$fn = quantup(segs(max(r1,r2)),4);
	echo($fn);
	translate(p1) {
		zrot(theta) {
			yrot(phi) {
				cylinder(h=h, r1=r1, r2=r2, center=true);
				right(dist/2) trapezoid([dist, r1*2], [dist, r2*2], h=h, center=true);
				right(dist) cylinder(h=h, r1=r1, r2=r2, center=true);
			}
		}
	}
}


// Makes an arced slot, appropriate for bolts to slide along.
//   cp = centerpoint of slot arc. (default: [0, 0, 0])
//   h = height of slot arc shape. (default: 1.0)
//   r = radius of slot arc. (default: 0.5)
//   d = diameter of slot arc. (default: 1.0)
//   sr = radius of slot channel. (default: 0.5)
//   sd = diameter of slot channel. (default: 0.5)
//   sr1 = bottom radius of slot channel cone. (use instead of sr)
//   sr2 = top radius of slot channel cone. (use instead of sr)
//   sd1 = bottom diameter of slot channel cone. (use instead of sd)
//   sd2 = top diameter of slot channel cone. (use instead of sd)
//   sa = starting angle. (Default: 0.0)
//   ea = ending angle. (Default: 90.0)
// Examples:
//   arced_slot(d=100, h=15, sd=10, sa=60, ea=280);
//   arced_slot(r=100, h=10, sd1=30, sd2=10, sa=45, ea=180, $fa=5, $fs=2);
module arced_slot(
	cp=[0,0,0],
	r=undef, d=1.0, h=1.0,
	sr=undef, sr1=undef, sr2=undef,
	sd=1.0, sd1=undef, sd2=undef,
	sa=0, ea=90
) {
	r  = (r  != undef)? r  : (d/2);
	sr  = (sr  != undef)? sr  : (sd/2);
	sr1 = (sr1 != undef)? sr1 : ((sd1 != undef)? (sd1/2) : sr);
	sr2 = (sr2 != undef)? sr2 : ((sd2 != undef)? (sd2/2) : sr);
	da = ea - sa;
	zrot(sa) {
		translate([r, 0, 0]) cylinder(h=h, r1=sr1, r2=sr2, center=true);
		difference() {
			angle_pie_mask(h=h, r1=(r+sr1), r2=(r+sr2), ang=da);
			cylinder(h=h+1, r1=(r-sr1), r2=(r-sr2), center=true);
		}
		zrot(da) {
			translate([r, 0, 0]) cylinder(h=h, r1=sr1, r2=sr2, center=true);
		}
	}
}


// Makes a teardrop shape in the XZ plane. Useful for 3D printable holes.
//   r = radius of circular part of teardrop.  (Default: 1)
//   h = thickness of teardrop. (Default: 1)
// Example:
//   teardrop(r=3, h=2, ang=30);
module teardrop(r=1, h=1, ang=45, $fn=undef)
{
	$fn = ($fn==undef)?max(12,floor(180/asin(1/r)/2)*2):$fn;
	xrot(90) union() {
		translate([0, r*sin(ang), 0]) {
			scale([1, 1/tan(ang), 1]) {
				difference() {
					zrot(45) {
						cube(size=[2*r*cos(ang)/sqrt(2), 2*r*cos(ang)/sqrt(2), h], center=true);
					}
					translate([0, -r/2, 0]) {
						cube(size=[2*r, r, h+1], center=true);
					}
				}
			}
		}
		cylinder(h=h, r=r, center=true);
	}
}


// Makes a rectangular strut with the top side narrowing in a triangle.
// The shape created may be likened to an extruded home plate from baseball.
// This is useful for constructing parts that minimize the need to support
// overhangs.
//   w = Width (thickness) of the strut.
//   l = Length of the strut.
//   wall = height of rectangular portion of the strut.
//   ang = angle that the trianglar side will converge at.
// Example:
//   narrowing_strut(w=10, l=100, wall=5, ang=30);
module narrowing_strut(w=10, l=100, wall=5, ang=30)
{
	union() {
		translate([0, 0, wall/2])
			cube(size=[w, l, wall], center=true);
		difference() {
			translate([0, 0, wall])
				scale([1, 1, 1/tan(ang)]) yrot(45)
					cube(size=[w/sqrt(2), l, w/sqrt(2)], center=true);
			translate([0, 0, -w+0.05])
				cube(size=[w+1, l+1, w*2], center=true);
		}
	}
}


// Makes a rectangular wall which thins to a smaller width in the center,
// with angled supports to prevent critical overhangs.
//   h = height of wall.
//   l = length of wall.
//   thick = thickness of wall.
//   ang = maximum overhang angle of diagonal brace.
//   strut = the width of the diagonal brace.
//   wall = the thickness of the thinned portion of the wall.
//   bracing = boolean, denoting that the wall should have diagonal cross-braces.
// Example:
//   thinning_wall(h=50, l=100, thick=4, ang=30, strut=5, wall=2);
module thinning_wall(h=50, l=100, thick=5, ang=30, strut=5, wall=3, bracing=true)
{
	dang = atan((h-2*strut)/(l-2*strut));
	dlen = (h-2*strut)/sin(dang);
	union() {
		xrot_copies([0, 180]) {
			translate([0, 0, -h/2])
				narrowing_strut(w=thick, l=l, wall=strut, ang=ang);
			translate([0, -l/2, 0])
				xrot(-90) narrowing_strut(w=thick, l=h-0.1, wall=strut, ang=ang);
			if (bracing == true) {
				intersection() {
					cube(size=[thick, l, h], center=true);
					xrot_copies([-dang,dang]) {
						grid_of(za=[-strut/4, strut/4]) {
							scale([1,1,1.5]) yrot(45) {
								cube(size=[thick/sqrt(2), dlen, thick/sqrt(2)], center=true);
							}
						}
						cube(size=[thick, dlen, strut/2], center=true);
					}
				}
			}
		}
		cube(size=[wall, l-0.1, h-0.1], center=true);
	}
}


// Makes a triangular wall with thick edges, which thins to a smaller width in
// the center, with angled supports to prevent critical overhangs.
//   h = height of wall.
//   l = length of wall.
//   thick = thickness of wall.
//   ang = maximum overhang angle of diagonal brace.
//   strut = the width of the diagonal brace.
//   wall = the thickness of the thinned portion of the wall.
//   diagonly = boolean, which denotes only the diagonal brace should be thick.
// Example:
//   thinning_triangle(h=50, l=100, thick=4, ang=30, strut=5, wall=2, diagonly=true);
module thinning_triangle(h=50, l=100, thick=5, ang=30, strut=5, wall=3, diagonly=false)
{
	dang = atan(h/l);
	dlen = h/sin(dang);
	difference() {
		union() {
			if (!diagonly) {
				translate([0, 0, -h/2])
					narrowing_strut(w=thick, l=l, wall=strut, ang=ang);
				translate([0, -l/2, 0])
					xrot(-90) narrowing_strut(w=thick, l=h-0.1, wall=strut, ang=ang);
			}
			intersection() {
				cube(size=[thick, l, h], center=true);
				xrot(-dang) yrot(180) {
					narrowing_strut(w=thick, l=dlen*1.2, wall=strut, ang=ang);
				}
			}
			cube(size=[wall, l-0.1, h-0.1], center=true);
		}
		xrot(-dang) {
			translate([0, 0, h/2]) {
				cube(size=[thick+0.1, l*2, h], center=true);
			}
		}
	}
}


// Makes a triangular wall which thins to a smaller width in the center,
// with angled supports to prevent critical overhangs.  Basically an alias
// of thinning_triangle(), with diagonly=true.
//   h = height of wall.
//   l = length of wall.
//   thick = thickness of wall.
//   ang = maximum overhang angle of diagonal brace.
//   strut = the width of the diagonal brace.
//   wall = the thickness of the thinned portion of the wall.
// Example:
//   thinning_brace(h=50, l=100, thick=4, ang=30, strut=5, wall=2);
module thinning_brace(h=50, l=100, thick=5, ang=30, strut=5, wall=3)
{
	thinning_triangle(h=h, l=l, thick=thick, ang=ang, strut=strut, wall=wall, diagonly=true);
}


// Makes an open rectangular strut with X-shaped cross-bracing, designed with 3D printing in mind.
//   h = height of strut wall.
//   l = length of strut wall.
//   thick = thickness of strut wall.
//   maxang = maximum overhang angle of cross-braces.
//   max_bridge = maximum bridging distance between cross-braces.
//   strut = the width of the cross-braces.
// Example:
//   sparse_strut(h=40, l=120, thick=4, maxang=30, strut=5, max_bridge=20);
module sparse_strut(h=50, l=100, thick=4, maxang=30, strut=5, max_bridge = 20)
{

	zoff = h/2 - strut/2;
	yoff = l/2 - strut/2;

	maxhyp = 1.5 * (max_bridge+strut)/2 / sin(maxang);
	maxz = 2 * maxhyp * cos(maxang);

	zreps = ceil(2*zoff/maxz);
	zstep = 2*zoff / zreps;

	hyp = zstep/2 / cos(maxang);
	maxy = min(2 * hyp * sin(maxang), max_bridge+strut);

	yreps = ceil(2*yoff/maxy);
	ystep = 2*yoff / yreps;

	ang = atan(ystep/zstep);
	len = zstep / cos(ang);

	union() {
		grid_of(za=[-zoff, zoff])
			cube(size=[thick, l, strut], center=true);
		grid_of(ya=[-yoff, yoff])
			cube(size=[thick, strut, h], center=true);
		grid_of(ya=[-yoff+ystep/2:ystep:yoff], za=[-zoff+zstep/2:zstep:zoff]) {
			xrot( ang) cube(size=[thick, strut, len], center=true);
			xrot(-ang) cube(size=[thick, strut, len], center=true);
		}
	}
}


// Makes a corrugated wall which relieves contraction stress while still
// providing support strength.  Designed with 3D printing in mind.
//   h = height of strut wall.
//   l = length of strut wall.
//   thick = thickness of strut wall.
//   strut = the width of the cross-braces.
//   wall = thickness of corrugations.
// Example:
//   corrugated_wall(h=50, l=100, thick=4, strut=5, wall=2);
module corrugated_wall(h=50, l=100, thick=5, strut=5, wall=2)
{
	innerlen = l - strut*2;
	inner_height = h - wall*2;
	spacing = thick*sqrt(3);
	corr_count = floor(innerlen/spacing/2)*2;

	grid_of(ya=[-(l-strut)/2, (l-strut)/2]) {
		cube(size=[thick, strut, h], center=true);
	}
	grid_of(za=[-(h-wall)/2, (h-wall)/2]) {
		cube(size=[thick, l, wall], center=true);
	}

	prerender(convexity=corr_count*4+4)
	difference() {
		for (ypos = [-innerlen/2:spacing:innerlen/2]) {
			translate([0, ypos, 0]) {
				translate([0, spacing/4, 0])
					zrot(-45) cube(size=[wall, thick*sqrt(2), inner_height], center=true);
				translate([0, spacing*3/4, 0])
					zrot(45) cube(size=[wall, thick*sqrt(2), inner_height], center=true);
			}
		}
		grid_of(xa=[-thick, thick]) {
			cube(size=[thick, l, h], center=true);
		}
		grid_of(ya=[-l, l]) {
			cube(size=[thick*2, l, h], center=true);
		}
	}
}



//////////////////////////////////////////////////////////////////////
// Screws, Bolts, and Nuts.
//////////////////////////////////////////////////////////////////////


function get_metric_bolt_head_size(size) = lookup(size, [
		[ 4.0,  7.0],
		[ 5.0,  8.0],
		[ 6.0, 10.0],
		[ 7.0, 11.0],
		[ 8.0, 13.0],
		[10.0, 16.0],
		[12.0, 18.0],
		[14.0, 21.0],
		[16.0, 24.0],
		[18.0, 27.0],
		[20.0, 30.0]
	]);


function get_metric_nut_size(size) = lookup(size, [
		[ 2.0,  4.0],
		[ 2.5,  5.0],
		[ 3.0,  5.5],
		[ 4.0,  7.0],
		[ 5.0,  8.0],
		[ 6.0, 10.0],
		[ 7.0, 11.0],
		[ 8.0, 13.0],
		[10.0, 17.0],
		[12.0, 19.0],
		[14.0, 22.0],
		[16.0, 24.0],
		[18.0, 27.0],
		[20.0, 30.0],
	]);


function get_metric_nut_thickness(size) = lookup(size, [
		[ 2.0,  1.6],
		[ 2.5,  2.0],
		[ 3.0,  2.4],
		[ 4.0,  3.2],
		[ 5.0,  4.0],
		[ 6.0,  5.0],
		[ 7.0,  5.5],
		[ 8.0,  6.5],
		[10.0,  8.0],
		[12.0, 10.0],
		[14.0, 11.0],
		[16.0, 13.0],
		[18.0, 15.0],
		[20.0, 16.0]
	]);


// Makes a simple threadless screw, useful for making screwholes.
//   screwsize = diameter of threaded part of screw.
//   screwlen = length of threaded part of screw.
//   headsize = diameter of the screw head.
//   headlen = length of the screw head.
// Example:
//   screw(screwsize=3,screwlen=10,headsize=6,headlen=3);
module screw(screwsize=3,screwlen=10,headsize=6,headlen=3,$fn=undef)
{
	$fn = ($fn==undef)?max(8,floor(180/asin(2/screwsize)/2)*2):$fn;
	translate([0,0,-(screwlen)/2])
		cylinder(r=screwsize/2, h=screwlen+0.05, center=true, $fn=$fn);
	translate([0,0,(headlen)/2])
		cylinder(r=headsize/2, h=headlen, center=true, $fn=$fn*2);
}


// Makes an unthreaded model of a standard nut for a standard metric screw.
//   size = standard metric screw size in mm. (Default: 3)
//   hole = include an unthreaded hole in the nut.  (Default: true)
// Example:
//   metric_nut(size=8, hole=true);
//   metric_nut(size=3, hole=false);
module metric_nut(size=3, hole=true, $fn=undef, center=false)
{
	$fn = ($fn==undef)?max(8,floor(180/asin(2/size)/2)*2):$fn;
	radius = get_metric_nut_size(size)/2/cos(30);
	thick = get_metric_nut_thickness(size);
	offset = (center == true)? 0 : thick/2;
	translate([0,0,offset]) difference() {
		cylinder(r=radius, h=thick, center=true, $fn=6);
		if (hole == true)
			cylinder(r=size/2, h=thick+0.5, center=true, $fn=$fn);
	}
}



//////////////////////////////////////////////////////////////////////
// Linear Bearings.
//////////////////////////////////////////////////////////////////////


function get_lmXuu_bearing_diam(size) = lookup(size, [
		[  4.0,   8.0],
		[  5.0,  10.0],
		[  6.0,  12.0],
		[  8.0,  15.0],
		[ 10.0,  19.0],
		[ 12.0,  21.0],
		[ 13.0,  23.0],
		[ 16.0,  28.0],
		[ 20.0,  32.0],
		[ 25.0,  40.0],
		[ 30.0,  45.0],
		[ 35.0,  52.0],
		[ 40.0,  60.0],
		[ 50.0,  80.0],
		[ 60.0,  90.0],
		[ 80.0, 120.0],
		[100.0, 150.0]
	]);


function get_lmXuu_bearing_length(size) = lookup(size, [
		[  4.0,  12.0],
		[  5.0,  15.0],
		[  6.0,  19.0],
		[  8.0,  24.0],
		[ 10.0,  29.0],
		[ 12.0,  30.0],
		[ 13.0,  32.0],
		[ 16.0,  37.0],
		[ 20.0,  42.0],
		[ 25.0,  59.0],
		[ 30.0,  64.0],
		[ 35.0,  70.0],
		[ 40.0,  80.0],
		[ 50.0, 100.0],
		[ 60.0, 110.0],
		[ 80.0, 140.0],
		[100.0, 175.0]
	]);


// Creates a model of a clamp to hold a given linear bearing cartridge.
//   d = Diameter of linear bearing. (Default: 15)
//   l = Length of linear bearing. (Default: 24)
//   tab = Clamp tab height. (Default: 7)
//   tabwall = Clamp Tab thickness. (Default: 5)
//   wall = Wall thickness of clamp housing. (Default: 3)
//   gap = Gap in clamp. (Default: 5)
//   screwsize = Size of screw to use to tighten clamp. (Default: 3)
module linear_bearing_housing(d=15,l=24,tab=7,gap=5,wall=3,tabwall=5,screwsize=3)
{
	od = d+2*wall;
	ogap = gap+2*tabwall;
	tabh = tab/2+od/2*sqrt(2)-ogap/2;
	translate([0,0,od/2]) difference() {
		union() {
			rotate([0,0,90])
				teardrop(r=od/2,h=l);
			translate([0,0,tabh])
				cube(size=[l,ogap,tab+0.05], center=true);
			translate([0,0,-od/4])
				cube(size=[l,od,od/2], center=true);
		}
		rotate([0,0,90])
			teardrop(r=d/2,h=l+0.05);
		translate([0,0,(d*sqrt(2)+tab)/2])
			cube(size=[l+0.05,gap,d+tab], center=true);
		translate([0,0,tabh]) {
			translate([0,-ogap/2+2-0.05,0])
				rotate([90,0,0])
					screw(screwsize=screwsize*1.06, screwlen=ogap, headsize=screwsize*2, headlen=10);
			translate([0,ogap/2+0.05,0])
				rotate([90,0,0])
					metric_nut(size=screwsize,hole=false);
		}
	}
}


module lmXuu_housing(size=8,tab=7,gap=5,wall=3,tabwall=5,screwsize=3)
{
	d = get_lmXuu_bearing_diam(size);
	l = get_lmXuu_bearing_length(size);
	linear_bearing_housing(d=d,l=l,tab=tab,gap=gap,wall=wall,tabwall=tabwall,screwsize=screwsize);
}
//lmXuu_housing(size=8);
//lmXuu_housing(size=10);



//////////////////////////////////////////////////////////////////////
// Helper functions.
//////////////////////////////////////////////////////////////////////


// Quantize a value x to an integer multiple of y, rounding to the nearest multiple.
function quant(x,y) = floor(x/y+0.5)*y;


// Quantize a value x to an integer multiple of y, rounding down to the previous multiple.
function quantdn(x,y) = floor(x/y)*y;

// Quantize a value x to an integer multiple of y, rounding up to the next multiple.
function quantup(x,y) = ceil(x/y)*y;


// Calculate OpenSCAD standard number of segments in a circle based on $fn, $fa, and $fs.
//   r = radius of circle to get the number of segments for.
function segs(r) = $fn>0?($fn>3?$fn:3):(ceil(max(min(360.0/$fa,abs(r)*2*3.14159/$fs),5)));


// Calculate hypotenuse of X by Y triangle.
function hypot(x,y) = sqrt(x*x+y*y);


// Returns all but the first item of a given array.
function cdr(list) = len(list)>1?[for (i=[1:len(list)-1]) list[i]]:[];


// Reverses a list/array.
function reverse(list) = [ for (i = [len(list)-1 : -1 : 0]) list[i] ];


// Returns a 3D vector/point from a 2D or 3D vector.
function point3d(point) = [point[0], point[1], ((len(point) < 3)? 0 : point[2])];


// Returns an array of 3D vectors/points from a 2D or 3D vector array.
function path3d(points) = [for (point = points) point3d(point)];


// returns the distance between a pair of 2D or 3D points.
function distance(point1, point2) = let(
		delta = point3d(point2) - point3d(point1)
	) sqrt(delta[0]*delta[0] + delta[1]*delta[1] + delta[2]*delta[2]);


// Create an identity matrix, for a given number of axes.
function ident(axes) = [for (i = [0:axes-1]) [for (j = [0:axes-1]) (i==j)?1:0]];


// Create an identity matrix, for 3 axes.
ident3 = ident(3);


// Mathematical rotation of a vector around the X axis.
//   ang = number of degrees to rotate.
function matrix3_xrot(ang) = [
	[1,        0,         0],
	[0, cos(ang), -sin(ang)],
	[0, sin(ang),  cos(ang)]
];


// Mathematical rotation of a vector around the Y axis.
//   ang = number of degrees to rotate.
function matrix3_yrot(ang) = [
	[ cos(ang), 0, sin(ang)],
	[        0, 1,        0],
	[-sin(ang), 0, cos(ang)],
];


// Mathematical rotation of a vector around the Z axis.
//   ang = number of degrees to rotate.
function matrix3_zrot(ang) = [
	[cos(ang), -sin(ang), 0],
	[sin(ang),  cos(ang), 0],
	[       0,         0, 1]
];


// Mathematical rotation of a vector around an axis.
//   u = axis vector to rotate around.
//   ang = number of degrees to rotate.
function matrix3_rot_by_axis(u, ang) = let(
	c = cos(ang), c2 = 1-c, s = sin(ang)
) [
	[u[0]*u[0]*c2+c,      u[0]*u[1]*c2-u[2]*s, u[0]*u[2]*c2+u[1]*s],
	[u[1]*u[0]*c2+u[2]*s, u[1]*u[1]*c2+c,      u[1]*u[2]*c2-u[0]*s],
	[u[2]*u[0]*c2-u[1]*s, u[2]*u[1]*c2+u[0]*s, u[2]*u[2]*c2+c     ]
];


// Gives the sum of a series of sines, at a given angle.
//   a = angle to get the value for.
//   sines = array of [amplitude, frequency] pairs, where the frequency is the
//           number of times the cycle repeats around the circle.
function sum_of_sines(a,sines) = len(sines)==0? 0 :
	len(sines)==1?sines[0][0]*sin(a*sines[0][1]+(len(sines[0])>2?sines[0][2]:0)):
	sum_of_sines(a,[sines[0]])+sum_of_sines(a,cdr(sines));



//////////////////////////////////////////////////////////////////////
// 2D and Bezier Stuff.
//////////////////////////////////////////////////////////////////////


// Creates a 2D polygon circle, modulated by one or more superimposed
// sine waves.
//   r = radius of the base circle.
//   sines = array of [amplitude, frequency] pairs, where the frequency is the
//           number of times the cycle repeats around the circle.
// Example:
//   modulated_circle(r=40, sines=[[3, 11], [1, 31]], $fn=6);
module modulated_circle(r=40, sines=[10])
{
	freqs = len(sines)>0? [for (i=sines) i[1]] : [5];
	points = [
		for (a = [0 : (360/segs(r)/max(freqs)) : 360])
			let(nr=r+sum_of_sines(a,sines)) [nr*cos(a), nr*sin(a)]
	];
	polygon(points);
}


// Similar to linear_extrude(), except the result is a hollow shell.
//   wall = thickness of shell wall.
//   height = height of extrusion.
//   twist = degrees of twist, from bottom to top.
//   slices = how many slices to use when making extrusion.
// Example:
//   extrude_2d_hollow(wall=2, height=100, twist=90, slices=50)
//     circle(r=40, center=true, $fn=6);
module extrude_2d_hollow(wall=2, height=50, twist=90, slices=60)
{
	linear_extrude(height=height, twist=twist, slices=slices) {
		difference() {
			children();
			offset(r=-wall) {
				children();
			}
		}
	}
}


function vector2d_angle(v1,v2) = atan2(v1[1],v1[0]) - atan2(v2[1],v2[0]);
function vector3d_angle(v1,v2) = acos((v1*v2)/(norm(v1)*norm(v2)));

function slice(arr,st,end) = let(
		s=st<0?(len(arr)+st):st,
		e=end<0?(len(arr)+end+1):end
	) [for (i=[s:e-1]) if (e>s) arr[i]];


function simplify2d_path(path) = concat(
	[path[0]],
	[
		for (
			i = [1:len(path)-2]
		) let (
			v1 = path[i] - path[i-1],
			v2 = path[i+1] - path[i-1]
		) if (abs(cross(v1,v2)) > 1e-6) path[i]
	],
	[path[len(path)-1]]
);

function simplify3d_path(path) = concat(
	[path[0]],
	[
		for (
			i = [1:len(path)-2]
		) let (
			v1 = path[i] - path[i-1],
			v2 = path[i+1] - path[i-1]
		) if (vector3d_angle(v1,v2) > 1e-6) path[i]
	],
	[path[len(path)-1]]
);



// Formulae to calculate points on a cubic bezier curve.
function bez_B0(curve,u) = curve[0]*pow((1-u),3);
function bez_B1(curve,u) = curve[1]*(3*u*pow((1-u),2));
function bez_B2(curve,u) = curve[2]*(3*pow(u,2)*(1-u));
function bez_B3(curve,u) = curve[3]*pow(u,3);
function bez_point(curve,u) = bez_B0(curve,u) + bez_B1(curve,u) + bez_B2(curve,u) + bez_B3(curve,u);

function bezier_polyline(bezier, splinesteps=16) = concat(
	[
		for (
			b = [0 : 3 : len(bezier)-4],
			l = [0 : splinesteps-1]
		) let (
			crv = [bezier[b+0], bezier[b+1], bezier[b+2], bezier[b+3]],
			u = l / splinesteps
		) bez_point(crv, u)
	],
	[bez_point([bezier[len(bezier)-4], bezier[len(bezier)-3], bezier[len(bezier)-2], bezier[len(bezier)-1]], 1.0)]
);


// Takes a closed 2D bezier path, and creates a 2D polygon from it.
module bezier_polygon(bezier, splinesteps=16) {
	polypoints=bezier_polyline(bezier, splinesteps);
	polygon(points=slice(polypoints, 0, -1));
}


// Takes a closed 2D bezier and rotates it around the X axis, forming a solid.
//   bezier = array of points for the bezier path to rotate.
//   splinesteps = number of segments to divide each bezier segment into.
// Example:
//   path = [
//     [  0, 10], [ 50,  0], [ 50, 40],
//     [ 95, 40], [100, 40], [100, 45],
//     [ 95, 45], [ 66, 45], [  0, 20],
//     [  0, 12], [  0, 12], [  0, 10],
//     [  0, 10]
//   ];
//   revolve_bezier(path, splinesteps=32, $fn=180);
module revolve_bezier(bezier, splinesteps=16) {
	yrot(90) rotate_extrude(convexity=10) {
		xrot(180) zrot(-90) bezier_polygon(bezier, splinesteps);
	}
}


// Takes a bezier path and closes it to the X axis.
function bezier_close_to_axis(bezier) =
	let(bezend = len(bezier)-1)
		concat(
			[ [bezier[0][0], 0], [bezier[0][0], 0], bezier[0] ],
			bezier,
			[ bezier[bezend], [bezier[bezend][0], 0], [bezier[bezend][0], 0] ]
		);


// Takes a bezier curve and closes it with a matching path that is
// lowered by a given amount towards the X axis.
function bezier_offset(inset, bezier) =
	let(backbez = reverse([ for (pt = bezier) [pt[0], pt[1]-inset] ]))
		concat(
			bezier,
			[bezier[len(bezier)-1]],
			[backbez[0]],
			backbez,
			[backbez[len(backbez)-1]],
			[bezier[0]],
			[bezier[0]]
		);


// Takes a 2D bezier and rotates it around the X axis, forming a solid.
//   bezier = array of points for the bezier path to rotate.
//   splinesteps = number of segments to divide each bezier segment into.
// Example:
//   path = [ [0, 10], [33, 10], [66, 40], [100, 40] ];
//   revolve_bezier_solid_to_axis(path, splinesteps=32, $fn=72);
module revolve_bezier_solid_to_axis(bezier, splinesteps=16) {
	revolve_bezier(bezier=bezier_close_to_axis(bezier), splinesteps=splinesteps);
}


// Takes a 2D bezier and rotates it around the X axis, into a hollow shell.
//   bezier = array of points for the bezier path to rotate.
//   offset = the thickness of the created shell.
//   splinesteps = number of segments to divide each bezier segment into.
// Example:
//   path = [ [0, 10], [33, 10], [66, 40], [100, 40] ];
//   revolve_bezier_offset_shell(path, offset=1, splinesteps=32, $fn=72);
module revolve_bezier_offset_shell(bezier, offset=1, splinesteps=16) {
	revolve_bezier(bezier=bezier_offset(offset, bezier), splinesteps=splinesteps);
}


// Extrudes 2D children along a bezier path.
//   bezier = array of points for the bezier path to extrude along.
//   splinesteps = number of segments to divide each bezier segment into.
// Example:
//   path = [ [0, 0, 0], [33, 33, 33], [66, -33, -33], [100, 0, 0] ];
//   extrude_2d_shapes_along_bezier(path, splinesteps=32)
//     circle(r=10, center=true);
module extrude_2d_shapes_along_bezier(bezier, splinesteps=16) {
	pointslist = slice(bezier_polyline(bezier, splinesteps), 0, -1);
	ptcount = len(pointslist);
	for (i = [0 : ptcount-2]) {
		pt1 = pointslist[i];
		pt2 = pointslist[i+1];
		pt0 = i==0? pt1 : pointslist[i-1];
		pt3 = (i>=ptcount-2)? pt2 : pointslist[i+2];
		dist = distance(pt1,pt2);
		v1 = pt2-pt1;
		v0 = (i==0)? v1 : (pt1-pt0);
		v2 = (i==ptcount-2)? v1 : (pt3-pt2);
		az1 = atan2(v1[1], v1[0]);
		alt1 = (len(pt1)<3)? 0 : atan2(v1[2], hypot(v1[1], v1[0]));
		az0 = atan2(v0[1], v0[0]);
		alt0 = (len(pt0)<3)? 0 : atan2(v0[2], hypot(v0[1], v0[0]));
		az2 = atan2(v2[1], v2[0]);
		alt2 = (len(pt2)<3)? 0 : atan2(v2[2], hypot(v2[1], v2[0]));
		translate(pt1) {
			difference() {
				rotate([0, 90-alt1, az1]) {
					translate([0, 0, -1]) {
						linear_extrude(height=dist*3, convexity=10) {
							children();
						}
					}
				}
				rotate([0, 90-(alt0+alt1)/2, (az0+az1)/2]) {
					translate([0, 0, -dist-0.05]) {
						cube(size=[99,99,dist*2], center=true);
					}
				}
				rotate([0, 90-(alt1+alt2)/2, (az1+az2)/2]) {
					translate([0, 0, dist+dist]) {
						cube(size=[99,99,dist*2], center=true);
					}
				}
			}
		}
	}
}


// Takes a closed 2D polyline path, centered on the XY plane, and
// extrudes it along a 3D spiral path of a given radius, height and twist.
//   polyline = Array of points of a polyline path, to be extruded.
//   h = height of the spiral to extrude along.
//   r = radius of the spiral to extrude along.
//   twist = number of degrees of rotation to spiral up along height.
// Example:
//   poly = [[-10,0], [-3,-5], [3,-5], [10,0], [0,-30]];
//   extrude_2dpath_along_spiral(poly, h=200, r=50, twist=1000, $fn=36);
module extrude_2dpath_along_spiral(polyline, h, r, twist=360) {
	pline_count = len(polyline);
	steps = ceil(segs(r)*(twist/360));

	poly_points = [
		for (
			p = [0:steps]
		) let (
			a = twist * (p/steps),
			dx = r*cos(a),
			dy = r*sin(a),
			dz = h * (p/steps),
			cp = [dx, dy, dz],
			rotx = matrix3_xrot(90),
			rotz = matrix3_zrot(a),
			rotm = rotz * rotx
		) for (
			b = [0:pline_count-1]
		) rotm*point3d(polyline[b])+cp
	];

	poly_faces = concat(
		[[for (b = [0:pline_count-1]) b]],
		[
			for (
				p = [0:steps-1],
				b = [0:pline_count-1],
				i = [0:1]
			) let (
				b2 = (b == pline_count-1)? 0 : b+1,
				p0 = p * pline_count + b,
				p1 = p * pline_count + b2,
				p2 = (p+1) * pline_count + b2,
				p3 = (p+1) * pline_count + b,
				pt = (i==0)? [p0, p1, p2] : [p0, p2, p3]
			) pt
		],
		[[for (b = [0:pline_count-1]) b+(steps)*pline_count]]
	);

	polyhedron(points=poly_points, faces=poly_faces, convexity=10);
}


// Takes a closed 2D polyline path, centered on the XY plane, and
// extrudes it perpendicularly along a 3D polyline path, forming a solid.
//   polyline = Array of points of a polyline path, to be extruded.
//   path = Array of points of a polyline path, to extrude along.
//   tilt = True if extrusion should tilt vertically when following path.
// Example:
//   shape = [ [-15, 0], [25, -15], [-5, 10], [0, 10], [5, 10], [10, 5], [15, 0], [10, -5], [5, -10], [0, -10], [-5, -10], [-10, -5], [-15, 0] ];
//   path = [ [0, 0, 0], [33, 33, 33], [66, -33, -33], [100, 0, 0] ];
//   extrude_2dpath_along_3dpath(shape, path, tilt=false);
module extrude_2dpath_along_3dpath(polyline, path, tilt=true) {
	pline_count = len(polyline);
	path_count = len(path);

	poly_points = [
		for (p = [0:path_count-1]) let (
			ppt1 = path[p],
			ppt0 = (p==0)? ppt1 : path[p-1],
			ppt2 = (p==(path_count-1))? ppt1 : path[p+1],
			v = ppt2 - ppt0,
			xyr = hypot(v[1], v[0]),
			az = atan2(v[1], v[0]),
			alt = atan2(v[2], xyr),
			rotx = matrix3_xrot(90+(tilt?alt:0)),
			rotz = matrix3_zrot(az-90),
			rotm = rotz * rotx
		) for (b = [0:pline_count-1]) rotm*point3d(polyline[b])+ppt1
	];

	poly_faces = concat(
		[[for (b = [0:pline_count-1]) b]],
		[
			for (
				p = [0:path_count-2],
				b = [0:pline_count-1],
				i = [0:1]
			) let (
				b2 = (b == pline_count-1)? 0 : b+1,
				p0 = p * pline_count + b,
				p1 = p * pline_count + b2,
				p2 = (p+1) * pline_count + b2,
				p3 = (p+1) * pline_count + b,
				pt = (i==0)? [p0, p1, p2] : [p0, p2, p3]
			) pt
		],
		[[for (b = [0:pline_count-1]) b+(path_count-1)*pline_count]]
	);

	polyhedron(points=poly_points, faces=poly_faces, convexity=10);
}


// Takes a closed 2D bezier path, centered on the XY plane, and
// extrudes it perpendicularly along a 3D bezier path, forming a solid.
//   bezier = Array of points of a bezier path, to be extruded.
//   path = Array of points of a bezier path, to extrude along.
//   pathsteps = number of steps to divide each path segment into.
//   bezsteps = number of steps to divide each bezier segment into.
// Example:
//   bez = [ [-15, 0], [25, -15], [-5, 10], [0, 10], [5, 10], [10, 5], [15, 0], [10, -5], [5, -10], [0, -10], [-5, -10], [-10, -5], [-15, 0] ];
//   path = [ [0, 0, 0], [33, 33, 33], [66, -33, -33], [100, 0, 0] ];
//   extrude_bezier_along_bezier(bez, path, pathsteps=64, bezsteps=32);
module extrude_bezier_along_bezier(bezier, path, pathsteps=16, bezsteps=16) {
	bez_points = simplify2d_path(bezier_polyline(bezier, bezsteps));
	path_points = simplify3d_path(path3d(bezier_polyline(path, pathsteps)));
	extrude_polyline_along_path(bez_points, path_points);
}


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
