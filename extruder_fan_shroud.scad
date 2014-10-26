//fan_size = 40;
//fan_screw_spacing = 32;
//fan_screw_size = 3;

fan_size = 60;
fan_screw_spacing = 50;
fan_screw_size = 4;

wall_thickness = 2;
plate_thickness = 5;
shroud_angle = 60;

mount_spacing = 15.5;
mount_tang_width = 5;
mount_tang_length = 15;
mount_screw_size = 3;

$fa=5;
$fs=1.5;


module fanHingeMount(h=6, h2=-1, screwsize=3, spacing=15, hingewidth=3, hingelength=12)
{
  h2 = (h2<0)? h : h2;
  xoff = spacing/2 + hingewidth/2;
  translate([0,-h/2-(hingelength-h),h/2]) {
    difference() {
      union() {
        for (x = [-xoff,xoff]) {
          translate([x,0,0]) {
            union () {
              rotate([0,90,0])
                cylinder(h=hingewidth, r=h/2, center=true);
              translate([0,hingelength/2-h/2,h2/2-h/2])
                cube(size=[hingewidth,hingelength,h2],center=true);
            }
          }
        }
      }
      rotate([0,90,0])
        cylinder(h=hingewidth*2+spacing+0.1, r=screwsize/2, center=true);
    }
  }
}



module fanMountPlate(size=40,diam=35,thickness=4,screwsize=3,screwspacing=32,mountscrew=3)
{
  spacing = screwspacing / 2;
  union() {
    translate([0,0,thickness/2]) {
      difference() {
        cube(size = [size,size,thickness], center=true);
        difference() {
          cylinder(h=thickness+0.2, r=diam/2, center=true);
          cube(size=[2, diam, thickness+1], center=true);
          cube(size=[diam, 2, thickness+1], center=true);
        }
        for (x = [-spacing,spacing], y = [-spacing,spacing]) {
          translate([x,y,0])
            cylinder(h = thickness+0.1, r=screwsize/2, center=true);
        }
      }
    }
    translate([0,-size/2,0])
      fanHingeMount(h=screwsize*2.5, h2=thickness, screwsize=mountscrew, spacing=mount_spacing, hingewidth=mount_tang_width, hingelength=mount_tang_length);
  }
}



module fanShroud(ang=45, r=20, wall=2)
{
  c = r*2*cos(ang);
  h = c*sin(ang);
  b = sqrt(c*c-h*h);
  offset=r-b;
  head_angle = atan2(head_spacing, head_distance);
  union() {
    difference() {
      union() {
        translate([0, 0, h/2]) {
          difference() {
            union() {
              cylinder(h=h, r=r, center=true);
              translate([0, -r/2, 0])
                cube(size=[2*r*0.67, r, h], center=true);
            }
            cylinder(h=h+1, r=r-wall, center=true);
          }
        }
        translate([0, 0, h/2])
          cube(size=[wall, 2*r, h], center=true);
        translate([0, 0, h-wall/2])
          cylinder(h=wall, r=r, center=true);
      }
      translate([0,-offset,h])
        rotate([ang,0,0])
          translate([-r,-2*r,0])
            cube(size=[r*2,r*4,r*2], center=false);
      translate([0,-offset,h])
        rotate([ang-90,0,0])
          translate([-r,-2*r,0])
            cube(size=[r*2,r*4,r*2], center=false);
    }
    intersection() {
      translate([0,-offset,h])
        rotate([ang-90,0,0])
          translate([-r,-2*r,0])
            cube(size=[r*2,r*4,wall], center=false);
      union() {
        cylinder(h=h, r=r, center=false);
        translate([0, -r/2, h/2])
          cube(size=[2*r*0.67, r, h], center=true);
      }
    }
  }
}


module fanAssembly(size=40, wall=3, plateh=3, screwsize=3, screwspacing=32, ang=45)
{
  union () {
    fanMountPlate(
        size=size,
        diam=size-2*wall,
        thickness=plateh,
        screwsize=screwsize,
        screwspacing=screwspacing);

    translate([0,0,plateh])
    fanShroud(
        r=size/2,
        wall=wall,
        ang=ang);
  }
}



fanAssembly(
    size=fan_size,
    wall=wall_thickness,
    plateh=plate_thickness,
    screwsize=fan_screw_size,
    screwspacing=fan_screw_spacing,
    ang=shroud_angle);


