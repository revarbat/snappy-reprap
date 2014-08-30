![Snappy Full Rendering](https://github.com/revarbat/snappy-reprap/wiki/snappy_small.png)


snappy-reprap v0.90
===================

A parametric design for a cheap self-replicating 3D printer (reprap) that snaps together to minimize screws and non-printed parts.


Generating STL Files
====================
For all platforms, you will need to have OpenSCAD installed. You can download OpenSCAD from their website at [http://www.openscad.org](http://www.openscad.org)


OS X:
-----
Under OS X, you shouldn't need to change the Makefile.  It should set $OPENSCAD as:
```
OPENSCAD=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
```

To generate the STL model files, open a terminal to the snappy-reprap directory and type:
```
make
```


Linux:
------
Under Linux, you will need to edit the Makefile, and change $OPENSCAD to:
```
OPENSCAD=openscad
```
To generate the STL model files, open a terminal to the snappy-reprap directory and type:
```
make
```


Windows:
--------
Under Windows, you'll probably have to open each `*_part.scad` and `*_parts.scad` file individually and manually export the STL files.

You _might_ be able to run the makefile under CygWin, if you set $OPENSCAD to something like:
```
OPENSCAD="/Program Files/OpenSCAD/openscad.exe"
```


Assembly Instructions
=====================
Instructions on what to print, what non-printed parts to get, and what tools you need, can be found in the [Wiki]<https://github.com/revarbat/snappy-reprap/wiki>.


