#!/usr/bin/env python

import os
import os.path
import sys
import time
import struct
import argparse
import subprocess


guiscad_template = """\
use <{modulename}.scad>
lines = [
{linedata}
];
for (line = lines) {{
  delta = line[1]-line[0];
  dist = norm(delta);
  theta = atan2(delta[1],delta[0]);
  phi = atan2(delta[2],norm([delta[0],delta[1]]));
  translate(line[0])
    rotate([0, 90-phi, theta])
      color("Red") cylinder(d=0.5, h=dist);
}}
color([1.0, 1.0, 0.0, 0.2]) {modulename}();

"""


def point_cmp(p1, p2):
    for i in range(len(p1)-1, -1, -1):
        val = cmp(p1[i], p2[i])
        if val != 0:
            return val
    return 0


def facet_cmp(f1, f2):
    f1 = sorted(list(f1), cmp=point_cmp)
    f2 = sorted(list(f2), cmp=point_cmp)
    val = point_cmp(f1[0], f2[0])
    if val != 0:
        return val
    val = point_cmp(f1[1], f2[1])
    if val != 0:
        return val
    val = point_cmp(f1[2], f2[2])
    return val


def float_fmt(val):
    s = "%.3f" % val
    while len(s) > 1 and s[-1:] in '0.':
        if s[-1:] == '.':
            s = s[:-1]
            break
        s = s[:-1]
    if (s == '-0'):
        s = '0'
    return s


def vertex_fmt(vals):
    return " ".join([float_fmt(v) for v in vals])


def vertex_fmt2(vals):
    return "[" + (", ".join([float_fmt(v) for v in vals])) + "]"


class PointCloud(object):
    points = []
    pointhash = {}

    def __init__(self):
        self.points = []
        self.pointhash = {}

    def add_or_get_point(self, x, y, z):
        pt = (x, y, z)
        key = "%f %f %f" % pt
        if key in self.pointhash:
            return self.pointhash[key]
        idx = len(self.points)
        self.pointhash[key] = idx
        self.points.append(pt)
        return idx

    def point_coords(self, idx):
        return self.points[idx]

    def facet_coords(self, facet):
        return (
            self.point_coords(facet[0]),
            self.point_coords(facet[1]),
            self.point_coords(facet[2]),
        )


class StlData(object):
    def __init__(self):
        self.points = PointCloud()
        self.facets = []
        self.edgehash = {}
        self.filename = ""

    def add_edge(self, vertex1, vertex2):
        edge = [vertex1, vertex2]
        edge.sort()
        edge = tuple(edge)
        if edge not in self.edgehash:
            self.edgehash[edge] = 0
        self.edgehash[edge] += 1
        return self.edgehash[edge]

    def read_ascii_vertex(self, f):
        line = f.readline(1024)
        if line == "":
            return None
        words = line.strip(' \t\n\r').lower().split()
        if words[0] != 'vertex':
            return None
        point = (
            float(words[1]),
            float(words[2]),
            float(words[3]),
        )
        return self.points.add_or_get_point(*point)

    def read_ascii_facet(self, f):
        while True:
            line = f.readline(1024)
            if line == "":
                return None  # End of file.

            words = line.strip(' \t\n\r').lower().split()
            if words[0] == 'endsolid':
                return None  # No more facets to read
            if words[0] != 'facet' or words[1] != 'normal':
                continue  # Haven't found start of facet yet

            normal = (
                float(words[2]),
                float(words[3]),
                float(words[4]),
            )

            line = f.readline(1024)
            if line == "":
                return None  # End of file.
            if line.strip(' \t\n\r').lower() != "outer loop":
                continue  # File is corrupt.  Skip to next facet.

            vertex1 = self.read_ascii_vertex(f)
            if vertex1 is None:
                continue  # File is corrupt.  Skip to next facet.

            vertex2 = self.read_ascii_vertex(f)
            if vertex2 is None:
                continue  # File is corrupt.  Skip to next facet.

            vertex3 = self.read_ascii_vertex(f)
            if vertex3 is None:
                continue  # File is corrupt.  Skip to next facet.

            if vertex1 == vertex2 or vertex2 == vertex3 or vertex3 == vertex1:
                continue  # zero area facet.

            line = f.readline(1024)
            if line == "":
                return None  # End of file.
            if line.strip(' \t\n\r').lower() != "endloop":
                continue  # File is corrupt.  Skip to next facet.

            line = f.readline(1024)
            if line == "":
                return None  # End of file.
            if line.strip(' \t\n\r').lower() != "endfacet":
                continue  # File is corrupt.  Skip to next facet.

            return (vertex1, vertex2, vertex3, normal)

    def read_binary_facet(self, f):
        data = struct.unpack('<3f 3f 3f 3f H', f.read(4*4*3))
        normal = data[0:3]
        vertex1 = data[3:6]
        vertex2 = data[6:9]
        vertex3 = data[9:12]
        return (vertex1, vertex2, vertex3, normal)

    def read_file(self, filename):
        self.filename = filename
        with open(filename, 'rb') as f:
            line = f.readline(80)
            if line == "":
                return  # End of file.
            if line[0:6].lower() == "solid ":
                while True:
                    facet = self.read_ascii_facet(f)
                    if facet is None:
                        break
                    vertex1, vertex2, vertex3, normal = facet
                    self.facets.append(facet)
                    self.add_edge(vertex1, vertex2)
                    self.add_edge(vertex2, vertex3)
                    self.add_edge(vertex3, vertex1)
            else:
                chunk = f.read(4)
                facets = struct.unpack('<I', chunk)[0]
                while facets > 0:
                    facets -= 1
                    facet = self.read_binary_facet(f)
                    if facet is None:
                        break
                    vertex1, vertex2, vertex3, normal = facet
                    self.facets.append(facet)
                    self.add_edge(vertex1, vertex2)
                    self.add_edge(vertex2, vertex3)
                    self.add_edge(vertex3, vertex1)

    def write_ascii_file(self, filename):
        with open(filename, 'wb') as f:
            f.write("solid Model\n")
            for facet in self.facets:
                v1, v2, v3, norm = facet
                v1 = self.points.point_coords(v1)
                v2 = self.points.point_coords(v2)
                v3 = self.points.point_coords(v3)
                f.write("  facet normal %s\n" % vertex_fmt(norm))
                f.write("    outer loop\n")
                f.write("      vertex %s\n" % vertex_fmt(v1))
                f.write("      vertex %s\n" % vertex_fmt(v2))
                f.write("      vertex %s\n" % vertex_fmt(v3))
                f.write("    endloop\n")
                f.write("  endfacet\n")
            f.write("endsolid Model\n")

    def check_manifold(self, verbose=False, gui=False):
        is_manifold = True
        linedata = ""
        for edge, count in self.edgehash.iteritems():
            if count != 2:
                is_manifold = False
                v1 = self.points.point_coords(edge[0])
                v2 = self.points.point_coords(edge[1])
                v1 = vertex_fmt2(v1)
                v2 = vertex_fmt2(v2)
                print("NON-MANIFOLD EDGE! [{0}] {3}: {1} - {2}".format(
                      count, v1, v2, self.filename))
                if gui:
                    if linedata:
                        linedata += ",\n"
                    linedata += "  [{0}, {1}]".format(v1, v2)
        if is_manifold:
            if gui or verbose:
                print("%s is manifold." % self.filename)
        else:
            if gui:
                global guiscad_template
                modulename = os.path.basename(self.filename)
                if modulename.endswith('.stl'):
                    modulename = modulename[:-4]
                tmpfile = "mani-%s.scad" % (modulename)
                with open(tmpfile, 'w') as f:
                    f.write(guiscad_template.format(
                        linedata=linedata,
                        modulename=modulename,
                    ))
                subprocess.call(['open', tmpfile])
                time.sleep(5)
                os.remove(tmpfile)
        return is_manifold

    def sort_facets(self):
        self.facets = sorted(
            self.facets,
            cmp=lambda x, y: facet_cmp(
                self.points.facet_coords(x),
                self.points.facet_coords(y)
            )
        )


def main():
    parser = argparse.ArgumentParser(prog='myprogram')
    parser.add_argument('-v', '--verbose',
                        help='Show verbose output.',
                        action="store_true")
    parser.add_argument('-c', '--check-manifold',
                        help='Perform manifold validation of model.',
                        action="store_true")
    parser.add_argument('-g', '--gui-display',
                        help='Show non-manifold edges in GUI.',
                        action="store_true")
    parser.add_argument('-o', '--out-file',
                        help='Write normalized STL to file.')
    parser.add_argument('infile', help='Input STL filename.')
    args = parser.parse_args()

    stl = StlData()
    stl.read_file(args.infile)
    if args.verbose:
        print("Read {0} (faces:{1}  edges:{2})"
              .format(args.infile, len(stl.facets), len(stl.edgehash)))

    stl.sort_facets()
    if args.check_manifold or args.gui_display:
        if not stl.check_manifold(verbose=args.verbose, gui=args.gui_display):
            sys.exit(-1)

    if args.out_file:
        stl.write_ascii_file(args.out_file)
        if args.verbose:
            print("Wrote {0}".format(args.outfile))

    sys.exit(0)


if __name__ == "__main__":
    main()


# vim: expandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
