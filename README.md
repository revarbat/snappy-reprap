![Snappy Full Rendering](https://github.com/revarbat/snappy-reprap/wiki/snappy_small.png)

Snappy-Reprap v1.1
==================

A parametric design for a cheap self-replicating 3D printer (reprap) that snaps together to minimize screws and non-printed parts.

Important Links:

What                 | URL
-------------------- | -------------------------------------------------------
GitHub Repository    | https://github.com/revarbat/snappy-reprap
Project Wiki         | https://github.com/revarbat/snappy-reprap/wiki
Bill of Materials    | https://github.com/revarbat/snappy-reprap/wiki/BOM
How to Assemble      | https://github.com/revarbat/snappy-reprap/wiki/Assembly
RepRap.org Wiki Page | http://reprap.org/wiki/Snappy
Dev Forum            | https://groups.google.com/forum/#!forum/snappy-reprap-dev

[![Join the chat at https://gitter.im/revarbat/snappy-reprap](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/revarbat/snappy-reprap?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


Generating STL Files
====================
For all platforms, you will need to have OpenSCAD installed. You can download OpenSCAD from their website at [http://www.openscad.org](http://www.openscad.org)


OS X:
-----
Under OS X, you'll need to make sure you have the Xcode command-line tools installed first.  You can get them by installing Xcode from the App Store.

You shouldn't need to change the Makefile.  It should set $OPENSCAD as:
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
Under Windows, you'll probably have to open and compile each `*_parts.scad` file individually and manually export the STL files.

You _might_ be able to run the makefile under CygWin, if you set $OPENSCAD to something like:
```
OPENSCAD="/Program Files/OpenSCAD/openscad.exe"
```

