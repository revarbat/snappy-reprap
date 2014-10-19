OPENSCAD=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
CONVERT=convert

PARTFILES=$(sort $(wildcard *_parts.scad))
TARGETS=$(patsubst %.scad,STLs/%.stl,${PARTFILES})
ROTFILES=$(shell seq -f 'wiki/snappy_rot%03g.png' 0 15 359.99)

all: ${TARGETS}

STLs/%.stl: %.scad config.scad GDMUtils.scad
	${OPENSCAD} -m make -o $@ $<

clean:
	rm -f tmp_*.png snappy_rot*.png render_*_parts.scad

cleaner: clean
	rm -f ${TARGETS}

cleanwiki:
	rm -f wiki/snappy_*.gif wiki/snappy_*.png wiki/*_parts.png

${ROTFILES}: full_assembly.scad
	${OPENSCAD} -o $(subst wiki/,tmp_,$@) --imgsize=800,800 --projection=p --csglimit=100000 \
	    --camera=0,0,160,65,0,$(patsubst wiki/snappy_rot%.png,%,$@),3500 $<
	${CONVERT} -strip -resize 400x400 $(subst wiki/,tmp_,$@) $@
	rm -f  $(subst wiki/,tmp_,$@)

wiki/%.png: %.scad config.scad GDMUtils.scad
	${OPENSCAD} -o $(subst wiki/,tmp_,$@) --imgsize=1600,1600 --projection=p --csglimit=100000 --camera=0,0,50,65,0,120,1500 $<
	${CONVERT} -trim -resize 200x200 -border 10x10 -bordercolor '#ffffe5' $(subst wiki/,tmp_,$@) $@
	rm -f $(subst wiki/,tmp_,$@)

wiki/snappy_full.png: full_assembly.scad
	${OPENSCAD} -o $(subst wiki/,tmp_,$@) --imgsize=3200,3200 --projection=p --csglimit=100000 --camera=0,0,160,65,0,120,3500 $<
	${CONVERT} -trim -resize 800x800 -border 10x10 -bordercolor '#ffffe5' $(subst wiki/,tmp_,$@) $@
	rm -f $(subst wiki/,tmp_,$@)

wiki/snappy_small.png: wiki/snappy_full.png
	${CONVERT} -trim -resize 200x200 -border 10x10 -bordercolor '#ffffe5' $< $@

wiki/snappy_animated.gif: ${ROTFILES}
	${CONVERT} -delay 33 -loop 0 ${ROTFILES} $@

wiki/snappy_anim_small.gif: wiki/snappy_animated.gif
	${CONVERT} -resize 200x200 $< $@

renderparts: $(patsubst %.scad,wiki/%.png,${PARTFILES})
rendering: wiki/snappy_full.png wiki/snappy_small.png
animation: wiki/snappy_animated.gif wiki/snappy_anim_small.gif
wiki: renderparts rendering animation



# Dependencies follow.
STLs/cantilever_joint_parts.stl: joiners.scad
STLs/drive_gear_parts.stl: publicDomainGearV1.1.scad
STLs/extruder_platform_parts.stl: joiners.scad
STLs/lifter_nut_cap_parts.stl: nut_capture.scad
STLs/lifter_nut_parts.stl: acme_screw.scad
STLs/lifter_rod_coupler_parts.stl: joiners.scad
STLs/motor_mount_plate_parts.stl: joiners.scad NEMA.scad
STLs/rail_endcap_parts.stl: joiners.scad
STLs/rail_motor_segment_parts.stl: joiners.scad
STLs/rail_segment_parts.stl: joiners.scad
STLs/sled_endcap_parts.stl: joiners.scad
STLs/support_leg_parts.stl: joiners.scad
STLs/xy_joiner_parts.stl: joiners.scad
STLs/xy_sled_parts.stl: slider_sled.scad joiners.scad publicDomainGearV1.1.scad
STLs/yz_joiner_parts.stl: joiners.scad
STLs/z_sled_parts.stl: joiners.scad acme_screw.scad lifter_nut_parts.scad nut_capture.scad slider_sled.scad

