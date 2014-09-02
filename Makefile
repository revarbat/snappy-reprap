OPENSCAD=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD

# match files containing "// make me"
TARGETS=$(subst .scad,.stl,$(shell grep -l '// make me' *.scad | sort))

all: ${TARGETS}

# auto-generated .scad files with .deps make make re-build always. keeping the
# scad files solves this problem. (explanations are welcome.)
.SECONDARY: $(shell echo "${TARGETS}" | sed 's/\.stl/.scad/g')

# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)


%.stl: %.scad config.scad GDMUtils.scad joiners.scad publicDomainGearV1.1.scad
	${OPENSCAD} -m make -o $@ -d $@.deps $<


clean:
	rm -f ${TARGETS} *.deps

rendering:
	${OPENSCAD} -o wiki/snappy_full.png --imgsize=3200,3200 --projection=p --csglimit=100000 --camera=45,-225,165,65,0,300,3500 full_assembly.scad
	cp wiki/snappy_full.png wiki/snappy_small.png
	sips -Z 800 wiki/snappy_full.png
	sips -Z 200 wiki/snappy_small.png

