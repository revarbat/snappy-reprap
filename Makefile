OPENSCAD=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
CONVERT=convert

PARTFILES=$(sort $(wildcard *_parts.scad))
TARGETS=$(patsubst %.scad,STLs/%.stl,${PARTFILES})
ROTFILES=$(shell seq -f 'wiki/snappy_rot%03g.png' 0 10 359.99)
ASM_MODULES=$(shell grep 'module [a-z0-9_]*_assembly' full_assembly.scad | sed 's/^module //' | sed 's/[^a-z0-9_].*$$//' | sed '1!G;h;$$!d')
ASM_BEFORE_TARGETS=$(patsubst %,docs/assembly/%_before.png,${ASM_MODULES})
ASM_AFTER_TARGETS=$(patsubst %,docs/assembly/%_after.png,${ASM_MODULES})

all: ${TARGETS}

STLs/%.stl: %.scad config.scad GDMUtils.scad
	@if grep -q '^\s*!' $< ; then echo "Found uncommented exclamation mark(s) in source." ; grep -Hn '^\s*!' $< ; false ; fi
	${OPENSCAD} -m make -o $@ $<
	./stl_normalize.py -c $@ -o $@

pull:
	git pull --recurse-submodules

clean:
	rm -f tmp_*.png tmp_*.scad wiki/snappy_rot*.png

cleaner: clean
	rm -f ${TARGETS}

cleanwiki:
	rm -f wiki/snappy_*.gif wiki/snappy_*.png wiki/*_parts.png

instructions: docs/assembly/index.html

docs/assembly/index.html: ${ASM_BEFORE_TARGETS} ${ASM_AFTER_TARGETS}
	./gen_assembly_index.py

${ASM_BEFORE_TARGETS}: full_assembly.scad
	echo "use <full_assembly.scad>" > $(patsubst docs/assembly/%.png,tmp_%.scad,$@)
	echo "$(patsubst docs/assembly/%_before.png,%,$@)(explode=100, arrows=true);" >> $(patsubst docs/assembly/%.png,tmp_%.scad,$@)
	${OPENSCAD} -o $(subst docs/assembly/,tmp_asm_,$@) \
	    --csglimit=2000000 --imgsize=3200,3200 --projection=p \
	    $(shell grep -A2 'module $(patsubst docs/assembly/%_before.png,%,$@)' full_assembly.scad | head -5 | grep '// *view:' | sed 's/[^]0-9.,]//g' | sed 's/[]]/,/g' | sed 's/^/--camera=/') \
	    --autocenter --viewall \
	    $(patsubst docs/assembly/%.png,tmp_%.scad,$@) 2<&1
	${CONVERT} -trim -resize 400x400 -border 10x10 -bordercolor '#ffffe5' $(subst docs/assembly/,tmp_asm_,$@) $@
	rm -f $(subst docs/assembly/,tmp_asm_,$@) $(patsubst docs/assembly/%.png,tmp_%.scad,$@)

${ASM_AFTER_TARGETS}: full_assembly.scad
	echo "use <full_assembly.scad>" > $(patsubst docs/assembly/%.png,tmp_%.scad,$@)
	echo "$(patsubst docs/assembly/%_after.png,%,$@)(explode=0, arrows=false);" >> $(patsubst docs/assembly/%.png,tmp_%.scad,$@)
	${OPENSCAD} -o $(subst docs/assembly/,tmp_asm2_,$@) \
	    --csglimit=2000000 --imgsize=3200,3200 --projection=p \
	    $(shell grep -A2 'module $(patsubst docs/assembly/%_after.png,%,$@)' full_assembly.scad | head -5 | grep '// *view:' | sed 's/[^]0-9.,]//g' | sed 's/[]]/,/g' | sed 's/^/--camera=/') \
	    --autocenter --viewall \
	    $(patsubst docs/assembly/%.png,tmp_%.scad,$@) 2<&1
	${CONVERT} -trim -resize 400x400 -border 10x10 -bordercolor '#ffffe5' $(subst docs/assembly/,tmp_asm2_,$@) $@
	rm -f $(subst docs/assembly/,tmp_asm2_,$@) $(patsubst docs/assembly/%.png,tmp_%.scad,$@)

${ROTFILES}: full_assembly.scad $(wildcard *.scad)
	${OPENSCAD} -o $(subst wiki/,tmp_,$@) --imgsize=1024,1024 \
	    --projection=p --csglimit=2000000 \
	    -D '$$t=$(shell echo $(patsubst wiki/snappy_rot%.png,%/360.0,$@) | bc -l)' \
	    -D '$$do_prerender=false' --camera=0,0,255,65,0,30,2200 $<
	${CONVERT} -strip -resize 512x512 $(subst wiki/,tmp_,$@) $@
	rm -f  $(subst wiki/,tmp_,$@)

wiki/%.png: %.scad config.scad GDMUtils.scad
	${OPENSCAD} -o $(subst wiki/,tmp_,$@) --render --imgsize=3200,3200 \
	    --projection=p --csglimit=2000000 --camera=0,0,50,65,0,30,2000 $<
	${CONVERT} -trim -resize 200x200 -border 10x10 -bordercolor '#ffffe5' $(subst wiki/,tmp_,$@) $@
	rm -f $(subst wiki/,tmp_,$@)

wiki/snappy_full.png: full_assembly.scad $(wildcard *.scad)
	${OPENSCAD} -o $(subst wiki/,tmp_,$@) --imgsize=3200,3200 --projection=p \
	    --csglimit=2000000 --camera=0,0,245,65,0,30,3000 -D '$$t=0.5' $<
	${CONVERT} -trim -resize 800x800 -border 10x10 -bordercolor '#ffffe5' $(subst wiki/,tmp_,$@) $@
	rm -f $(subst wiki/,tmp_,$@)

wiki/snappy_small.png: wiki/snappy_full.png
	${CONVERT} -trim -resize 200x200 -border 10x10 -bordercolor '#ffffe5' $< $@

wiki/snappy_animated.gif: ${ROTFILES}
	${CONVERT} -delay 10 -loop 0 ${ROTFILES} $@
	rm -f ${ROTFILES}

wiki/snappy_anim_small.gif: wiki/snappy_animated.gif
	${CONVERT} -resize 200x200 $< $@

renderparts: $(patsubst %.scad,wiki/%.png,${PARTFILES})
rendering: wiki/snappy_full.png wiki/snappy_small.png
animation: wiki/snappy_animated.gif wiki/snappy_anim_small.gif
wiki: rendering renderparts animation



# Dependencies follow.
STLs/cable_chain_link_parts.stl: joiners.scad
STLs/cable_chain_mount_parts.stl: joiners.scad
STLs/cooling_fan_shroud_parts.stl: joiners.scad
STLs/drive_gear_parts.stl: publicDomainGearV1.1.scad
STLs/extruder_fan_clip_parts.stl: joiners.scad
STLs/extruder_fan_shroud_parts.stl: joiners.scad
STLs/extruder_idler_parts.stl: joiners.scad
STLs/extruder_motor_clip_parts.stl: joiners.scad
STLs/jhead_platform_parts.stl: joiners.scad
STLs/lifter_lock_nut_parts.stl: joiners.scad
STLs/lifter_rod_coupler_parts.stl: joiners.scad
STLs/motor_mount_plate_parts.stl: joiners.scad NEMA.scad
STLs/platform_support_parts.stl: joiners.scad
STLs/rail_endcap_parts.stl: joiners.scad
STLs/rail_segment_parts.stl: joiners.scad sliders.scad
STLs/rail_xy_motor_segment_parts.stl: joiners.scad sliders.scad
STLs/rail_z_motor_segment_parts.stl: joiners.scad
STLs/rambo_mount_parts.stl: joiners.scad
STLs/ramps_mount_parts.stl: joiners.scad
STLs/sled_endcap_parts.stl: joiners.scad
STLs/slop_calibrator_parts.stl: joiners.scad
STLs/spool_holder_parts.stl: joiners.scad
STLs/support_leg_parts.stl: joiners.scad
STLs/xy_joiner_parts.stl: joiners.scad
STLs/xy_sled_parts.stl: joiners.scad publicDomainGearV1.1.scad sliders.scad
STLs/yz_joiner_parts.stl: joiners.scad
STLs/z_sled_parts.stl: joiners.scad publicDomainGearV1.1.scad acme_screw.scad sliders.scad

