#!/usr/bin/env python

import re
import sys

html_header_string = """\
<html>
<head>
<title>Snappy Assembly</title>
<style>
BODY {
  margin-bottom: 200px;
}
TABLE TD {
  vertical-align: middle;
}
H2 {
  margin-bottom: 5px;
  margin-top: 24px;
  font-size: 20pt;
}
LI.section {
  font-size: 20pt;
  font-weight: bold;
}
H3 {
  margin-left: -15px;
  margin-bottom: 5px;
  margin-top: 18px;
  font-size: 16pt;
}
LI.step {
  padding-left: 15px;
  margin-left: 0;
  font-size: 16pt;
  font-weight: bold;
  list-style-type: none;
}
DIV.desc {
  margin-bottom: 15px;
  font-size: 12pt;
  font-weight: normal;
}
OL {
  margin-left: 30px;
}
UL {
  padding-left: 5px;
}
</style>
</head>
<body>
<h1>Snappy RepRap Assembly Instructions</h1>
<ol>
"""


class GenAssemblyIndex(object):
    indexfile = "docs/assembly/index.html"
    markdownfile = "wiki/Assembly.md"
    sourcefile = "full_assembly.scad"
    modules = []
    modinfo = {}

    def write_index(self):
        with open(self.indexfile, "w") as f:
            f.write(html_header_string)

            for mod_eng in self.modules:
                f.write('<li class="section">')
                f.write('<h2>%s</h2>\n' % mod_eng)

                stepcnt = len(self.modinfo[mod_eng])
                if stepcnt > 1:
                    f.write('<ul>\n')

                for stepinfo in self.modinfo[mod_eng]:
                    if stepcnt > 1:
                        f.write('<li class="step">')
                        f.write('<h3>Step {step}</h3>\n'.format(**stepinfo))

                    f.write(
                        '<div class="desc">{desc}</div>\n'
                        '<table>'
                        '<tr>'
                        '<td class="befor">'
                        '<img src="{module}_before.png">'
                        '</td>'
                        '<td class="arrow"><img src="arrow.png"></td>'
                        '<td class="after"><img src="{module}_after.png"></td>'
                        '</tr>'
                        '</table>\n'
                        .format(**stepinfo)
                    )

                    if stepcnt > 1:
                        f.write('</li>\n')

                if stepcnt > 1:
                    f.write('</ul>\n')

                f.write('</li>\n')

            f.write('</ol>\n')
            f.write('</body>\n')
            f.write('</html>\n')

    def write_markdown(self):
        with open(self.markdownfile, "w") as f:
            f.write("# Snappy RepRap Assembly Instructions\n\n")

            for mod_eng in self.modules:
                f.write('##%s\n\n' % mod_eng)

                stepcnt = len(self.modinfo[mod_eng])
                for stepinfo in self.modinfo[mod_eng]:
                    stepinfo['base'] = \
                        'https://raw.githubusercontent.com/' \
                        'revarbat/snappy-reprap/master/docs/assembly/'

                    if stepcnt > 1:
                        f.write('### Step {step}\n\n'.format(**stepinfo))

                    f.write(
                        '{desc}\n\n'
                        'Before | After\n'
                        '------ | -----\n'
                        '![{module} Step {step} Before]'
                        '({base}{module}_before.png) | '
                        '![{module} Step {step} After]'
                        '({base}{module}_after.png)\n\n'
                        .format(**stepinfo)
                    )

    def process_module(self, module, desc):
        print("module: %s" % module)
        step = 1
        mod_eng = module.replace('_', ' ') \
            .title() \
            .replace('Xy', 'XY') \
            .replace('Yz', 'YZ')
        mod_split = mod_eng.split(" ")
        if mod_split[-1].isdigit():
            step = int(mod_split[-1])
            mod_eng = " ".join(mod_split[:-1])
        if mod_eng not in self.modules:
            self.modules.append(mod_eng)
            self.modinfo[mod_eng] = [
                {
                    'module': module,
                    'step': step,
                    'desc': desc
                },
            ]
        else:
            self.modinfo[mod_eng].append(
                {
                    'module': module,
                    'step': step,
                    'desc': desc
                },
            )

    def generate_index(self):
        mod_re = re.compile(
            r'module  *([a-z_][a-z0-9_]*_assembly(_[0-9]+)?) *\('
        )
        desc_re = re.compile(r'// *desc: *(.*)$')

        module = ""
        desc = ""
        with open(self.sourcefile, "r") as f:
            for line in f.readlines():
                mod_res = mod_re.search(line)
                if mod_res:
                    if module:
                        self.process_module(module, desc)
                    module = mod_res.group(1)
                    desc = ""
                desc_res = desc_re.search(line)
                if desc_res:
                    desc += desc_res.group(1)
            if module:
                self.process_module(module, desc)
        self.write_index()
        self.write_markdown()


def main():
    genidx = GenAssemblyIndex()
    genidx.generate_index()
    sys.exit(0)


if __name__ == "__main__":
    main()


# vim: expandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
