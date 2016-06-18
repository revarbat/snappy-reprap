#!/usr/bin/env python

import os
import os.path
import sys
import math
import time
import struct
import argparse
import platform
import itertools
import subprocess


guiscad_template = """\
module showlines(clr, lines) {{
    for (line = lines) {{
        delta = line[1]-line[0];
        dist = norm(delta);
        theta = atan2(delta[1],delta[0]);
        phi = atan2(delta[2],norm([delta[0],delta[1]]));
        translate(line[0]) {{
            rotate([0, 90-phi, theta]) {{
                color(clr) cylinder(d=0.5, h=dist);
            }}
        }}
    }}
}}
module showfaces(clr, faces) {{
    color(clr) {{
        for (face = faces) {{
            polyhedron(points=face, faces=[[0, 1, 2], [0, 2, 1]], convexity=2);
        }}
    }}
}}
showlines([1.0, 0.0, 1.0], [
{dupe_edges}
]);
showlines([1.0, 0.0, 0.0], [
{hole_edges}
]);
showfaces([1.0, 0.0, 1.0], [
{dupe_faces}
]);
color([0.0, 1.0, 0.0, 0.2]) import("{filename}", convexity=100);

"""


def dot(a, b):
    return sum(p*q for p, q in zip(a, b))


def cross(a, b):
    return [
        a[1]*b[2] - a[2]*b[1],
        a[2]*b[0] - a[0]*b[2],
        a[0]*b[1] - a[1]*b[0]
    ]


def vsub(a, b):
    return [i - j for i, j in zip(a, b)]


def vsdiv(v, s):
    return [x / s for x in v]


def dist(v):
    return math.sqrt(sum([x*x for x in v]))


def normalize(v):
    return vsdiv(v, dist(v))


def is_clockwise(a, b, c, n):
    return dot(n, cross(vsub(b, a), vsub(c, a))) < 0


def point_cmp(p1, p2):
    for i in [2, 1, 0]:
        val = cmp(p1[i], p2[i])
        if val != 0:
            return val
    return 0


def facet_cmp(f1, f2):
    cl1 = [sorted([p[i] for p in f1]) for i in range(3)]
    cl2 = [sorted([p[i] for p in f2]) for i in range(3)]
    for i in [2, 1, 0]:
        for c1, c2 in itertools.izip_longest(cl1[i], cl2[i]):
            if c1 is None:
                return -1
            val = cmp(c1, c2)
            if val != 0:
                return val
    return 0


def float_fmt(val):
    s = "%.4f" % val
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
        self.minx = 9e9
        self.miny = 9e9
        self.minz = 9e9
        self.maxx = -9e9
        self.maxy = -9e9
        self.maxz = -9e9

    def update_volume(self, x, y, z):
        if x < self.minx:
            self.minx = x
        if x > self.maxx:
            self.maxx = x
        if y < self.miny:
            self.miny = y
        if y > self.maxy:
            self.maxy = y
        if z < self.minz:
            self.minz = z
        if z > self.maxz:
            self.maxz = z

    def add_or_get_point(self, x, y, z):
        pt = (
            round(x, 4),
            round(y, 4),
            round(z, 4),
        )
        key = "%.4f %.4f %.4f" % pt
        if key in self.pointhash:
            return self.pointhash[key]
        idx = len(self.points)
        self.pointhash[key] = idx
        self.points.append(pt)
        self.update_volume(x, y, z)
        return idx

    def point_coords(self, idx):
        return self.points[idx]

    def facet_coords(self, facet):
        return (
            self.point_coords(facet[0]),
            self.point_coords(facet[1]),
            self.point_coords(facet[2]),
        )


class StlEndOfFileException(Exception):
    pass


class StlMalformedLineException(Exception):
    pass


class StlData(object):
    def __init__(self):
        self.points = PointCloud()
        self.facets = []
        self.edgehash = {}
        self.facehash = {}
        self.filename = ""

    def _mark_edge(self, vertex1, vertex2):
        edge = [vertex1, vertex2]
        edge.sort()
        edge = tuple(edge)
        if edge not in self.edgehash:
            self.edgehash[edge] = 0
        self.edgehash[edge] += 1
        return self.edgehash[edge]

    def _mark_face(self, vertex1, vertex2, vertex3):
        self._mark_edge(vertex1, vertex2)
        self._mark_edge(vertex2, vertex3)
        self._mark_edge(vertex3, vertex1)
        face = [vertex1, vertex2, vertex3]
        face.sort()
        face = tuple(face)
        if face not in self.facehash:
            self.facehash[face] = 0
        self.facehash[face] += 1
        return self.facehash[face]

    def _read_ascii_line(self, f, watchwords=None):
        line = f.readline(1024)
        if line == "":
            raise StlEndOfFileException()
        words = line.strip(' \t\n\r').lower().split()
        if words[0] == 'endsolid':
            raise StlEndOfFileException()
        argstart = 0
        if watchwords:
            watchwords = watchwords.lower().split()
            argstart = len(watchwords)
            for i in xrange(argstart):
                if words[i] != watchwords[i]:
                    raise StlMalformedLineException()
        return [float(val) for val in words[argstart:]]

    def _read_ascii_vertex(self, f):
        point = self._read_ascii_line(f, watchwords='vertex')
        return self.points.add_or_get_point(*point)

    def _read_ascii_facet(self, f):
        while True:
            try:
                normal = self._read_ascii_line(f, watchwords='facet normal')
                self._read_ascii_line(f, watchwords='outer loop')
                vertex1 = self._read_ascii_vertex(f)
                vertex2 = self._read_ascii_vertex(f)
                vertex3 = self._read_ascii_vertex(f)
                self._read_ascii_line(f, watchwords='endloop')
                self._read_ascii_line(f, watchwords='endfacet')
                if vertex1 == vertex2:
                    continue  # zero area facet.  Skip to next facet.
                if vertex2 == vertex3:
                    continue  # zero area facet.  Skip to next facet.
                if vertex3 == vertex1:
                    continue  # zero area facet.  Skip to next facet.

            except StlEndOfFileException:
                return None

            except StlMalformedLineException:
                continue  # Skip to next facet.

            return (vertex1, vertex2, vertex3, normal)

    def _read_binary_facet(self, f):
        data = struct.unpack('<3f 3f 3f 3f H', f.read(4*4*3+2))
        normal = data[0:3]
        vertex1 = data[3:6]
        vertex2 = data[6:9]
        vertex3 = data[9:12]
        v1 = self.points.add_or_get_point(*vertex1)
        v2 = self.points.add_or_get_point(*vertex2)
        v3 = self.points.add_or_get_point(*vertex3)
        return (v1, v2, v3, normal)

    def sort_facet(self, facet):
        v1, v2, v3, norm = facet
        p1 = self.points.point_coords(v1)
        p2 = self.points.point_coords(v2)
        p3 = self.points.point_coords(v3)
        if dist(norm) > 0:
            # Make sure vertex ordering is counter-clockwise,
            # relative to the outward facing normal.
            if is_clockwise(p1, p2, p3, norm):
                v1, v3, v2 = (v1, v2, v3)
                p1, p3, p2 = (p1, p2, p3)
        else:
            # If no normal was specified, we should calculate it, relative
            # to the counter-clockwise vertices (as seen from outside).
            norm = cross(vsub(p3, p1), vsub(p2, p1))
            if dist(norm) > 1e-6:
                norm = normalize(norm)
        cmp23 = point_cmp(p2, p3)
        if point_cmp(p1, p2) > 0 and cmp23 < 0:
            return (v2, v3, v1, norm)
        if point_cmp(p1, p3) > 0 and cmp23 > 0:
            return (v3, v1, v2, norm)
        return (v1, v2, v3, norm)

    def read_file(self, filename):
        self.filename = filename
        with open(filename, 'rb') as f:
            line = f.readline(80)
            if line == "":
                return  # End of file.
            if line[0:6].lower() == "solid ":
                while True:
                    facet = self._read_ascii_facet(f)
                    if facet is None:
                        break
                    facet = self.sort_facet(facet)
                    vertex1, vertex2, vertex3, normal = facet
                    self.facets.append(facet)
                    self._mark_face(vertex1, vertex2, vertex3)
            else:
                chunk = f.read(4)
                facets = struct.unpack('<I', chunk)[0]
                while facets > 0:
                    facets -= 1
                    facet = self._read_binary_facet(f)
                    if facet is None:
                        break
                    facet = self.sort_facet(facet)
                    vertex1, vertex2, vertex3, normal = facet
                    self.facets.append(facet)
                    self._mark_face(vertex1, vertex2, vertex3)

    def write_file(self, filename, binary=False):
        if binary:
            self._write_binary_file(filename)
        else:
            self._write_ascii_file(filename)

    def _write_ascii_file(self, filename):
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

    def _write_binary_file(self, filename):
        with open(filename, 'wb') as f:
            f.write('%-80s' % 'Binary STL Model')
            f.write(struct.pack('<I', len(self.facets)))
            for facet in self.facets:
                v1, v2, v3, norm = facet
                v1 = self.points.point_coords(v1)
                v2 = self.points.point_coords(v2)
                v3 = self.points.point_coords(v3)
                f.write(struct.pack('<3f', *norm))
                f.write(struct.pack('<3f', *v1))
                f.write(struct.pack('<3f', *v2))
                f.write(struct.pack('<3f', *v3))
                f.write(struct.pack('<H', 0))

    def _gui_display_manifold(self, hole_edges, dupe_edges, dupe_faces):
        global guiscad_template
        modulename = os.path.basename(self.filename)
        if modulename.endswith('.stl'):
            modulename = modulename[:-4]
        tmpfile = "mani-{0}.scad".format(modulename)
        with open(tmpfile, 'w') as f:
            f.write(guiscad_template.format(
                hole_edges=hole_edges,
                dupe_edges=dupe_edges,
                dupe_faces=dupe_faces,
                modulename=modulename,
                filename=self.filename,
            ))
        if platform.system() == 'Darwin':
            subprocess.call(['open', tmpfile])
            time.sleep(5)
        else:
            subprocess.call(['openscad', tmpfile])
            time.sleep(5)
        os.remove(tmpfile)

    def _check_manifold_duplicate_faces(self):
        found = []
        for face, count in self.facehash.iteritems():
            if count != 1:
                v1 = vertex_fmt2(self.points.point_coords(face[0]))
                v2 = vertex_fmt2(self.points.point_coords(face[1]))
                v3 = vertex_fmt2(self.points.point_coords(face[2]))
                found.append((v1, v2, v3))
        return found

    def _check_manifold_hole_edges(self):
        found = []
        for edge, count in self.edgehash.iteritems():
            if count == 1:
                v1 = vertex_fmt2(self.points.point_coords(edge[0]))
                v2 = vertex_fmt2(self.points.point_coords(edge[1]))
                found.append((v1, v2))
        return found

    def _check_manifold_excess_edges(self):
        found = []
        for edge, count in self.edgehash.iteritems():
            if count > 2:
                v1 = vertex_fmt2(self.points.point_coords(edge[0]))
                v2 = vertex_fmt2(self.points.point_coords(edge[1]))
                found.append((v1, v2))
        return found

    def check_manifold(self, verbose=False, gui=False):
        is_manifold = True

        faces = self._check_manifold_duplicate_faces()
        for v1, v2, v3 in faces:
            is_manifold = False
            print("NON-MANIFOLD DUPLICATE FACE! {3}: {0} - {1} - {2}"
                  .format(v1, v2, v3, self.filename))
        if gui:
            dupe_faces = ",\n".join(
                ["  [{0}, {1}, {2}]".format(*coords) for coords in faces]
            )

        edges = self._check_manifold_hole_edges()
        for v1, v2 in edges:
            is_manifold = False
            print("NON-MANIFOLD HOLE EDGE! {2}: {0} - {1}"
                  .format(v1, v2, self.filename))
        if gui:
            hole_edges = ",\n".join(
                ["  [{0}, {1}]".format(*coords) for coords in edges]
            )

        edges = self._check_manifold_excess_edges()
        for v1, v2 in edges:
            is_manifold = False
            print("NON-MANIFOLD DUPLICATE EDGE! {2}: {0} - {1}"
                  .format(v1, v2, self.filename))
        if gui:
            dupe_edges = ",\n".join(
                ["  [{0}, {1}]".format(*coords) for coords in edges]
            )

        if is_manifold:
            if gui or verbose:
                print("%s is manifold." % self.filename)
        elif gui:
                self._gui_display_manifold(hole_edges, dupe_edges, dupe_faces)
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
    parser = argparse.ArgumentParser(prog='stl_normalize')
    parser.add_argument('-v', '--verbose',
                        help='Show verbose output.',
                        action="store_true")
    parser.add_argument('-c', '--check-manifold',
                        help='Perform manifold validation of model.',
                        action="store_true")
    parser.add_argument('-g', '--gui-display',
                        help='Show non-manifold edges in GUI.',
                        action="store_true")
    parser.add_argument('-b', '--write-binary',
                        help='Use binary STL format for output.',
                        action="store_true")
    parser.add_argument('-o', '--outfile',
                        help='Write normalized STL to file.')
    parser.add_argument('infile', help='Input STL filename.')
    args = parser.parse_args()

    stl = StlData()
    stl.read_file(args.infile)
    if args.verbose:
        print("Read {0} ({1:.1f} x {2:.1f} x {3:.1f})".format(
            args.infile,
            (stl.points.maxx-stl.points.minx),
            (stl.points.maxy-stl.points.miny),
            (stl.points.maxz-stl.points.minz),
        ))

    if args.check_manifold or args.gui_display:
        if not stl.check_manifold(verbose=args.verbose, gui=args.gui_display):
            sys.exit(-1)

    if args.outfile:
        stl.sort_facets()
        stl.write_file(args.outfile, binary=args.write_binary)
        if args.verbose:
            print("Wrote {0} ({1})".format(
                args.outfile,
                ("binary" if args.write_binary else "ASCII"),
            ))

    sys.exit(0)


if __name__ == "__main__":
    main()


# vim: expandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
