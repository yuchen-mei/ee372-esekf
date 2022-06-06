#=========================================================================
# Makefile
#=========================================================================
# Generator : /home/users/jeffreyy/ee372/mflowgen/mflowgen/backends/make_backend.py

SHELL=/usr/bin/env bash -euo pipefail

# $1 -- $dst
# $2 -- $src
# $3 -- $stamp

define cpdir
	rm -rf ./$1
	cp -aL $2 $1 || true
	chmod -R +w $1
	touch $3
endef

# $1 -- $dst
# $2 -- $src
# $3 -- $stamp

define cpdir-and-parameterize
	rm -rf ./$1
	cp -aL $2 $1 || true
	chmod -R +w $1
	cp .mflowgen/$1/configure.yml $1
	touch $3
endef

# $1 -- $dst
# $2 -- $src
# $3 -- $stamp

define mkdir-and-symlink
	rm -rf ./$1
	mkdir -p $1
	cd $1 && ln -sf ../$2/* . && cd ..
	rm $1/configure.yml && cp .mflowgen/$1/configure.yml $1
	touch $3
endef

# $1 -- $dst_dir
# $2 -- $dst
# $3 -- $src
# $4 -- $stamp

define symlink
	mkdir -p $1
	cd $1 && ln -sf $3 $2 && touch $4
endef

# $1 -- $stamp

define stamp
	touch $1
endef

# Default

default: constraints custom-flowstep floorplan gen-saif-gl info pin-placement rtl skywater-130nm sram synopsys-dc-compile testbench rtl-sim gen-saif-rtl synopsys-dc-synthesis cadence-innovus-flowsetup cadence-innovus-init cadence-innovus-power cadence-innovus-place cadence-innovus-cts cadence-innovus-postcts_hold cadence-innovus-route cadence-innovus-postroute cadence-innovus-signoff mentor-calibre-gdsmerge open-magic-def2spice ptpx-gl ptpx-rtl synopsys-pt-timing-signoff gl-sim netgen-lvs-def open-magic-antenna open-magic-drc open-magic-gds2spice open-magic-gds2spice-nobbox mentor-calibre-comparison mentor-calibre-comparison-nobbox netgen-lvs-gds

# ------------------------------------------------------------------------
# constraints
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 0-constraints/.prebuilt)","")
0-constraints/.stamp:
	$(call cpdir-and-parameterize,0-constraints,../design/constraints,0-constraints/.stamp)
endif

# collect inputs

# execute

ifeq ("$(wildcard 0-constraints/.prebuilt)","")

define 0_constraints_commands_rule
	mkdir -p 0-constraints/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t constraints && chmod +x .mflowgen/0-constraints/mflowgen-run && cp -f .mflowgen/0-constraints/mflowgen-run 0-constraints && if [[ -e .mflowgen/0-constraints/mflowgen-debug ]]; then chmod +x .mflowgen/0-constraints/mflowgen-debug && cp -f .mflowgen/0-constraints/mflowgen-debug 0-constraints; fi && if [[ -e .mflowgen/0-constraints/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/0-constraints/mflowgen-check-preconditions.py && cp -f .mflowgen/0-constraints/mflowgen-check-preconditions.py 0-constraints; fi && if [[ -e .mflowgen/0-constraints/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/0-constraints/mflowgen-check-postconditions.py && cp -f .mflowgen/0-constraints/mflowgen-check-postconditions.py 0-constraints; fi && cd 0-constraints && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 0-constraints/outputs/*
endef

0-constraints/.execstamp: 0-constraints/.stamp
	$(call 0_constraints_commands_rule)
	touch $@

0-constraints/outputs/.execstamp.constraints.tcl: 0-constraints/.execstamp
	touch $@

endif

# collect outputs

0-constraints/outputs/.stamp.constraints.tcl: 0-constraints/.execstamp 0-constraints/outputs/.execstamp.constraints.tcl
	$(call stamp,0-constraints/outputs/.stamp.constraints.tcl)

# post-conditions

define 0_constraints_post_conditions_commands_rule
	cd 0-constraints && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

0-constraints/.postconditions.stamp: 0-constraints/.execstamp 0-constraints/outputs/.execstamp.constraints.tcl 0-constraints/outputs/.stamp.constraints.tcl
	$(call 0_constraints_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: constraints

constraints: 0-constraints/.execstamp 0-constraints/.postconditions.stamp 0-constraints/outputs/.execstamp.constraints.tcl 0-constraints/outputs/.stamp.constraints.tcl

.PHONY: 0

0: 0-constraints/.execstamp 0-constraints/.postconditions.stamp 0-constraints/outputs/.execstamp.constraints.tcl 0-constraints/outputs/.stamp.constraints.tcl

# debug

# ------------------------------------------------------------------------
# custom-flowstep
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 1-custom-flowstep/.prebuilt)","")
1-custom-flowstep/.stamp:
	$(call cpdir-and-parameterize,1-custom-flowstep,../design/custom-flowstep,1-custom-flowstep/.stamp)
endif

# collect inputs

# execute

ifeq ("$(wildcard 1-custom-flowstep/.prebuilt)","")

define 1_custom_flowstep_commands_rule
	mkdir -p 1-custom-flowstep/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t custom-flowstep && chmod +x .mflowgen/1-custom-flowstep/mflowgen-run && cp -f .mflowgen/1-custom-flowstep/mflowgen-run 1-custom-flowstep && if [[ -e .mflowgen/1-custom-flowstep/mflowgen-debug ]]; then chmod +x .mflowgen/1-custom-flowstep/mflowgen-debug && cp -f .mflowgen/1-custom-flowstep/mflowgen-debug 1-custom-flowstep; fi && if [[ -e .mflowgen/1-custom-flowstep/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/1-custom-flowstep/mflowgen-check-preconditions.py && cp -f .mflowgen/1-custom-flowstep/mflowgen-check-preconditions.py 1-custom-flowstep; fi && if [[ -e .mflowgen/1-custom-flowstep/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/1-custom-flowstep/mflowgen-check-postconditions.py && cp -f .mflowgen/1-custom-flowstep/mflowgen-check-postconditions.py 1-custom-flowstep; fi && cd 1-custom-flowstep && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 1-custom-flowstep/outputs/*
endef

1-custom-flowstep/.execstamp: 1-custom-flowstep/.stamp
	$(call 1_custom_flowstep_commands_rule)
	touch $@

1-custom-flowstep/outputs/.execstamp.setup.tcl: 1-custom-flowstep/.execstamp
	touch $@

endif

# collect outputs

1-custom-flowstep/outputs/.stamp.setup.tcl: 1-custom-flowstep/.execstamp 1-custom-flowstep/outputs/.execstamp.setup.tcl
	$(call stamp,1-custom-flowstep/outputs/.stamp.setup.tcl)

# post-conditions

define 1_custom_flowstep_post_conditions_commands_rule
	cd 1-custom-flowstep && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

1-custom-flowstep/.postconditions.stamp: 1-custom-flowstep/.execstamp 1-custom-flowstep/outputs/.execstamp.setup.tcl 1-custom-flowstep/outputs/.stamp.setup.tcl
	$(call 1_custom_flowstep_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: custom-flowstep

custom-flowstep: 1-custom-flowstep/.execstamp 1-custom-flowstep/.postconditions.stamp 1-custom-flowstep/outputs/.execstamp.setup.tcl 1-custom-flowstep/outputs/.stamp.setup.tcl

.PHONY: 1

1: 1-custom-flowstep/.execstamp 1-custom-flowstep/.postconditions.stamp 1-custom-flowstep/outputs/.execstamp.setup.tcl 1-custom-flowstep/outputs/.stamp.setup.tcl

# debug

# ------------------------------------------------------------------------
# floorplan
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 2-floorplan/.prebuilt)","")
2-floorplan/.stamp:
	$(call cpdir-and-parameterize,2-floorplan,../design/floorplan,2-floorplan/.stamp)
endif

# collect inputs

# execute

ifeq ("$(wildcard 2-floorplan/.prebuilt)","")

define 2_floorplan_commands_rule
	mkdir -p 2-floorplan/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t floorplan && chmod +x .mflowgen/2-floorplan/mflowgen-run && cp -f .mflowgen/2-floorplan/mflowgen-run 2-floorplan && if [[ -e .mflowgen/2-floorplan/mflowgen-debug ]]; then chmod +x .mflowgen/2-floorplan/mflowgen-debug && cp -f .mflowgen/2-floorplan/mflowgen-debug 2-floorplan; fi && if [[ -e .mflowgen/2-floorplan/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/2-floorplan/mflowgen-check-preconditions.py && cp -f .mflowgen/2-floorplan/mflowgen-check-preconditions.py 2-floorplan; fi && if [[ -e .mflowgen/2-floorplan/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/2-floorplan/mflowgen-check-postconditions.py && cp -f .mflowgen/2-floorplan/mflowgen-check-postconditions.py 2-floorplan; fi && cd 2-floorplan && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 2-floorplan/outputs/*
endef

2-floorplan/.execstamp: 2-floorplan/.stamp
	$(call 2_floorplan_commands_rule)
	touch $@

2-floorplan/outputs/.execstamp.floorplan.tcl: 2-floorplan/.execstamp
	touch $@

endif

# collect outputs

2-floorplan/outputs/.stamp.floorplan.tcl: 2-floorplan/.execstamp 2-floorplan/outputs/.execstamp.floorplan.tcl
	$(call stamp,2-floorplan/outputs/.stamp.floorplan.tcl)

# post-conditions

define 2_floorplan_post_conditions_commands_rule
	cd 2-floorplan && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

2-floorplan/.postconditions.stamp: 2-floorplan/.execstamp 2-floorplan/outputs/.execstamp.floorplan.tcl 2-floorplan/outputs/.stamp.floorplan.tcl
	$(call 2_floorplan_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: floorplan

floorplan: 2-floorplan/.execstamp 2-floorplan/.postconditions.stamp 2-floorplan/outputs/.execstamp.floorplan.tcl 2-floorplan/outputs/.stamp.floorplan.tcl

.PHONY: 2

2: 2-floorplan/.execstamp 2-floorplan/.postconditions.stamp 2-floorplan/outputs/.execstamp.floorplan.tcl 2-floorplan/outputs/.stamp.floorplan.tcl

# debug

# ------------------------------------------------------------------------
# gen-saif-gl
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 3-gen-saif-gl/.prebuilt)","")
3-gen-saif-gl/.stamp:
	$(call cpdir-and-parameterize,3-gen-saif-gl,../../../mflowgen/steps/synopsys-vcd2saif-convert,3-gen-saif-gl/.stamp)
endif

# collect inputs

# execute

ifeq ("$(wildcard 3-gen-saif-gl/.prebuilt)","")

define 3_gen_saif_gl_commands_rule
	mkdir -p 3-gen-saif-gl/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t gen-saif-gl && chmod +x .mflowgen/3-gen-saif-gl/mflowgen-run && cp -f .mflowgen/3-gen-saif-gl/mflowgen-run 3-gen-saif-gl && if [[ -e .mflowgen/3-gen-saif-gl/mflowgen-debug ]]; then chmod +x .mflowgen/3-gen-saif-gl/mflowgen-debug && cp -f .mflowgen/3-gen-saif-gl/mflowgen-debug 3-gen-saif-gl; fi && if [[ -e .mflowgen/3-gen-saif-gl/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/3-gen-saif-gl/mflowgen-check-preconditions.py && cp -f .mflowgen/3-gen-saif-gl/mflowgen-check-preconditions.py 3-gen-saif-gl; fi && if [[ -e .mflowgen/3-gen-saif-gl/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/3-gen-saif-gl/mflowgen-check-postconditions.py && cp -f .mflowgen/3-gen-saif-gl/mflowgen-check-postconditions.py 3-gen-saif-gl; fi && cd 3-gen-saif-gl && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 3-gen-saif-gl/outputs/*
endef

3-gen-saif-gl/.execstamp: 3-gen-saif-gl/.stamp
	$(call 3_gen_saif_gl_commands_rule)
	touch $@

3-gen-saif-gl/outputs/.execstamp.run.saif: 3-gen-saif-gl/.execstamp
	touch $@

endif

# collect outputs

3-gen-saif-gl/outputs/.stamp.run.saif: 3-gen-saif-gl/.execstamp 3-gen-saif-gl/outputs/.execstamp.run.saif
	$(call stamp,3-gen-saif-gl/outputs/.stamp.run.saif)

# post-conditions

define 3_gen_saif_gl_post_conditions_commands_rule
	cd 3-gen-saif-gl && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

3-gen-saif-gl/.postconditions.stamp: 3-gen-saif-gl/.execstamp 3-gen-saif-gl/outputs/.execstamp.run.saif 3-gen-saif-gl/outputs/.stamp.run.saif
	$(call 3_gen_saif_gl_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: gen-saif-gl

gen-saif-gl: 3-gen-saif-gl/.execstamp 3-gen-saif-gl/.postconditions.stamp 3-gen-saif-gl/outputs/.execstamp.run.saif 3-gen-saif-gl/outputs/.stamp.run.saif

.PHONY: 3

3: 3-gen-saif-gl/.execstamp 3-gen-saif-gl/.postconditions.stamp 3-gen-saif-gl/outputs/.execstamp.run.saif 3-gen-saif-gl/outputs/.stamp.run.saif

# debug

# ------------------------------------------------------------------------
# info
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 4-info/.prebuilt)","")
4-info/.stamp:
	$(call cpdir-and-parameterize,4-info,../../../mflowgen/steps/info,4-info/.stamp)
endif

# collect inputs

# execute

ifeq ("$(wildcard 4-info/.prebuilt)","")

define 4_info_commands_rule
	mkdir -p 4-info/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t info && chmod +x .mflowgen/4-info/mflowgen-run && cp -f .mflowgen/4-info/mflowgen-run 4-info && if [[ -e .mflowgen/4-info/mflowgen-debug ]]; then chmod +x .mflowgen/4-info/mflowgen-debug && cp -f .mflowgen/4-info/mflowgen-debug 4-info; fi && if [[ -e .mflowgen/4-info/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/4-info/mflowgen-check-preconditions.py && cp -f .mflowgen/4-info/mflowgen-check-preconditions.py 4-info; fi && if [[ -e .mflowgen/4-info/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/4-info/mflowgen-check-postconditions.py && cp -f .mflowgen/4-info/mflowgen-check-postconditions.py 4-info; fi && cd 4-info && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 4-info/outputs/*
endef

4-info/.execstamp: 4-info/.stamp
	$(call 4_info_commands_rule)

4-info/.execstamp.execute-phony: 4-info/.execstamp
	touch $@

endif

# collect outputs

# post-conditions

define 4_info_post_conditions_commands_rule
	cd 4-info && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

4-info/.postconditions.stamp: 4-info/.execstamp 4-info/.execstamp.execute-phony
	$(call 4_info_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: info

info: 4-info/.execstamp 4-info/.execstamp.execute-phony 4-info/.postconditions.stamp

.PHONY: 4

4: 4-info/.execstamp 4-info/.execstamp.execute-phony 4-info/.postconditions.stamp

# debug

# ------------------------------------------------------------------------
# pin-placement
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 5-pin-placement/.prebuilt)","")
5-pin-placement/.stamp:
	$(call cpdir-and-parameterize,5-pin-placement,../design/pin-placement,5-pin-placement/.stamp)
endif

# collect inputs

# execute

ifeq ("$(wildcard 5-pin-placement/.prebuilt)","")

define 5_pin_placement_commands_rule
	mkdir -p 5-pin-placement/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t pin-placement && chmod +x .mflowgen/5-pin-placement/mflowgen-run && cp -f .mflowgen/5-pin-placement/mflowgen-run 5-pin-placement && if [[ -e .mflowgen/5-pin-placement/mflowgen-debug ]]; then chmod +x .mflowgen/5-pin-placement/mflowgen-debug && cp -f .mflowgen/5-pin-placement/mflowgen-debug 5-pin-placement; fi && if [[ -e .mflowgen/5-pin-placement/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/5-pin-placement/mflowgen-check-preconditions.py && cp -f .mflowgen/5-pin-placement/mflowgen-check-preconditions.py 5-pin-placement; fi && if [[ -e .mflowgen/5-pin-placement/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/5-pin-placement/mflowgen-check-postconditions.py && cp -f .mflowgen/5-pin-placement/mflowgen-check-postconditions.py 5-pin-placement; fi && cd 5-pin-placement && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 5-pin-placement/outputs/*
endef

5-pin-placement/.execstamp: 5-pin-placement/.stamp
	$(call 5_pin_placement_commands_rule)
	touch $@

5-pin-placement/outputs/.execstamp.pin-assignments.tcl: 5-pin-placement/.execstamp
	touch $@

endif

# collect outputs

5-pin-placement/outputs/.stamp.pin-assignments.tcl: 5-pin-placement/.execstamp 5-pin-placement/outputs/.execstamp.pin-assignments.tcl
	$(call stamp,5-pin-placement/outputs/.stamp.pin-assignments.tcl)

# post-conditions

define 5_pin_placement_post_conditions_commands_rule
	cd 5-pin-placement && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

5-pin-placement/.postconditions.stamp: 5-pin-placement/.execstamp 5-pin-placement/outputs/.execstamp.pin-assignments.tcl 5-pin-placement/outputs/.stamp.pin-assignments.tcl
	$(call 5_pin_placement_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: pin-placement

pin-placement: 5-pin-placement/.execstamp 5-pin-placement/.postconditions.stamp 5-pin-placement/outputs/.execstamp.pin-assignments.tcl 5-pin-placement/outputs/.stamp.pin-assignments.tcl

.PHONY: 5

5: 5-pin-placement/.execstamp 5-pin-placement/.postconditions.stamp 5-pin-placement/outputs/.execstamp.pin-assignments.tcl 5-pin-placement/outputs/.stamp.pin-assignments.tcl

# debug

# ------------------------------------------------------------------------
# rtl
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 6-rtl/.prebuilt)","")
6-rtl/.stamp:
	$(call cpdir-and-parameterize,6-rtl,../design/rtl,6-rtl/.stamp)
endif

# collect inputs

# execute

ifeq ("$(wildcard 6-rtl/.prebuilt)","")

define 6_rtl_commands_rule
	mkdir -p 6-rtl/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t rtl && chmod +x .mflowgen/6-rtl/mflowgen-run && cp -f .mflowgen/6-rtl/mflowgen-run 6-rtl && if [[ -e .mflowgen/6-rtl/mflowgen-debug ]]; then chmod +x .mflowgen/6-rtl/mflowgen-debug && cp -f .mflowgen/6-rtl/mflowgen-debug 6-rtl; fi && if [[ -e .mflowgen/6-rtl/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/6-rtl/mflowgen-check-preconditions.py && cp -f .mflowgen/6-rtl/mflowgen-check-preconditions.py 6-rtl; fi && if [[ -e .mflowgen/6-rtl/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/6-rtl/mflowgen-check-postconditions.py && cp -f .mflowgen/6-rtl/mflowgen-check-postconditions.py 6-rtl; fi && cd 6-rtl && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 6-rtl/outputs/*
endef

6-rtl/.execstamp: 6-rtl/.stamp
	$(call 6_rtl_commands_rule)
	touch $@

6-rtl/outputs/.execstamp.design.v: 6-rtl/.execstamp
	touch $@
6-rtl/outputs/.execstamp.design.vcs.v: 6-rtl/.execstamp
	touch $@

endif

# collect outputs

6-rtl/outputs/.stamp.design.v: 6-rtl/.execstamp 6-rtl/outputs/.execstamp.design.v 6-rtl/outputs/.execstamp.design.vcs.v
	$(call stamp,6-rtl/outputs/.stamp.design.v)

6-rtl/outputs/.stamp.design.vcs.v: 6-rtl/.execstamp 6-rtl/outputs/.execstamp.design.v 6-rtl/outputs/.execstamp.design.vcs.v
	$(call stamp,6-rtl/outputs/.stamp.design.vcs.v)

# post-conditions

define 6_rtl_post_conditions_commands_rule
	cd 6-rtl && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

6-rtl/.postconditions.stamp: 6-rtl/.execstamp 6-rtl/outputs/.execstamp.design.v 6-rtl/outputs/.execstamp.design.vcs.v 6-rtl/outputs/.stamp.design.v 6-rtl/outputs/.stamp.design.vcs.v
	$(call 6_rtl_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: rtl

rtl: 6-rtl/.execstamp 6-rtl/.postconditions.stamp 6-rtl/outputs/.execstamp.design.v 6-rtl/outputs/.execstamp.design.vcs.v 6-rtl/outputs/.stamp.design.v 6-rtl/outputs/.stamp.design.vcs.v

.PHONY: 6

6: 6-rtl/.execstamp 6-rtl/.postconditions.stamp 6-rtl/outputs/.execstamp.design.v 6-rtl/outputs/.execstamp.design.vcs.v 6-rtl/outputs/.stamp.design.v 6-rtl/outputs/.stamp.design.vcs.v

# debug

# ------------------------------------------------------------------------
# skywater-130nm
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 7-skywater-130nm/.prebuilt)","")
7-skywater-130nm/.stamp:
	$(call cpdir-and-parameterize,7-skywater-130nm,../../../../../../../farmshare/home/classes/ee/372/PDKs/skywater-130nm-adk,7-skywater-130nm/.stamp)
endif

# collect inputs

# execute

ifeq ("$(wildcard 7-skywater-130nm/.prebuilt)","")

define 7_skywater_130nm_commands_rule
	mkdir -p 7-skywater-130nm/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t skywater-130nm && chmod +x .mflowgen/7-skywater-130nm/mflowgen-run && cp -f .mflowgen/7-skywater-130nm/mflowgen-run 7-skywater-130nm && if [[ -e .mflowgen/7-skywater-130nm/mflowgen-debug ]]; then chmod +x .mflowgen/7-skywater-130nm/mflowgen-debug && cp -f .mflowgen/7-skywater-130nm/mflowgen-debug 7-skywater-130nm; fi && if [[ -e .mflowgen/7-skywater-130nm/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/7-skywater-130nm/mflowgen-check-preconditions.py && cp -f .mflowgen/7-skywater-130nm/mflowgen-check-preconditions.py 7-skywater-130nm; fi && if [[ -e .mflowgen/7-skywater-130nm/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/7-skywater-130nm/mflowgen-check-postconditions.py && cp -f .mflowgen/7-skywater-130nm/mflowgen-check-postconditions.py 7-skywater-130nm; fi && cd 7-skywater-130nm && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 7-skywater-130nm/outputs/*
endef

7-skywater-130nm/.execstamp: 7-skywater-130nm/.stamp
	$(call 7_skywater_130nm_commands_rule)
	touch $@

7-skywater-130nm/outputs/.execstamp.adk: 7-skywater-130nm/.execstamp
	touch $@

endif

# collect outputs

7-skywater-130nm/outputs/.stamp.adk: 7-skywater-130nm/.execstamp 7-skywater-130nm/outputs/.execstamp.adk
	$(call stamp,7-skywater-130nm/outputs/.stamp.adk)

# post-conditions

define 7_skywater_130nm_post_conditions_commands_rule
	cd 7-skywater-130nm && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

7-skywater-130nm/.postconditions.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
	$(call 7_skywater_130nm_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: skywater-130nm

skywater-130nm: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk

.PHONY: 7

7: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk

# debug

# ------------------------------------------------------------------------
# sram
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 8-sram/.prebuilt)","")
8-sram/.stamp:
	$(call cpdir-and-parameterize,8-sram,../design/sram,8-sram/.stamp)
endif

# collect inputs

# execute

ifeq ("$(wildcard 8-sram/.prebuilt)","")

define 8_sram_commands_rule
	mkdir -p 8-sram/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t sram && chmod +x .mflowgen/8-sram/mflowgen-run && cp -f .mflowgen/8-sram/mflowgen-run 8-sram && if [[ -e .mflowgen/8-sram/mflowgen-debug ]]; then chmod +x .mflowgen/8-sram/mflowgen-debug && cp -f .mflowgen/8-sram/mflowgen-debug 8-sram; fi && if [[ -e .mflowgen/8-sram/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/8-sram/mflowgen-check-preconditions.py && cp -f .mflowgen/8-sram/mflowgen-check-preconditions.py 8-sram; fi && if [[ -e .mflowgen/8-sram/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/8-sram/mflowgen-check-postconditions.py && cp -f .mflowgen/8-sram/mflowgen-check-postconditions.py 8-sram; fi && cd 8-sram && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 8-sram/outputs/*
endef

8-sram/.execstamp: 8-sram/.stamp
	$(call 8_sram_commands_rule)
	touch $@

8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp: 8-sram/.execstamp
	touch $@
8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp: 8-sram/.execstamp
	touch $@
8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v: 8-sram/.execstamp
	touch $@
8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 8-sram/.execstamp
	touch $@
8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib: 8-sram/.execstamp
	touch $@
8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db: 8-sram/.execstamp
	touch $@
8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds: 8-sram/.execstamp
	touch $@

endif

# collect outputs

8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp: 8-sram/.execstamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call stamp,8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp)

8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp: 8-sram/.execstamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call stamp,8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp)

8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v: 8-sram/.execstamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call stamp,8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v)

8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 8-sram/.execstamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call stamp,8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)

8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib: 8-sram/.execstamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call stamp,8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib)

8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db: 8-sram/.execstamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call stamp,8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db)

8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds: 8-sram/.execstamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call stamp,8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds)

# post-conditions

define 8_sram_post_conditions_commands_rule
	cd 8-sram && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

8-sram/.postconditions.stamp: 8-sram/.execstamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call 8_sram_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: sram

sram: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib

.PHONY: 8

8: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib

# debug

# ------------------------------------------------------------------------
# synopsys-dc-compile
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 9-synopsys-dc-compile/.prebuilt)","")
9-synopsys-dc-compile/.stamp:
	$(call cpdir-and-parameterize,9-synopsys-dc-compile,../design/synopsys-dc-compile,9-synopsys-dc-compile/.stamp)
endif

# collect inputs

# execute

ifeq ("$(wildcard 9-synopsys-dc-compile/.prebuilt)","")

define 9_synopsys_dc_compile_commands_rule
	mkdir -p 9-synopsys-dc-compile/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t synopsys-dc-compile && chmod +x .mflowgen/9-synopsys-dc-compile/mflowgen-run && cp -f .mflowgen/9-synopsys-dc-compile/mflowgen-run 9-synopsys-dc-compile && if [[ -e .mflowgen/9-synopsys-dc-compile/mflowgen-debug ]]; then chmod +x .mflowgen/9-synopsys-dc-compile/mflowgen-debug && cp -f .mflowgen/9-synopsys-dc-compile/mflowgen-debug 9-synopsys-dc-compile; fi && if [[ -e .mflowgen/9-synopsys-dc-compile/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/9-synopsys-dc-compile/mflowgen-check-preconditions.py && cp -f .mflowgen/9-synopsys-dc-compile/mflowgen-check-preconditions.py 9-synopsys-dc-compile; fi && if [[ -e .mflowgen/9-synopsys-dc-compile/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/9-synopsys-dc-compile/mflowgen-check-postconditions.py && cp -f .mflowgen/9-synopsys-dc-compile/mflowgen-check-postconditions.py 9-synopsys-dc-compile; fi && cd 9-synopsys-dc-compile && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 9-synopsys-dc-compile/outputs/*
endef

9-synopsys-dc-compile/.execstamp: 9-synopsys-dc-compile/.stamp
	$(call 9_synopsys_dc_compile_commands_rule)
	touch $@

9-synopsys-dc-compile/outputs/.execstamp.compile.tcl: 9-synopsys-dc-compile/.execstamp
	touch $@

endif

# collect outputs

9-synopsys-dc-compile/outputs/.stamp.compile.tcl: 9-synopsys-dc-compile/.execstamp 9-synopsys-dc-compile/outputs/.execstamp.compile.tcl
	$(call stamp,9-synopsys-dc-compile/outputs/.stamp.compile.tcl)

# post-conditions

define 9_synopsys_dc_compile_post_conditions_commands_rule
	cd 9-synopsys-dc-compile && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

9-synopsys-dc-compile/.postconditions.stamp: 9-synopsys-dc-compile/.execstamp 9-synopsys-dc-compile/outputs/.execstamp.compile.tcl 9-synopsys-dc-compile/outputs/.stamp.compile.tcl
	$(call 9_synopsys_dc_compile_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: synopsys-dc-compile

synopsys-dc-compile: 9-synopsys-dc-compile/.execstamp 9-synopsys-dc-compile/.postconditions.stamp 9-synopsys-dc-compile/outputs/.execstamp.compile.tcl 9-synopsys-dc-compile/outputs/.stamp.compile.tcl

.PHONY: 9

9: 9-synopsys-dc-compile/.execstamp 9-synopsys-dc-compile/.postconditions.stamp 9-synopsys-dc-compile/outputs/.execstamp.compile.tcl 9-synopsys-dc-compile/outputs/.stamp.compile.tcl

# debug

# ------------------------------------------------------------------------
# testbench
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 10-testbench/.prebuilt)","")
10-testbench/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
10-testbench/.stamp:
	$(call cpdir-and-parameterize,10-testbench,../design/testbench,10-testbench/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 10-testbench/.prebuilt)","")
10-testbench/inputs/.stamp.adk: 10-testbench/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,10-testbench/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

# execute

ifeq ("$(wildcard 10-testbench/.prebuilt)","")

define 10_testbench_commands_rule
	mkdir -p 10-testbench/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t testbench && chmod +x .mflowgen/10-testbench/mflowgen-run && cp -f .mflowgen/10-testbench/mflowgen-run 10-testbench && if [[ -e .mflowgen/10-testbench/mflowgen-debug ]]; then chmod +x .mflowgen/10-testbench/mflowgen-debug && cp -f .mflowgen/10-testbench/mflowgen-debug 10-testbench; fi && if [[ -e .mflowgen/10-testbench/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/10-testbench/mflowgen-check-preconditions.py && cp -f .mflowgen/10-testbench/mflowgen-check-preconditions.py 10-testbench; fi && if [[ -e .mflowgen/10-testbench/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/10-testbench/mflowgen-check-postconditions.py && cp -f .mflowgen/10-testbench/mflowgen-check-postconditions.py 10-testbench; fi && cd 10-testbench && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 10-testbench/outputs/*
endef

10-testbench/.execstamp: 10-testbench/.stamp 10-testbench/inputs/.stamp.adk
	$(call 10_testbench_commands_rule)
	touch $@

10-testbench/outputs/.execstamp.testbench.sv: 10-testbench/.execstamp
	touch $@
10-testbench/outputs/.execstamp.instr_data.txt: 10-testbench/.execstamp
	touch $@
10-testbench/outputs/.execstamp.input_data.txt: 10-testbench/.execstamp
	touch $@
10-testbench/outputs/.execstamp.design.args: 10-testbench/.execstamp
	touch $@
10-testbench/outputs/.execstamp.design.args.gls: 10-testbench/.execstamp
	touch $@

endif

# collect outputs

10-testbench/outputs/.stamp.testbench.sv: 10-testbench/.execstamp 10-testbench/outputs/.execstamp.design.args 10-testbench/outputs/.execstamp.design.args.gls 10-testbench/outputs/.execstamp.input_data.txt 10-testbench/outputs/.execstamp.instr_data.txt 10-testbench/outputs/.execstamp.testbench.sv
	$(call stamp,10-testbench/outputs/.stamp.testbench.sv)

10-testbench/outputs/.stamp.instr_data.txt: 10-testbench/.execstamp 10-testbench/outputs/.execstamp.design.args 10-testbench/outputs/.execstamp.design.args.gls 10-testbench/outputs/.execstamp.input_data.txt 10-testbench/outputs/.execstamp.instr_data.txt 10-testbench/outputs/.execstamp.testbench.sv
	$(call stamp,10-testbench/outputs/.stamp.instr_data.txt)

10-testbench/outputs/.stamp.input_data.txt: 10-testbench/.execstamp 10-testbench/outputs/.execstamp.design.args 10-testbench/outputs/.execstamp.design.args.gls 10-testbench/outputs/.execstamp.input_data.txt 10-testbench/outputs/.execstamp.instr_data.txt 10-testbench/outputs/.execstamp.testbench.sv
	$(call stamp,10-testbench/outputs/.stamp.input_data.txt)

10-testbench/outputs/.stamp.design.args: 10-testbench/.execstamp 10-testbench/outputs/.execstamp.design.args 10-testbench/outputs/.execstamp.design.args.gls 10-testbench/outputs/.execstamp.input_data.txt 10-testbench/outputs/.execstamp.instr_data.txt 10-testbench/outputs/.execstamp.testbench.sv
	$(call stamp,10-testbench/outputs/.stamp.design.args)

10-testbench/outputs/.stamp.design.args.gls: 10-testbench/.execstamp 10-testbench/outputs/.execstamp.design.args 10-testbench/outputs/.execstamp.design.args.gls 10-testbench/outputs/.execstamp.input_data.txt 10-testbench/outputs/.execstamp.instr_data.txt 10-testbench/outputs/.execstamp.testbench.sv
	$(call stamp,10-testbench/outputs/.stamp.design.args.gls)

# post-conditions

define 10_testbench_post_conditions_commands_rule
	cd 10-testbench && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

10-testbench/.postconditions.stamp: 10-testbench/.execstamp 10-testbench/outputs/.execstamp.design.args 10-testbench/outputs/.execstamp.design.args.gls 10-testbench/outputs/.execstamp.input_data.txt 10-testbench/outputs/.execstamp.instr_data.txt 10-testbench/outputs/.execstamp.testbench.sv 10-testbench/outputs/.stamp.design.args 10-testbench/outputs/.stamp.design.args.gls 10-testbench/outputs/.stamp.input_data.txt 10-testbench/outputs/.stamp.instr_data.txt 10-testbench/outputs/.stamp.testbench.sv
	$(call 10_testbench_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: testbench

testbench: 10-testbench/.execstamp 10-testbench/.postconditions.stamp 10-testbench/outputs/.execstamp.design.args 10-testbench/outputs/.execstamp.design.args.gls 10-testbench/outputs/.execstamp.input_data.txt 10-testbench/outputs/.execstamp.instr_data.txt 10-testbench/outputs/.execstamp.testbench.sv 10-testbench/outputs/.stamp.design.args 10-testbench/outputs/.stamp.design.args.gls 10-testbench/outputs/.stamp.input_data.txt 10-testbench/outputs/.stamp.instr_data.txt 10-testbench/outputs/.stamp.testbench.sv

.PHONY: 10

10: 10-testbench/.execstamp 10-testbench/.postconditions.stamp 10-testbench/outputs/.execstamp.design.args 10-testbench/outputs/.execstamp.design.args.gls 10-testbench/outputs/.execstamp.input_data.txt 10-testbench/outputs/.execstamp.instr_data.txt 10-testbench/outputs/.execstamp.testbench.sv 10-testbench/outputs/.stamp.design.args 10-testbench/outputs/.stamp.design.args.gls 10-testbench/outputs/.stamp.input_data.txt 10-testbench/outputs/.stamp.instr_data.txt 10-testbench/outputs/.stamp.testbench.sv

# debug

# ------------------------------------------------------------------------
# rtl-sim
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 11-rtl-sim/.prebuilt)","")
11-rtl-sim/.stamp: 10-testbench/.execstamp 10-testbench/.postconditions.stamp 10-testbench/outputs/.execstamp.design.args 10-testbench/outputs/.execstamp.design.args.gls 10-testbench/outputs/.execstamp.input_data.txt 10-testbench/outputs/.execstamp.instr_data.txt 10-testbench/outputs/.execstamp.testbench.sv 10-testbench/outputs/.stamp.design.args 10-testbench/outputs/.stamp.design.args.gls 10-testbench/outputs/.stamp.input_data.txt 10-testbench/outputs/.stamp.instr_data.txt 10-testbench/outputs/.stamp.testbench.sv
11-rtl-sim/.stamp: 6-rtl/.execstamp 6-rtl/.postconditions.stamp 6-rtl/outputs/.execstamp.design.v 6-rtl/outputs/.execstamp.design.vcs.v 6-rtl/outputs/.stamp.design.v 6-rtl/outputs/.stamp.design.vcs.v
11-rtl-sim/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
11-rtl-sim/.stamp:
	$(call cpdir-and-parameterize,11-rtl-sim,../design/synopsys-vcs-sim,11-rtl-sim/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 11-rtl-sim/.prebuilt)","")
11-rtl-sim/inputs/.stamp.design.args: 11-rtl-sim/.stamp 10-testbench/outputs/.stamp.design.args
	$(call symlink,11-rtl-sim/inputs,design.args,../../10-testbench/outputs/design.args,.stamp.design.args)
endif

ifeq ("$(wildcard 11-rtl-sim/.prebuilt)","")
11-rtl-sim/inputs/.stamp.design.vcs.v: 11-rtl-sim/.stamp 6-rtl/outputs/.stamp.design.vcs.v
	$(call symlink,11-rtl-sim/inputs,design.vcs.v,../../6-rtl/outputs/design.vcs.v,.stamp.design.vcs.v)
endif

ifeq ("$(wildcard 11-rtl-sim/.prebuilt)","")
11-rtl-sim/inputs/.stamp.input_data.txt: 11-rtl-sim/.stamp 10-testbench/outputs/.stamp.input_data.txt
	$(call symlink,11-rtl-sim/inputs,input_data.txt,../../10-testbench/outputs/input_data.txt,.stamp.input_data.txt)
endif

ifeq ("$(wildcard 11-rtl-sim/.prebuilt)","")
11-rtl-sim/inputs/.stamp.instr_data.txt: 11-rtl-sim/.stamp 10-testbench/outputs/.stamp.instr_data.txt
	$(call symlink,11-rtl-sim/inputs,instr_data.txt,../../10-testbench/outputs/instr_data.txt,.stamp.instr_data.txt)
endif

ifeq ("$(wildcard 11-rtl-sim/.prebuilt)","")
11-rtl-sim/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v: 11-rtl-sim/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v
	$(call symlink,11-rtl-sim/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.v,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.v,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v)
endif

ifeq ("$(wildcard 11-rtl-sim/.prebuilt)","")
11-rtl-sim/inputs/.stamp.testbench.sv: 11-rtl-sim/.stamp 10-testbench/outputs/.stamp.testbench.sv
	$(call symlink,11-rtl-sim/inputs,testbench.sv,../../10-testbench/outputs/testbench.sv,.stamp.testbench.sv)
endif

# execute

ifeq ("$(wildcard 11-rtl-sim/.prebuilt)","")

define 11_rtl_sim_commands_rule
	mkdir -p 11-rtl-sim/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t rtl-sim && chmod +x .mflowgen/11-rtl-sim/mflowgen-run && cp -f .mflowgen/11-rtl-sim/mflowgen-run 11-rtl-sim && if [[ -e .mflowgen/11-rtl-sim/mflowgen-debug ]]; then chmod +x .mflowgen/11-rtl-sim/mflowgen-debug && cp -f .mflowgen/11-rtl-sim/mflowgen-debug 11-rtl-sim; fi && if [[ -e .mflowgen/11-rtl-sim/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/11-rtl-sim/mflowgen-check-preconditions.py && cp -f .mflowgen/11-rtl-sim/mflowgen-check-preconditions.py 11-rtl-sim; fi && if [[ -e .mflowgen/11-rtl-sim/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/11-rtl-sim/mflowgen-check-postconditions.py && cp -f .mflowgen/11-rtl-sim/mflowgen-check-postconditions.py 11-rtl-sim; fi && cd 11-rtl-sim && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 11-rtl-sim/outputs/*
endef

11-rtl-sim/.execstamp: 11-rtl-sim/.stamp 11-rtl-sim/inputs/.stamp.design.args 11-rtl-sim/inputs/.stamp.design.vcs.v 11-rtl-sim/inputs/.stamp.input_data.txt 11-rtl-sim/inputs/.stamp.instr_data.txt 11-rtl-sim/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 11-rtl-sim/inputs/.stamp.testbench.sv
	$(call 11_rtl_sim_commands_rule)
	touch $@

11-rtl-sim/outputs/.execstamp.run.vcd: 11-rtl-sim/.execstamp
	touch $@

endif

# collect outputs

11-rtl-sim/outputs/.stamp.run.vcd: 11-rtl-sim/.execstamp 11-rtl-sim/outputs/.execstamp.run.vcd
	$(call stamp,11-rtl-sim/outputs/.stamp.run.vcd)

# post-conditions

define 11_rtl_sim_post_conditions_commands_rule
	cd 11-rtl-sim && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

11-rtl-sim/.postconditions.stamp: 11-rtl-sim/.execstamp 11-rtl-sim/outputs/.execstamp.run.vcd 11-rtl-sim/outputs/.stamp.run.vcd
	$(call 11_rtl_sim_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: rtl-sim

rtl-sim: 11-rtl-sim/.execstamp 11-rtl-sim/.postconditions.stamp 11-rtl-sim/outputs/.execstamp.run.vcd 11-rtl-sim/outputs/.stamp.run.vcd

.PHONY: 11

11: 11-rtl-sim/.execstamp 11-rtl-sim/.postconditions.stamp 11-rtl-sim/outputs/.execstamp.run.vcd 11-rtl-sim/outputs/.stamp.run.vcd

# debug

# ------------------------------------------------------------------------
# gen-saif-rtl
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 12-gen-saif-rtl/.prebuilt)","")
12-gen-saif-rtl/.stamp: 11-rtl-sim/.execstamp 11-rtl-sim/.postconditions.stamp 11-rtl-sim/outputs/.execstamp.run.vcd 11-rtl-sim/outputs/.stamp.run.vcd
12-gen-saif-rtl/.stamp:
	$(call cpdir-and-parameterize,12-gen-saif-rtl,../../../mflowgen/steps/synopsys-vcd2saif-convert,12-gen-saif-rtl/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 12-gen-saif-rtl/.prebuilt)","")
12-gen-saif-rtl/inputs/.stamp.run.vcd: 12-gen-saif-rtl/.stamp 11-rtl-sim/outputs/.stamp.run.vcd
	$(call symlink,12-gen-saif-rtl/inputs,run.vcd,../../11-rtl-sim/outputs/run.vcd,.stamp.run.vcd)
endif

# execute

ifeq ("$(wildcard 12-gen-saif-rtl/.prebuilt)","")

define 12_gen_saif_rtl_commands_rule
	mkdir -p 12-gen-saif-rtl/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t gen-saif-rtl && chmod +x .mflowgen/12-gen-saif-rtl/mflowgen-run && cp -f .mflowgen/12-gen-saif-rtl/mflowgen-run 12-gen-saif-rtl && if [[ -e .mflowgen/12-gen-saif-rtl/mflowgen-debug ]]; then chmod +x .mflowgen/12-gen-saif-rtl/mflowgen-debug && cp -f .mflowgen/12-gen-saif-rtl/mflowgen-debug 12-gen-saif-rtl; fi && if [[ -e .mflowgen/12-gen-saif-rtl/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/12-gen-saif-rtl/mflowgen-check-preconditions.py && cp -f .mflowgen/12-gen-saif-rtl/mflowgen-check-preconditions.py 12-gen-saif-rtl; fi && if [[ -e .mflowgen/12-gen-saif-rtl/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/12-gen-saif-rtl/mflowgen-check-postconditions.py && cp -f .mflowgen/12-gen-saif-rtl/mflowgen-check-postconditions.py 12-gen-saif-rtl; fi && cd 12-gen-saif-rtl && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 12-gen-saif-rtl/outputs/*
endef

12-gen-saif-rtl/.execstamp: 12-gen-saif-rtl/.stamp 12-gen-saif-rtl/inputs/.stamp.run.vcd
	$(call 12_gen_saif_rtl_commands_rule)
	touch $@

12-gen-saif-rtl/outputs/.execstamp.run.saif: 12-gen-saif-rtl/.execstamp
	touch $@

endif

# collect outputs

12-gen-saif-rtl/outputs/.stamp.run.saif: 12-gen-saif-rtl/.execstamp 12-gen-saif-rtl/outputs/.execstamp.run.saif
	$(call stamp,12-gen-saif-rtl/outputs/.stamp.run.saif)

# post-conditions

define 12_gen_saif_rtl_post_conditions_commands_rule
	cd 12-gen-saif-rtl && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

12-gen-saif-rtl/.postconditions.stamp: 12-gen-saif-rtl/.execstamp 12-gen-saif-rtl/outputs/.execstamp.run.saif 12-gen-saif-rtl/outputs/.stamp.run.saif
	$(call 12_gen_saif_rtl_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: gen-saif-rtl

gen-saif-rtl: 12-gen-saif-rtl/.execstamp 12-gen-saif-rtl/.postconditions.stamp 12-gen-saif-rtl/outputs/.execstamp.run.saif 12-gen-saif-rtl/outputs/.stamp.run.saif

.PHONY: 12

12: 12-gen-saif-rtl/.execstamp 12-gen-saif-rtl/.postconditions.stamp 12-gen-saif-rtl/outputs/.execstamp.run.saif 12-gen-saif-rtl/outputs/.stamp.run.saif

# debug

# ------------------------------------------------------------------------
# synopsys-dc-synthesis
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 13-synopsys-dc-synthesis/.prebuilt)","")
13-synopsys-dc-synthesis/.stamp: 0-constraints/.execstamp 0-constraints/.postconditions.stamp 0-constraints/outputs/.execstamp.constraints.tcl 0-constraints/outputs/.stamp.constraints.tcl
13-synopsys-dc-synthesis/.stamp: 12-gen-saif-rtl/.execstamp 12-gen-saif-rtl/.postconditions.stamp 12-gen-saif-rtl/outputs/.execstamp.run.saif 12-gen-saif-rtl/outputs/.stamp.run.saif
13-synopsys-dc-synthesis/.stamp: 6-rtl/.execstamp 6-rtl/.postconditions.stamp 6-rtl/outputs/.execstamp.design.v 6-rtl/outputs/.execstamp.design.vcs.v 6-rtl/outputs/.stamp.design.v 6-rtl/outputs/.stamp.design.vcs.v
13-synopsys-dc-synthesis/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
13-synopsys-dc-synthesis/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
13-synopsys-dc-synthesis/.stamp: 9-synopsys-dc-compile/.execstamp 9-synopsys-dc-compile/.postconditions.stamp 9-synopsys-dc-compile/outputs/.execstamp.compile.tcl 9-synopsys-dc-compile/outputs/.stamp.compile.tcl
13-synopsys-dc-synthesis/.stamp:
	$(call cpdir-and-parameterize,13-synopsys-dc-synthesis,../../../mflowgen/steps/synopsys-dc-synthesis,13-synopsys-dc-synthesis/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 13-synopsys-dc-synthesis/.prebuilt)","")
13-synopsys-dc-synthesis/inputs/.stamp.adk: 13-synopsys-dc-synthesis/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,13-synopsys-dc-synthesis/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 13-synopsys-dc-synthesis/.prebuilt)","")
13-synopsys-dc-synthesis/inputs/.stamp.compile.tcl: 13-synopsys-dc-synthesis/.stamp 9-synopsys-dc-compile/outputs/.stamp.compile.tcl
	$(call symlink,13-synopsys-dc-synthesis/inputs,compile.tcl,../../9-synopsys-dc-compile/outputs/compile.tcl,.stamp.compile.tcl)
endif

ifeq ("$(wildcard 13-synopsys-dc-synthesis/.prebuilt)","")
13-synopsys-dc-synthesis/inputs/.stamp.constraints.tcl: 13-synopsys-dc-synthesis/.stamp 0-constraints/outputs/.stamp.constraints.tcl
	$(call symlink,13-synopsys-dc-synthesis/inputs,constraints.tcl,../../0-constraints/outputs/constraints.tcl,.stamp.constraints.tcl)
endif

ifeq ("$(wildcard 13-synopsys-dc-synthesis/.prebuilt)","")
13-synopsys-dc-synthesis/inputs/.stamp.design.v: 13-synopsys-dc-synthesis/.stamp 6-rtl/outputs/.stamp.design.v
	$(call symlink,13-synopsys-dc-synthesis/inputs,design.v,../../6-rtl/outputs/design.v,.stamp.design.v)
endif

ifeq ("$(wildcard 13-synopsys-dc-synthesis/.prebuilt)","")
13-synopsys-dc-synthesis/inputs/.stamp.run.saif: 13-synopsys-dc-synthesis/.stamp 12-gen-saif-rtl/outputs/.stamp.run.saif
	$(call symlink,13-synopsys-dc-synthesis/inputs,run.saif,../../12-gen-saif-rtl/outputs/run.saif,.stamp.run.saif)
endif

ifeq ("$(wildcard 13-synopsys-dc-synthesis/.prebuilt)","")
13-synopsys-dc-synthesis/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 13-synopsys-dc-synthesis/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call symlink,13-synopsys-dc-synthesis/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.lef,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.lef,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)
endif

ifeq ("$(wildcard 13-synopsys-dc-synthesis/.prebuilt)","")
13-synopsys-dc-synthesis/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db: 13-synopsys-dc-synthesis/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db
	$(call symlink,13-synopsys-dc-synthesis/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db)
endif

# execute

ifeq ("$(wildcard 13-synopsys-dc-synthesis/.prebuilt)","")

define 13_synopsys_dc_synthesis_commands_rule
	mkdir -p 13-synopsys-dc-synthesis/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t synopsys-dc-synthesis && chmod +x .mflowgen/13-synopsys-dc-synthesis/mflowgen-run && cp -f .mflowgen/13-synopsys-dc-synthesis/mflowgen-run 13-synopsys-dc-synthesis && if [[ -e .mflowgen/13-synopsys-dc-synthesis/mflowgen-debug ]]; then chmod +x .mflowgen/13-synopsys-dc-synthesis/mflowgen-debug && cp -f .mflowgen/13-synopsys-dc-synthesis/mflowgen-debug 13-synopsys-dc-synthesis; fi && if [[ -e .mflowgen/13-synopsys-dc-synthesis/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/13-synopsys-dc-synthesis/mflowgen-check-preconditions.py && cp -f .mflowgen/13-synopsys-dc-synthesis/mflowgen-check-preconditions.py 13-synopsys-dc-synthesis; fi && if [[ -e .mflowgen/13-synopsys-dc-synthesis/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/13-synopsys-dc-synthesis/mflowgen-check-postconditions.py && cp -f .mflowgen/13-synopsys-dc-synthesis/mflowgen-check-postconditions.py 13-synopsys-dc-synthesis; fi && cd 13-synopsys-dc-synthesis && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 13-synopsys-dc-synthesis/outputs/*
endef

13-synopsys-dc-synthesis/.execstamp: 13-synopsys-dc-synthesis/.stamp 13-synopsys-dc-synthesis/inputs/.stamp.adk 13-synopsys-dc-synthesis/inputs/.stamp.compile.tcl 13-synopsys-dc-synthesis/inputs/.stamp.constraints.tcl 13-synopsys-dc-synthesis/inputs/.stamp.design.v 13-synopsys-dc-synthesis/inputs/.stamp.run.saif 13-synopsys-dc-synthesis/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 13-synopsys-dc-synthesis/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db
	$(call 13_synopsys_dc_synthesis_commands_rule)
	touch $@

13-synopsys-dc-synthesis/outputs/.execstamp.design.v: 13-synopsys-dc-synthesis/.execstamp
	touch $@
13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc: 13-synopsys-dc-synthesis/.execstamp
	touch $@
13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap: 13-synopsys-dc-synthesis/.execstamp
	touch $@
13-synopsys-dc-synthesis/outputs/.execstamp.design.svf: 13-synopsys-dc-synthesis/.execstamp
	touch $@
13-synopsys-dc-synthesis/outputs/.execstamp.design.upf: 13-synopsys-dc-synthesis/.execstamp
	touch $@

endif

# collect outputs

13-synopsys-dc-synthesis/outputs/.stamp.design.v: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v
	$(call stamp,13-synopsys-dc-synthesis/outputs/.stamp.design.v)

13-synopsys-dc-synthesis/outputs/.stamp.design.sdc: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v
	$(call stamp,13-synopsys-dc-synthesis/outputs/.stamp.design.sdc)

13-synopsys-dc-synthesis/outputs/.stamp.design.namemap: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v
	$(call stamp,13-synopsys-dc-synthesis/outputs/.stamp.design.namemap)

13-synopsys-dc-synthesis/outputs/.stamp.design.svf: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v
	$(call stamp,13-synopsys-dc-synthesis/outputs/.stamp.design.svf)

13-synopsys-dc-synthesis/outputs/.stamp.design.upf: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v
	$(call stamp,13-synopsys-dc-synthesis/outputs/.stamp.design.upf)

# post-conditions

define 13_synopsys_dc_synthesis_post_conditions_commands_rule
	cd 13-synopsys-dc-synthesis && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

13-synopsys-dc-synthesis/.postconditions.stamp: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc 13-synopsys-dc-synthesis/outputs/.stamp.design.svf 13-synopsys-dc-synthesis/outputs/.stamp.design.upf 13-synopsys-dc-synthesis/outputs/.stamp.design.v
	$(call 13_synopsys_dc_synthesis_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: synopsys-dc-synthesis

synopsys-dc-synthesis: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/.postconditions.stamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc 13-synopsys-dc-synthesis/outputs/.stamp.design.svf 13-synopsys-dc-synthesis/outputs/.stamp.design.upf 13-synopsys-dc-synthesis/outputs/.stamp.design.v

.PHONY: 13

13: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/.postconditions.stamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc 13-synopsys-dc-synthesis/outputs/.stamp.design.svf 13-synopsys-dc-synthesis/outputs/.stamp.design.upf 13-synopsys-dc-synthesis/outputs/.stamp.design.v

# debug

define 13_debug_rule
	cd 13-synopsys-dc-synthesis && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-synopsys-dc-synthesis: 
	$(call 13_debug_rule)

.PHONY: debug-13

debug-13: debug-synopsys-dc-synthesis

# ------------------------------------------------------------------------
# cadence-innovus-flowsetup
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 14-cadence-innovus-flowsetup/.prebuilt)","")
14-cadence-innovus-flowsetup/.stamp: 1-custom-flowstep/.execstamp 1-custom-flowstep/.postconditions.stamp 1-custom-flowstep/outputs/.execstamp.setup.tcl 1-custom-flowstep/outputs/.stamp.setup.tcl
14-cadence-innovus-flowsetup/.stamp: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/.postconditions.stamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc 13-synopsys-dc-synthesis/outputs/.stamp.design.svf 13-synopsys-dc-synthesis/outputs/.stamp.design.upf 13-synopsys-dc-synthesis/outputs/.stamp.design.v
14-cadence-innovus-flowsetup/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
14-cadence-innovus-flowsetup/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
14-cadence-innovus-flowsetup/.stamp:
	$(call cpdir-and-parameterize,14-cadence-innovus-flowsetup,../../../mflowgen/steps/cadence-innovus-flowsetup,14-cadence-innovus-flowsetup/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 14-cadence-innovus-flowsetup/.prebuilt)","")
14-cadence-innovus-flowsetup/inputs/.stamp.adk: 14-cadence-innovus-flowsetup/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,14-cadence-innovus-flowsetup/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 14-cadence-innovus-flowsetup/.prebuilt)","")
14-cadence-innovus-flowsetup/inputs/.stamp.design.sdc: 14-cadence-innovus-flowsetup/.stamp 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc
	$(call symlink,14-cadence-innovus-flowsetup/inputs,design.sdc,../../13-synopsys-dc-synthesis/outputs/design.sdc,.stamp.design.sdc)
endif

ifeq ("$(wildcard 14-cadence-innovus-flowsetup/.prebuilt)","")
14-cadence-innovus-flowsetup/inputs/.stamp.design.v: 14-cadence-innovus-flowsetup/.stamp 13-synopsys-dc-synthesis/outputs/.stamp.design.v
	$(call symlink,14-cadence-innovus-flowsetup/inputs,design.v,../../13-synopsys-dc-synthesis/outputs/design.v,.stamp.design.v)
endif

ifeq ("$(wildcard 14-cadence-innovus-flowsetup/.prebuilt)","")
14-cadence-innovus-flowsetup/inputs/.stamp.setup.tcl: 14-cadence-innovus-flowsetup/.stamp 1-custom-flowstep/outputs/.stamp.setup.tcl
	$(call symlink,14-cadence-innovus-flowsetup/inputs,setup.tcl,../../1-custom-flowstep/outputs/setup.tcl,.stamp.setup.tcl)
endif

ifeq ("$(wildcard 14-cadence-innovus-flowsetup/.prebuilt)","")
14-cadence-innovus-flowsetup/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 14-cadence-innovus-flowsetup/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call symlink,14-cadence-innovus-flowsetup/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.lef,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.lef,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)
endif

ifeq ("$(wildcard 14-cadence-innovus-flowsetup/.prebuilt)","")
14-cadence-innovus-flowsetup/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib: 14-cadence-innovus-flowsetup/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call symlink,14-cadence-innovus-flowsetup/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib)
endif

# execute

ifeq ("$(wildcard 14-cadence-innovus-flowsetup/.prebuilt)","")

define 14_cadence_innovus_flowsetup_commands_rule
	mkdir -p 14-cadence-innovus-flowsetup/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-flowsetup && chmod +x .mflowgen/14-cadence-innovus-flowsetup/mflowgen-run && cp -f .mflowgen/14-cadence-innovus-flowsetup/mflowgen-run 14-cadence-innovus-flowsetup && if [[ -e .mflowgen/14-cadence-innovus-flowsetup/mflowgen-debug ]]; then chmod +x .mflowgen/14-cadence-innovus-flowsetup/mflowgen-debug && cp -f .mflowgen/14-cadence-innovus-flowsetup/mflowgen-debug 14-cadence-innovus-flowsetup; fi && if [[ -e .mflowgen/14-cadence-innovus-flowsetup/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/14-cadence-innovus-flowsetup/mflowgen-check-preconditions.py && cp -f .mflowgen/14-cadence-innovus-flowsetup/mflowgen-check-preconditions.py 14-cadence-innovus-flowsetup; fi && if [[ -e .mflowgen/14-cadence-innovus-flowsetup/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/14-cadence-innovus-flowsetup/mflowgen-check-postconditions.py && cp -f .mflowgen/14-cadence-innovus-flowsetup/mflowgen-check-postconditions.py 14-cadence-innovus-flowsetup; fi && cd 14-cadence-innovus-flowsetup && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 14-cadence-innovus-flowsetup/outputs/*
endef

14-cadence-innovus-flowsetup/.execstamp: 14-cadence-innovus-flowsetup/.stamp 14-cadence-innovus-flowsetup/inputs/.stamp.adk 14-cadence-innovus-flowsetup/inputs/.stamp.design.sdc 14-cadence-innovus-flowsetup/inputs/.stamp.design.v 14-cadence-innovus-flowsetup/inputs/.stamp.setup.tcl 14-cadence-innovus-flowsetup/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 14-cadence-innovus-flowsetup/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call 14_cadence_innovus_flowsetup_commands_rule)
	touch $@

14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow: 14-cadence-innovus-flowsetup/.execstamp
	touch $@

endif

# collect outputs

14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow
	$(call stamp,14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow)

# post-conditions

define 14_cadence_innovus_flowsetup_post_conditions_commands_rule
	cd 14-cadence-innovus-flowsetup && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

14-cadence-innovus-flowsetup/.postconditions.stamp: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
	$(call 14_cadence_innovus_flowsetup_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: cadence-innovus-flowsetup

cadence-innovus-flowsetup: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/.postconditions.stamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow

.PHONY: 14

14: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/.postconditions.stamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow

# debug

# ------------------------------------------------------------------------
# cadence-innovus-init
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 15-cadence-innovus-init/.prebuilt)","")
15-cadence-innovus-init/.stamp: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/.postconditions.stamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc 13-synopsys-dc-synthesis/outputs/.stamp.design.svf 13-synopsys-dc-synthesis/outputs/.stamp.design.upf 13-synopsys-dc-synthesis/outputs/.stamp.design.v
15-cadence-innovus-init/.stamp: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/.postconditions.stamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
15-cadence-innovus-init/.stamp: 2-floorplan/.execstamp 2-floorplan/.postconditions.stamp 2-floorplan/outputs/.execstamp.floorplan.tcl 2-floorplan/outputs/.stamp.floorplan.tcl
15-cadence-innovus-init/.stamp: 5-pin-placement/.execstamp 5-pin-placement/.postconditions.stamp 5-pin-placement/outputs/.execstamp.pin-assignments.tcl 5-pin-placement/outputs/.stamp.pin-assignments.tcl
15-cadence-innovus-init/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
15-cadence-innovus-init/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
15-cadence-innovus-init/.stamp:
	$(call cpdir-and-parameterize,15-cadence-innovus-init,../../../mflowgen/steps/cadence-innovus-init,15-cadence-innovus-init/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 15-cadence-innovus-init/.prebuilt)","")
15-cadence-innovus-init/inputs/.stamp.adk: 15-cadence-innovus-init/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,15-cadence-innovus-init/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 15-cadence-innovus-init/.prebuilt)","")
15-cadence-innovus-init/inputs/.stamp.design.sdc: 15-cadence-innovus-init/.stamp 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc
	$(call symlink,15-cadence-innovus-init/inputs,design.sdc,../../13-synopsys-dc-synthesis/outputs/design.sdc,.stamp.design.sdc)
endif

ifeq ("$(wildcard 15-cadence-innovus-init/.prebuilt)","")
15-cadence-innovus-init/inputs/.stamp.design.v: 15-cadence-innovus-init/.stamp 13-synopsys-dc-synthesis/outputs/.stamp.design.v
	$(call symlink,15-cadence-innovus-init/inputs,design.v,../../13-synopsys-dc-synthesis/outputs/design.v,.stamp.design.v)
endif

ifeq ("$(wildcard 15-cadence-innovus-init/.prebuilt)","")
15-cadence-innovus-init/inputs/.stamp.floorplan.tcl: 15-cadence-innovus-init/.stamp 2-floorplan/outputs/.stamp.floorplan.tcl
	$(call symlink,15-cadence-innovus-init/inputs,floorplan.tcl,../../2-floorplan/outputs/floorplan.tcl,.stamp.floorplan.tcl)
endif

ifeq ("$(wildcard 15-cadence-innovus-init/.prebuilt)","")
15-cadence-innovus-init/inputs/.stamp.innovus-foundation-flow: 15-cadence-innovus-init/.stamp 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
	$(call symlink,15-cadence-innovus-init/inputs,innovus-foundation-flow,../../14-cadence-innovus-flowsetup/outputs/innovus-foundation-flow,.stamp.innovus-foundation-flow)
endif

ifeq ("$(wildcard 15-cadence-innovus-init/.prebuilt)","")
15-cadence-innovus-init/inputs/.stamp.pin-assignments.tcl: 15-cadence-innovus-init/.stamp 5-pin-placement/outputs/.stamp.pin-assignments.tcl
	$(call symlink,15-cadence-innovus-init/inputs,pin-assignments.tcl,../../5-pin-placement/outputs/pin-assignments.tcl,.stamp.pin-assignments.tcl)
endif

ifeq ("$(wildcard 15-cadence-innovus-init/.prebuilt)","")
15-cadence-innovus-init/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 15-cadence-innovus-init/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call symlink,15-cadence-innovus-init/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.lef,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.lef,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)
endif

ifeq ("$(wildcard 15-cadence-innovus-init/.prebuilt)","")
15-cadence-innovus-init/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib: 15-cadence-innovus-init/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call symlink,15-cadence-innovus-init/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib)
endif

# execute

ifeq ("$(wildcard 15-cadence-innovus-init/.prebuilt)","")

define 15_cadence_innovus_init_commands_rule
	mkdir -p 15-cadence-innovus-init/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-init && chmod +x .mflowgen/15-cadence-innovus-init/mflowgen-run && cp -f .mflowgen/15-cadence-innovus-init/mflowgen-run 15-cadence-innovus-init && if [[ -e .mflowgen/15-cadence-innovus-init/mflowgen-debug ]]; then chmod +x .mflowgen/15-cadence-innovus-init/mflowgen-debug && cp -f .mflowgen/15-cadence-innovus-init/mflowgen-debug 15-cadence-innovus-init; fi && if [[ -e .mflowgen/15-cadence-innovus-init/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/15-cadence-innovus-init/mflowgen-check-preconditions.py && cp -f .mflowgen/15-cadence-innovus-init/mflowgen-check-preconditions.py 15-cadence-innovus-init; fi && if [[ -e .mflowgen/15-cadence-innovus-init/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/15-cadence-innovus-init/mflowgen-check-postconditions.py && cp -f .mflowgen/15-cadence-innovus-init/mflowgen-check-postconditions.py 15-cadence-innovus-init; fi && cd 15-cadence-innovus-init && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 15-cadence-innovus-init/outputs/*
endef

15-cadence-innovus-init/.execstamp: 15-cadence-innovus-init/.stamp 15-cadence-innovus-init/inputs/.stamp.adk 15-cadence-innovus-init/inputs/.stamp.design.sdc 15-cadence-innovus-init/inputs/.stamp.design.v 15-cadence-innovus-init/inputs/.stamp.floorplan.tcl 15-cadence-innovus-init/inputs/.stamp.innovus-foundation-flow 15-cadence-innovus-init/inputs/.stamp.pin-assignments.tcl 15-cadence-innovus-init/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 15-cadence-innovus-init/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call 15_cadence_innovus_init_commands_rule)
	touch $@

15-cadence-innovus-init/outputs/.execstamp.design.checkpoint: 15-cadence-innovus-init/.execstamp
	touch $@

endif

# collect outputs

15-cadence-innovus-init/outputs/.stamp.design.checkpoint: 15-cadence-innovus-init/.execstamp 15-cadence-innovus-init/outputs/.execstamp.design.checkpoint
	$(call stamp,15-cadence-innovus-init/outputs/.stamp.design.checkpoint)

# post-conditions

define 15_cadence_innovus_init_post_conditions_commands_rule
	cd 15-cadence-innovus-init && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

15-cadence-innovus-init/.postconditions.stamp: 15-cadence-innovus-init/.execstamp 15-cadence-innovus-init/outputs/.execstamp.design.checkpoint 15-cadence-innovus-init/outputs/.stamp.design.checkpoint
	$(call 15_cadence_innovus_init_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: cadence-innovus-init

cadence-innovus-init: 15-cadence-innovus-init/.execstamp 15-cadence-innovus-init/.postconditions.stamp 15-cadence-innovus-init/outputs/.execstamp.design.checkpoint 15-cadence-innovus-init/outputs/.stamp.design.checkpoint

.PHONY: 15

15: 15-cadence-innovus-init/.execstamp 15-cadence-innovus-init/.postconditions.stamp 15-cadence-innovus-init/outputs/.execstamp.design.checkpoint 15-cadence-innovus-init/outputs/.stamp.design.checkpoint

# debug

define 15_debug_rule
	cd 15-cadence-innovus-init && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-cadence-innovus-init: 
	$(call 15_debug_rule)

.PHONY: debug-15

debug-15: debug-cadence-innovus-init

# ------------------------------------------------------------------------
# cadence-innovus-power
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 16-cadence-innovus-power/.prebuilt)","")
16-cadence-innovus-power/.stamp: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/.postconditions.stamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc 13-synopsys-dc-synthesis/outputs/.stamp.design.svf 13-synopsys-dc-synthesis/outputs/.stamp.design.upf 13-synopsys-dc-synthesis/outputs/.stamp.design.v
16-cadence-innovus-power/.stamp: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/.postconditions.stamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
16-cadence-innovus-power/.stamp: 15-cadence-innovus-init/.execstamp 15-cadence-innovus-init/.postconditions.stamp 15-cadence-innovus-init/outputs/.execstamp.design.checkpoint 15-cadence-innovus-init/outputs/.stamp.design.checkpoint
16-cadence-innovus-power/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
16-cadence-innovus-power/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
16-cadence-innovus-power/.stamp:
	$(call cpdir-and-parameterize,16-cadence-innovus-power,../design/cadence-innovus-power,16-cadence-innovus-power/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 16-cadence-innovus-power/.prebuilt)","")
16-cadence-innovus-power/inputs/.stamp.adk: 16-cadence-innovus-power/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,16-cadence-innovus-power/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 16-cadence-innovus-power/.prebuilt)","")
16-cadence-innovus-power/inputs/.stamp.design.checkpoint: 16-cadence-innovus-power/.stamp 15-cadence-innovus-init/outputs/.stamp.design.checkpoint
	$(call symlink,16-cadence-innovus-power/inputs,design.checkpoint,../../15-cadence-innovus-init/outputs/design.checkpoint,.stamp.design.checkpoint)
endif

ifeq ("$(wildcard 16-cadence-innovus-power/.prebuilt)","")
16-cadence-innovus-power/inputs/.stamp.design.sdc: 16-cadence-innovus-power/.stamp 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc
	$(call symlink,16-cadence-innovus-power/inputs,design.sdc,../../13-synopsys-dc-synthesis/outputs/design.sdc,.stamp.design.sdc)
endif

ifeq ("$(wildcard 16-cadence-innovus-power/.prebuilt)","")
16-cadence-innovus-power/inputs/.stamp.innovus-foundation-flow: 16-cadence-innovus-power/.stamp 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
	$(call symlink,16-cadence-innovus-power/inputs,innovus-foundation-flow,../../14-cadence-innovus-flowsetup/outputs/innovus-foundation-flow,.stamp.innovus-foundation-flow)
endif

ifeq ("$(wildcard 16-cadence-innovus-power/.prebuilt)","")
16-cadence-innovus-power/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 16-cadence-innovus-power/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call symlink,16-cadence-innovus-power/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.lef,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.lef,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)
endif

ifeq ("$(wildcard 16-cadence-innovus-power/.prebuilt)","")
16-cadence-innovus-power/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib: 16-cadence-innovus-power/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call symlink,16-cadence-innovus-power/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib)
endif

# execute

ifeq ("$(wildcard 16-cadence-innovus-power/.prebuilt)","")

define 16_cadence_innovus_power_commands_rule
	mkdir -p 16-cadence-innovus-power/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-power && chmod +x .mflowgen/16-cadence-innovus-power/mflowgen-run && cp -f .mflowgen/16-cadence-innovus-power/mflowgen-run 16-cadence-innovus-power && if [[ -e .mflowgen/16-cadence-innovus-power/mflowgen-debug ]]; then chmod +x .mflowgen/16-cadence-innovus-power/mflowgen-debug && cp -f .mflowgen/16-cadence-innovus-power/mflowgen-debug 16-cadence-innovus-power; fi && if [[ -e .mflowgen/16-cadence-innovus-power/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/16-cadence-innovus-power/mflowgen-check-preconditions.py && cp -f .mflowgen/16-cadence-innovus-power/mflowgen-check-preconditions.py 16-cadence-innovus-power; fi && if [[ -e .mflowgen/16-cadence-innovus-power/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/16-cadence-innovus-power/mflowgen-check-postconditions.py && cp -f .mflowgen/16-cadence-innovus-power/mflowgen-check-postconditions.py 16-cadence-innovus-power; fi && cd 16-cadence-innovus-power && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 16-cadence-innovus-power/outputs/*
endef

16-cadence-innovus-power/.execstamp: 16-cadence-innovus-power/.stamp 16-cadence-innovus-power/inputs/.stamp.adk 16-cadence-innovus-power/inputs/.stamp.design.checkpoint 16-cadence-innovus-power/inputs/.stamp.design.sdc 16-cadence-innovus-power/inputs/.stamp.innovus-foundation-flow 16-cadence-innovus-power/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 16-cadence-innovus-power/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call 16_cadence_innovus_power_commands_rule)
	touch $@

16-cadence-innovus-power/outputs/.execstamp.design.checkpoint: 16-cadence-innovus-power/.execstamp
	touch $@

endif

# collect outputs

16-cadence-innovus-power/outputs/.stamp.design.checkpoint: 16-cadence-innovus-power/.execstamp 16-cadence-innovus-power/outputs/.execstamp.design.checkpoint
	$(call stamp,16-cadence-innovus-power/outputs/.stamp.design.checkpoint)

# post-conditions

define 16_cadence_innovus_power_post_conditions_commands_rule
	cd 16-cadence-innovus-power && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

16-cadence-innovus-power/.postconditions.stamp: 16-cadence-innovus-power/.execstamp 16-cadence-innovus-power/outputs/.execstamp.design.checkpoint 16-cadence-innovus-power/outputs/.stamp.design.checkpoint
	$(call 16_cadence_innovus_power_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: cadence-innovus-power

cadence-innovus-power: 16-cadence-innovus-power/.execstamp 16-cadence-innovus-power/.postconditions.stamp 16-cadence-innovus-power/outputs/.execstamp.design.checkpoint 16-cadence-innovus-power/outputs/.stamp.design.checkpoint

.PHONY: 16

16: 16-cadence-innovus-power/.execstamp 16-cadence-innovus-power/.postconditions.stamp 16-cadence-innovus-power/outputs/.execstamp.design.checkpoint 16-cadence-innovus-power/outputs/.stamp.design.checkpoint

# debug

define 16_debug_rule
	cd 16-cadence-innovus-power && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-cadence-innovus-power: 
	$(call 16_debug_rule)

.PHONY: debug-16

debug-16: debug-cadence-innovus-power

# ------------------------------------------------------------------------
# cadence-innovus-place
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 17-cadence-innovus-place/.prebuilt)","")
17-cadence-innovus-place/.stamp: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/.postconditions.stamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc 13-synopsys-dc-synthesis/outputs/.stamp.design.svf 13-synopsys-dc-synthesis/outputs/.stamp.design.upf 13-synopsys-dc-synthesis/outputs/.stamp.design.v
17-cadence-innovus-place/.stamp: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/.postconditions.stamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
17-cadence-innovus-place/.stamp: 16-cadence-innovus-power/.execstamp 16-cadence-innovus-power/.postconditions.stamp 16-cadence-innovus-power/outputs/.execstamp.design.checkpoint 16-cadence-innovus-power/outputs/.stamp.design.checkpoint
17-cadence-innovus-place/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
17-cadence-innovus-place/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
17-cadence-innovus-place/.stamp:
	$(call cpdir-and-parameterize,17-cadence-innovus-place,../../../mflowgen/steps/cadence-innovus-place,17-cadence-innovus-place/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 17-cadence-innovus-place/.prebuilt)","")
17-cadence-innovus-place/inputs/.stamp.adk: 17-cadence-innovus-place/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,17-cadence-innovus-place/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 17-cadence-innovus-place/.prebuilt)","")
17-cadence-innovus-place/inputs/.stamp.design.checkpoint: 17-cadence-innovus-place/.stamp 16-cadence-innovus-power/outputs/.stamp.design.checkpoint
	$(call symlink,17-cadence-innovus-place/inputs,design.checkpoint,../../16-cadence-innovus-power/outputs/design.checkpoint,.stamp.design.checkpoint)
endif

ifeq ("$(wildcard 17-cadence-innovus-place/.prebuilt)","")
17-cadence-innovus-place/inputs/.stamp.design.sdc: 17-cadence-innovus-place/.stamp 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc
	$(call symlink,17-cadence-innovus-place/inputs,design.sdc,../../13-synopsys-dc-synthesis/outputs/design.sdc,.stamp.design.sdc)
endif

ifeq ("$(wildcard 17-cadence-innovus-place/.prebuilt)","")
17-cadence-innovus-place/inputs/.stamp.innovus-foundation-flow: 17-cadence-innovus-place/.stamp 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
	$(call symlink,17-cadence-innovus-place/inputs,innovus-foundation-flow,../../14-cadence-innovus-flowsetup/outputs/innovus-foundation-flow,.stamp.innovus-foundation-flow)
endif

ifeq ("$(wildcard 17-cadence-innovus-place/.prebuilt)","")
17-cadence-innovus-place/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 17-cadence-innovus-place/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call symlink,17-cadence-innovus-place/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.lef,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.lef,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)
endif

ifeq ("$(wildcard 17-cadence-innovus-place/.prebuilt)","")
17-cadence-innovus-place/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib: 17-cadence-innovus-place/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call symlink,17-cadence-innovus-place/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib)
endif

# execute

ifeq ("$(wildcard 17-cadence-innovus-place/.prebuilt)","")

define 17_cadence_innovus_place_commands_rule
	mkdir -p 17-cadence-innovus-place/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-place && chmod +x .mflowgen/17-cadence-innovus-place/mflowgen-run && cp -f .mflowgen/17-cadence-innovus-place/mflowgen-run 17-cadence-innovus-place && if [[ -e .mflowgen/17-cadence-innovus-place/mflowgen-debug ]]; then chmod +x .mflowgen/17-cadence-innovus-place/mflowgen-debug && cp -f .mflowgen/17-cadence-innovus-place/mflowgen-debug 17-cadence-innovus-place; fi && if [[ -e .mflowgen/17-cadence-innovus-place/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/17-cadence-innovus-place/mflowgen-check-preconditions.py && cp -f .mflowgen/17-cadence-innovus-place/mflowgen-check-preconditions.py 17-cadence-innovus-place; fi && if [[ -e .mflowgen/17-cadence-innovus-place/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/17-cadence-innovus-place/mflowgen-check-postconditions.py && cp -f .mflowgen/17-cadence-innovus-place/mflowgen-check-postconditions.py 17-cadence-innovus-place; fi && cd 17-cadence-innovus-place && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 17-cadence-innovus-place/outputs/*
endef

17-cadence-innovus-place/.execstamp: 17-cadence-innovus-place/.stamp 17-cadence-innovus-place/inputs/.stamp.adk 17-cadence-innovus-place/inputs/.stamp.design.checkpoint 17-cadence-innovus-place/inputs/.stamp.design.sdc 17-cadence-innovus-place/inputs/.stamp.innovus-foundation-flow 17-cadence-innovus-place/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 17-cadence-innovus-place/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call 17_cadence_innovus_place_commands_rule)
	touch $@

17-cadence-innovus-place/outputs/.execstamp.design.checkpoint: 17-cadence-innovus-place/.execstamp
	touch $@

endif

# collect outputs

17-cadence-innovus-place/outputs/.stamp.design.checkpoint: 17-cadence-innovus-place/.execstamp 17-cadence-innovus-place/outputs/.execstamp.design.checkpoint
	$(call stamp,17-cadence-innovus-place/outputs/.stamp.design.checkpoint)

# post-conditions

define 17_cadence_innovus_place_post_conditions_commands_rule
	cd 17-cadence-innovus-place && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

17-cadence-innovus-place/.postconditions.stamp: 17-cadence-innovus-place/.execstamp 17-cadence-innovus-place/outputs/.execstamp.design.checkpoint 17-cadence-innovus-place/outputs/.stamp.design.checkpoint
	$(call 17_cadence_innovus_place_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: cadence-innovus-place

cadence-innovus-place: 17-cadence-innovus-place/.execstamp 17-cadence-innovus-place/.postconditions.stamp 17-cadence-innovus-place/outputs/.execstamp.design.checkpoint 17-cadence-innovus-place/outputs/.stamp.design.checkpoint

.PHONY: 17

17: 17-cadence-innovus-place/.execstamp 17-cadence-innovus-place/.postconditions.stamp 17-cadence-innovus-place/outputs/.execstamp.design.checkpoint 17-cadence-innovus-place/outputs/.stamp.design.checkpoint

# debug

define 17_debug_rule
	cd 17-cadence-innovus-place && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-cadence-innovus-place: 
	$(call 17_debug_rule)

.PHONY: debug-17

debug-17: debug-cadence-innovus-place

# ------------------------------------------------------------------------
# cadence-innovus-cts
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 18-cadence-innovus-cts/.prebuilt)","")
18-cadence-innovus-cts/.stamp: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/.postconditions.stamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc 13-synopsys-dc-synthesis/outputs/.stamp.design.svf 13-synopsys-dc-synthesis/outputs/.stamp.design.upf 13-synopsys-dc-synthesis/outputs/.stamp.design.v
18-cadence-innovus-cts/.stamp: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/.postconditions.stamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
18-cadence-innovus-cts/.stamp: 17-cadence-innovus-place/.execstamp 17-cadence-innovus-place/.postconditions.stamp 17-cadence-innovus-place/outputs/.execstamp.design.checkpoint 17-cadence-innovus-place/outputs/.stamp.design.checkpoint
18-cadence-innovus-cts/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
18-cadence-innovus-cts/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
18-cadence-innovus-cts/.stamp:
	$(call cpdir-and-parameterize,18-cadence-innovus-cts,../../../mflowgen/steps/cadence-innovus-cts,18-cadence-innovus-cts/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 18-cadence-innovus-cts/.prebuilt)","")
18-cadence-innovus-cts/inputs/.stamp.adk: 18-cadence-innovus-cts/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,18-cadence-innovus-cts/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 18-cadence-innovus-cts/.prebuilt)","")
18-cadence-innovus-cts/inputs/.stamp.design.checkpoint: 18-cadence-innovus-cts/.stamp 17-cadence-innovus-place/outputs/.stamp.design.checkpoint
	$(call symlink,18-cadence-innovus-cts/inputs,design.checkpoint,../../17-cadence-innovus-place/outputs/design.checkpoint,.stamp.design.checkpoint)
endif

ifeq ("$(wildcard 18-cadence-innovus-cts/.prebuilt)","")
18-cadence-innovus-cts/inputs/.stamp.design.sdc: 18-cadence-innovus-cts/.stamp 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc
	$(call symlink,18-cadence-innovus-cts/inputs,design.sdc,../../13-synopsys-dc-synthesis/outputs/design.sdc,.stamp.design.sdc)
endif

ifeq ("$(wildcard 18-cadence-innovus-cts/.prebuilt)","")
18-cadence-innovus-cts/inputs/.stamp.innovus-foundation-flow: 18-cadence-innovus-cts/.stamp 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
	$(call symlink,18-cadence-innovus-cts/inputs,innovus-foundation-flow,../../14-cadence-innovus-flowsetup/outputs/innovus-foundation-flow,.stamp.innovus-foundation-flow)
endif

ifeq ("$(wildcard 18-cadence-innovus-cts/.prebuilt)","")
18-cadence-innovus-cts/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 18-cadence-innovus-cts/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call symlink,18-cadence-innovus-cts/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.lef,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.lef,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)
endif

ifeq ("$(wildcard 18-cadence-innovus-cts/.prebuilt)","")
18-cadence-innovus-cts/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib: 18-cadence-innovus-cts/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call symlink,18-cadence-innovus-cts/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib)
endif

# execute

ifeq ("$(wildcard 18-cadence-innovus-cts/.prebuilt)","")

define 18_cadence_innovus_cts_commands_rule
	mkdir -p 18-cadence-innovus-cts/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-cts && chmod +x .mflowgen/18-cadence-innovus-cts/mflowgen-run && cp -f .mflowgen/18-cadence-innovus-cts/mflowgen-run 18-cadence-innovus-cts && if [[ -e .mflowgen/18-cadence-innovus-cts/mflowgen-debug ]]; then chmod +x .mflowgen/18-cadence-innovus-cts/mflowgen-debug && cp -f .mflowgen/18-cadence-innovus-cts/mflowgen-debug 18-cadence-innovus-cts; fi && if [[ -e .mflowgen/18-cadence-innovus-cts/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/18-cadence-innovus-cts/mflowgen-check-preconditions.py && cp -f .mflowgen/18-cadence-innovus-cts/mflowgen-check-preconditions.py 18-cadence-innovus-cts; fi && if [[ -e .mflowgen/18-cadence-innovus-cts/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/18-cadence-innovus-cts/mflowgen-check-postconditions.py && cp -f .mflowgen/18-cadence-innovus-cts/mflowgen-check-postconditions.py 18-cadence-innovus-cts; fi && cd 18-cadence-innovus-cts && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 18-cadence-innovus-cts/outputs/*
endef

18-cadence-innovus-cts/.execstamp: 18-cadence-innovus-cts/.stamp 18-cadence-innovus-cts/inputs/.stamp.adk 18-cadence-innovus-cts/inputs/.stamp.design.checkpoint 18-cadence-innovus-cts/inputs/.stamp.design.sdc 18-cadence-innovus-cts/inputs/.stamp.innovus-foundation-flow 18-cadence-innovus-cts/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 18-cadence-innovus-cts/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call 18_cadence_innovus_cts_commands_rule)
	touch $@

18-cadence-innovus-cts/outputs/.execstamp.design.checkpoint: 18-cadence-innovus-cts/.execstamp
	touch $@

endif

# collect outputs

18-cadence-innovus-cts/outputs/.stamp.design.checkpoint: 18-cadence-innovus-cts/.execstamp 18-cadence-innovus-cts/outputs/.execstamp.design.checkpoint
	$(call stamp,18-cadence-innovus-cts/outputs/.stamp.design.checkpoint)

# post-conditions

define 18_cadence_innovus_cts_post_conditions_commands_rule
	cd 18-cadence-innovus-cts && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

18-cadence-innovus-cts/.postconditions.stamp: 18-cadence-innovus-cts/.execstamp 18-cadence-innovus-cts/outputs/.execstamp.design.checkpoint 18-cadence-innovus-cts/outputs/.stamp.design.checkpoint
	$(call 18_cadence_innovus_cts_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: cadence-innovus-cts

cadence-innovus-cts: 18-cadence-innovus-cts/.execstamp 18-cadence-innovus-cts/.postconditions.stamp 18-cadence-innovus-cts/outputs/.execstamp.design.checkpoint 18-cadence-innovus-cts/outputs/.stamp.design.checkpoint

.PHONY: 18

18: 18-cadence-innovus-cts/.execstamp 18-cadence-innovus-cts/.postconditions.stamp 18-cadence-innovus-cts/outputs/.execstamp.design.checkpoint 18-cadence-innovus-cts/outputs/.stamp.design.checkpoint

# debug

define 18_debug_rule
	cd 18-cadence-innovus-cts && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-cadence-innovus-cts: 
	$(call 18_debug_rule)

.PHONY: debug-18

debug-18: debug-cadence-innovus-cts

# ------------------------------------------------------------------------
# cadence-innovus-postcts_hold
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 19-cadence-innovus-postcts_hold/.prebuilt)","")
19-cadence-innovus-postcts_hold/.stamp: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/.postconditions.stamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
19-cadence-innovus-postcts_hold/.stamp: 18-cadence-innovus-cts/.execstamp 18-cadence-innovus-cts/.postconditions.stamp 18-cadence-innovus-cts/outputs/.execstamp.design.checkpoint 18-cadence-innovus-cts/outputs/.stamp.design.checkpoint
19-cadence-innovus-postcts_hold/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
19-cadence-innovus-postcts_hold/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
19-cadence-innovus-postcts_hold/.stamp:
	$(call cpdir-and-parameterize,19-cadence-innovus-postcts_hold,../../../mflowgen/steps/cadence-innovus-postcts_hold,19-cadence-innovus-postcts_hold/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 19-cadence-innovus-postcts_hold/.prebuilt)","")
19-cadence-innovus-postcts_hold/inputs/.stamp.adk: 19-cadence-innovus-postcts_hold/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,19-cadence-innovus-postcts_hold/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 19-cadence-innovus-postcts_hold/.prebuilt)","")
19-cadence-innovus-postcts_hold/inputs/.stamp.design.checkpoint: 19-cadence-innovus-postcts_hold/.stamp 18-cadence-innovus-cts/outputs/.stamp.design.checkpoint
	$(call symlink,19-cadence-innovus-postcts_hold/inputs,design.checkpoint,../../18-cadence-innovus-cts/outputs/design.checkpoint,.stamp.design.checkpoint)
endif

ifeq ("$(wildcard 19-cadence-innovus-postcts_hold/.prebuilt)","")
19-cadence-innovus-postcts_hold/inputs/.stamp.innovus-foundation-flow: 19-cadence-innovus-postcts_hold/.stamp 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
	$(call symlink,19-cadence-innovus-postcts_hold/inputs,innovus-foundation-flow,../../14-cadence-innovus-flowsetup/outputs/innovus-foundation-flow,.stamp.innovus-foundation-flow)
endif

ifeq ("$(wildcard 19-cadence-innovus-postcts_hold/.prebuilt)","")
19-cadence-innovus-postcts_hold/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 19-cadence-innovus-postcts_hold/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call symlink,19-cadence-innovus-postcts_hold/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.lef,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.lef,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)
endif

ifeq ("$(wildcard 19-cadence-innovus-postcts_hold/.prebuilt)","")
19-cadence-innovus-postcts_hold/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib: 19-cadence-innovus-postcts_hold/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call symlink,19-cadence-innovus-postcts_hold/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib)
endif

# execute

ifeq ("$(wildcard 19-cadence-innovus-postcts_hold/.prebuilt)","")

define 19_cadence_innovus_postcts_hold_commands_rule
	mkdir -p 19-cadence-innovus-postcts_hold/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-postcts_hold && chmod +x .mflowgen/19-cadence-innovus-postcts_hold/mflowgen-run && cp -f .mflowgen/19-cadence-innovus-postcts_hold/mflowgen-run 19-cadence-innovus-postcts_hold && if [[ -e .mflowgen/19-cadence-innovus-postcts_hold/mflowgen-debug ]]; then chmod +x .mflowgen/19-cadence-innovus-postcts_hold/mflowgen-debug && cp -f .mflowgen/19-cadence-innovus-postcts_hold/mflowgen-debug 19-cadence-innovus-postcts_hold; fi && if [[ -e .mflowgen/19-cadence-innovus-postcts_hold/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/19-cadence-innovus-postcts_hold/mflowgen-check-preconditions.py && cp -f .mflowgen/19-cadence-innovus-postcts_hold/mflowgen-check-preconditions.py 19-cadence-innovus-postcts_hold; fi && if [[ -e .mflowgen/19-cadence-innovus-postcts_hold/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/19-cadence-innovus-postcts_hold/mflowgen-check-postconditions.py && cp -f .mflowgen/19-cadence-innovus-postcts_hold/mflowgen-check-postconditions.py 19-cadence-innovus-postcts_hold; fi && cd 19-cadence-innovus-postcts_hold && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 19-cadence-innovus-postcts_hold/outputs/*
endef

19-cadence-innovus-postcts_hold/.execstamp: 19-cadence-innovus-postcts_hold/.stamp 19-cadence-innovus-postcts_hold/inputs/.stamp.adk 19-cadence-innovus-postcts_hold/inputs/.stamp.design.checkpoint 19-cadence-innovus-postcts_hold/inputs/.stamp.innovus-foundation-flow 19-cadence-innovus-postcts_hold/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 19-cadence-innovus-postcts_hold/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call 19_cadence_innovus_postcts_hold_commands_rule)
	touch $@

19-cadence-innovus-postcts_hold/outputs/.execstamp.design.checkpoint: 19-cadence-innovus-postcts_hold/.execstamp
	touch $@

endif

# collect outputs

19-cadence-innovus-postcts_hold/outputs/.stamp.design.checkpoint: 19-cadence-innovus-postcts_hold/.execstamp 19-cadence-innovus-postcts_hold/outputs/.execstamp.design.checkpoint
	$(call stamp,19-cadence-innovus-postcts_hold/outputs/.stamp.design.checkpoint)

# post-conditions

define 19_cadence_innovus_postcts_hold_post_conditions_commands_rule
	cd 19-cadence-innovus-postcts_hold && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

19-cadence-innovus-postcts_hold/.postconditions.stamp: 19-cadence-innovus-postcts_hold/.execstamp 19-cadence-innovus-postcts_hold/outputs/.execstamp.design.checkpoint 19-cadence-innovus-postcts_hold/outputs/.stamp.design.checkpoint
	$(call 19_cadence_innovus_postcts_hold_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: cadence-innovus-postcts_hold

cadence-innovus-postcts_hold: 19-cadence-innovus-postcts_hold/.execstamp 19-cadence-innovus-postcts_hold/.postconditions.stamp 19-cadence-innovus-postcts_hold/outputs/.execstamp.design.checkpoint 19-cadence-innovus-postcts_hold/outputs/.stamp.design.checkpoint

.PHONY: 19

19: 19-cadence-innovus-postcts_hold/.execstamp 19-cadence-innovus-postcts_hold/.postconditions.stamp 19-cadence-innovus-postcts_hold/outputs/.execstamp.design.checkpoint 19-cadence-innovus-postcts_hold/outputs/.stamp.design.checkpoint

# debug

define 19_debug_rule
	cd 19-cadence-innovus-postcts_hold && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-cadence-innovus-postcts_hold: 
	$(call 19_debug_rule)

.PHONY: debug-19

debug-19: debug-cadence-innovus-postcts_hold

# ------------------------------------------------------------------------
# cadence-innovus-route
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 20-cadence-innovus-route/.prebuilt)","")
20-cadence-innovus-route/.stamp: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/.postconditions.stamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
20-cadence-innovus-route/.stamp: 19-cadence-innovus-postcts_hold/.execstamp 19-cadence-innovus-postcts_hold/.postconditions.stamp 19-cadence-innovus-postcts_hold/outputs/.execstamp.design.checkpoint 19-cadence-innovus-postcts_hold/outputs/.stamp.design.checkpoint
20-cadence-innovus-route/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
20-cadence-innovus-route/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
20-cadence-innovus-route/.stamp:
	$(call cpdir-and-parameterize,20-cadence-innovus-route,../../../mflowgen/steps/cadence-innovus-route,20-cadence-innovus-route/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 20-cadence-innovus-route/.prebuilt)","")
20-cadence-innovus-route/inputs/.stamp.adk: 20-cadence-innovus-route/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,20-cadence-innovus-route/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 20-cadence-innovus-route/.prebuilt)","")
20-cadence-innovus-route/inputs/.stamp.design.checkpoint: 20-cadence-innovus-route/.stamp 19-cadence-innovus-postcts_hold/outputs/.stamp.design.checkpoint
	$(call symlink,20-cadence-innovus-route/inputs,design.checkpoint,../../19-cadence-innovus-postcts_hold/outputs/design.checkpoint,.stamp.design.checkpoint)
endif

ifeq ("$(wildcard 20-cadence-innovus-route/.prebuilt)","")
20-cadence-innovus-route/inputs/.stamp.innovus-foundation-flow: 20-cadence-innovus-route/.stamp 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
	$(call symlink,20-cadence-innovus-route/inputs,innovus-foundation-flow,../../14-cadence-innovus-flowsetup/outputs/innovus-foundation-flow,.stamp.innovus-foundation-flow)
endif

ifeq ("$(wildcard 20-cadence-innovus-route/.prebuilt)","")
20-cadence-innovus-route/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 20-cadence-innovus-route/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call symlink,20-cadence-innovus-route/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.lef,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.lef,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)
endif

ifeq ("$(wildcard 20-cadence-innovus-route/.prebuilt)","")
20-cadence-innovus-route/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib: 20-cadence-innovus-route/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call symlink,20-cadence-innovus-route/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib)
endif

# execute

ifeq ("$(wildcard 20-cadence-innovus-route/.prebuilt)","")

define 20_cadence_innovus_route_commands_rule
	mkdir -p 20-cadence-innovus-route/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-route && chmod +x .mflowgen/20-cadence-innovus-route/mflowgen-run && cp -f .mflowgen/20-cadence-innovus-route/mflowgen-run 20-cadence-innovus-route && if [[ -e .mflowgen/20-cadence-innovus-route/mflowgen-debug ]]; then chmod +x .mflowgen/20-cadence-innovus-route/mflowgen-debug && cp -f .mflowgen/20-cadence-innovus-route/mflowgen-debug 20-cadence-innovus-route; fi && if [[ -e .mflowgen/20-cadence-innovus-route/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/20-cadence-innovus-route/mflowgen-check-preconditions.py && cp -f .mflowgen/20-cadence-innovus-route/mflowgen-check-preconditions.py 20-cadence-innovus-route; fi && if [[ -e .mflowgen/20-cadence-innovus-route/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/20-cadence-innovus-route/mflowgen-check-postconditions.py && cp -f .mflowgen/20-cadence-innovus-route/mflowgen-check-postconditions.py 20-cadence-innovus-route; fi && cd 20-cadence-innovus-route && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 20-cadence-innovus-route/outputs/*
endef

20-cadence-innovus-route/.execstamp: 20-cadence-innovus-route/.stamp 20-cadence-innovus-route/inputs/.stamp.adk 20-cadence-innovus-route/inputs/.stamp.design.checkpoint 20-cadence-innovus-route/inputs/.stamp.innovus-foundation-flow 20-cadence-innovus-route/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 20-cadence-innovus-route/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call 20_cadence_innovus_route_commands_rule)
	touch $@

20-cadence-innovus-route/outputs/.execstamp.design.checkpoint: 20-cadence-innovus-route/.execstamp
	touch $@

endif

# collect outputs

20-cadence-innovus-route/outputs/.stamp.design.checkpoint: 20-cadence-innovus-route/.execstamp 20-cadence-innovus-route/outputs/.execstamp.design.checkpoint
	$(call stamp,20-cadence-innovus-route/outputs/.stamp.design.checkpoint)

# post-conditions

define 20_cadence_innovus_route_post_conditions_commands_rule
	cd 20-cadence-innovus-route && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

20-cadence-innovus-route/.postconditions.stamp: 20-cadence-innovus-route/.execstamp 20-cadence-innovus-route/outputs/.execstamp.design.checkpoint 20-cadence-innovus-route/outputs/.stamp.design.checkpoint
	$(call 20_cadence_innovus_route_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: cadence-innovus-route

cadence-innovus-route: 20-cadence-innovus-route/.execstamp 20-cadence-innovus-route/.postconditions.stamp 20-cadence-innovus-route/outputs/.execstamp.design.checkpoint 20-cadence-innovus-route/outputs/.stamp.design.checkpoint

.PHONY: 20

20: 20-cadence-innovus-route/.execstamp 20-cadence-innovus-route/.postconditions.stamp 20-cadence-innovus-route/outputs/.execstamp.design.checkpoint 20-cadence-innovus-route/outputs/.stamp.design.checkpoint

# debug

define 20_debug_rule
	cd 20-cadence-innovus-route && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-cadence-innovus-route: 
	$(call 20_debug_rule)

.PHONY: debug-20

debug-20: debug-cadence-innovus-route

# ------------------------------------------------------------------------
# cadence-innovus-postroute
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 21-cadence-innovus-postroute/.prebuilt)","")
21-cadence-innovus-postroute/.stamp: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/.postconditions.stamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
21-cadence-innovus-postroute/.stamp: 20-cadence-innovus-route/.execstamp 20-cadence-innovus-route/.postconditions.stamp 20-cadence-innovus-route/outputs/.execstamp.design.checkpoint 20-cadence-innovus-route/outputs/.stamp.design.checkpoint
21-cadence-innovus-postroute/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
21-cadence-innovus-postroute/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
21-cadence-innovus-postroute/.stamp:
	$(call cpdir-and-parameterize,21-cadence-innovus-postroute,../../../mflowgen/steps/cadence-innovus-postroute,21-cadence-innovus-postroute/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 21-cadence-innovus-postroute/.prebuilt)","")
21-cadence-innovus-postroute/inputs/.stamp.adk: 21-cadence-innovus-postroute/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,21-cadence-innovus-postroute/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 21-cadence-innovus-postroute/.prebuilt)","")
21-cadence-innovus-postroute/inputs/.stamp.design.checkpoint: 21-cadence-innovus-postroute/.stamp 20-cadence-innovus-route/outputs/.stamp.design.checkpoint
	$(call symlink,21-cadence-innovus-postroute/inputs,design.checkpoint,../../20-cadence-innovus-route/outputs/design.checkpoint,.stamp.design.checkpoint)
endif

ifeq ("$(wildcard 21-cadence-innovus-postroute/.prebuilt)","")
21-cadence-innovus-postroute/inputs/.stamp.innovus-foundation-flow: 21-cadence-innovus-postroute/.stamp 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
	$(call symlink,21-cadence-innovus-postroute/inputs,innovus-foundation-flow,../../14-cadence-innovus-flowsetup/outputs/innovus-foundation-flow,.stamp.innovus-foundation-flow)
endif

ifeq ("$(wildcard 21-cadence-innovus-postroute/.prebuilt)","")
21-cadence-innovus-postroute/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 21-cadence-innovus-postroute/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call symlink,21-cadence-innovus-postroute/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.lef,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.lef,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)
endif

ifeq ("$(wildcard 21-cadence-innovus-postroute/.prebuilt)","")
21-cadence-innovus-postroute/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib: 21-cadence-innovus-postroute/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call symlink,21-cadence-innovus-postroute/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib)
endif

# execute

ifeq ("$(wildcard 21-cadence-innovus-postroute/.prebuilt)","")

define 21_cadence_innovus_postroute_commands_rule
	mkdir -p 21-cadence-innovus-postroute/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-postroute && chmod +x .mflowgen/21-cadence-innovus-postroute/mflowgen-run && cp -f .mflowgen/21-cadence-innovus-postroute/mflowgen-run 21-cadence-innovus-postroute && if [[ -e .mflowgen/21-cadence-innovus-postroute/mflowgen-debug ]]; then chmod +x .mflowgen/21-cadence-innovus-postroute/mflowgen-debug && cp -f .mflowgen/21-cadence-innovus-postroute/mflowgen-debug 21-cadence-innovus-postroute; fi && if [[ -e .mflowgen/21-cadence-innovus-postroute/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/21-cadence-innovus-postroute/mflowgen-check-preconditions.py && cp -f .mflowgen/21-cadence-innovus-postroute/mflowgen-check-preconditions.py 21-cadence-innovus-postroute; fi && if [[ -e .mflowgen/21-cadence-innovus-postroute/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/21-cadence-innovus-postroute/mflowgen-check-postconditions.py && cp -f .mflowgen/21-cadence-innovus-postroute/mflowgen-check-postconditions.py 21-cadence-innovus-postroute; fi && cd 21-cadence-innovus-postroute && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 21-cadence-innovus-postroute/outputs/*
endef

21-cadence-innovus-postroute/.execstamp: 21-cadence-innovus-postroute/.stamp 21-cadence-innovus-postroute/inputs/.stamp.adk 21-cadence-innovus-postroute/inputs/.stamp.design.checkpoint 21-cadence-innovus-postroute/inputs/.stamp.innovus-foundation-flow 21-cadence-innovus-postroute/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 21-cadence-innovus-postroute/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call 21_cadence_innovus_postroute_commands_rule)
	touch $@

21-cadence-innovus-postroute/outputs/.execstamp.design.checkpoint: 21-cadence-innovus-postroute/.execstamp
	touch $@

endif

# collect outputs

21-cadence-innovus-postroute/outputs/.stamp.design.checkpoint: 21-cadence-innovus-postroute/.execstamp 21-cadence-innovus-postroute/outputs/.execstamp.design.checkpoint
	$(call stamp,21-cadence-innovus-postroute/outputs/.stamp.design.checkpoint)

# post-conditions

define 21_cadence_innovus_postroute_post_conditions_commands_rule
	cd 21-cadence-innovus-postroute && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

21-cadence-innovus-postroute/.postconditions.stamp: 21-cadence-innovus-postroute/.execstamp 21-cadence-innovus-postroute/outputs/.execstamp.design.checkpoint 21-cadence-innovus-postroute/outputs/.stamp.design.checkpoint
	$(call 21_cadence_innovus_postroute_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: cadence-innovus-postroute

cadence-innovus-postroute: 21-cadence-innovus-postroute/.execstamp 21-cadence-innovus-postroute/.postconditions.stamp 21-cadence-innovus-postroute/outputs/.execstamp.design.checkpoint 21-cadence-innovus-postroute/outputs/.stamp.design.checkpoint

.PHONY: 21

21: 21-cadence-innovus-postroute/.execstamp 21-cadence-innovus-postroute/.postconditions.stamp 21-cadence-innovus-postroute/outputs/.execstamp.design.checkpoint 21-cadence-innovus-postroute/outputs/.stamp.design.checkpoint

# debug

define 21_debug_rule
	cd 21-cadence-innovus-postroute && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-cadence-innovus-postroute: 
	$(call 21_debug_rule)

.PHONY: debug-21

debug-21: debug-cadence-innovus-postroute

# ------------------------------------------------------------------------
# cadence-innovus-signoff
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 22-cadence-innovus-signoff/.prebuilt)","")
22-cadence-innovus-signoff/.stamp: 14-cadence-innovus-flowsetup/.execstamp 14-cadence-innovus-flowsetup/.postconditions.stamp 14-cadence-innovus-flowsetup/outputs/.execstamp.innovus-foundation-flow 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
22-cadence-innovus-signoff/.stamp: 21-cadence-innovus-postroute/.execstamp 21-cadence-innovus-postroute/.postconditions.stamp 21-cadence-innovus-postroute/outputs/.execstamp.design.checkpoint 21-cadence-innovus-postroute/outputs/.stamp.design.checkpoint
22-cadence-innovus-signoff/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
22-cadence-innovus-signoff/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
22-cadence-innovus-signoff/.stamp:
	$(call cpdir-and-parameterize,22-cadence-innovus-signoff,../design/cadence-innovus-signoff,22-cadence-innovus-signoff/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 22-cadence-innovus-signoff/.prebuilt)","")
22-cadence-innovus-signoff/inputs/.stamp.adk: 22-cadence-innovus-signoff/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,22-cadence-innovus-signoff/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 22-cadence-innovus-signoff/.prebuilt)","")
22-cadence-innovus-signoff/inputs/.stamp.design.checkpoint: 22-cadence-innovus-signoff/.stamp 21-cadence-innovus-postroute/outputs/.stamp.design.checkpoint
	$(call symlink,22-cadence-innovus-signoff/inputs,design.checkpoint,../../21-cadence-innovus-postroute/outputs/design.checkpoint,.stamp.design.checkpoint)
endif

ifeq ("$(wildcard 22-cadence-innovus-signoff/.prebuilt)","")
22-cadence-innovus-signoff/inputs/.stamp.innovus-foundation-flow: 22-cadence-innovus-signoff/.stamp 14-cadence-innovus-flowsetup/outputs/.stamp.innovus-foundation-flow
	$(call symlink,22-cadence-innovus-signoff/inputs,innovus-foundation-flow,../../14-cadence-innovus-flowsetup/outputs/innovus-foundation-flow,.stamp.innovus-foundation-flow)
endif

ifeq ("$(wildcard 22-cadence-innovus-signoff/.prebuilt)","")
22-cadence-innovus-signoff/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 22-cadence-innovus-signoff/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call symlink,22-cadence-innovus-signoff/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.lef,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.lef,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)
endif

ifeq ("$(wildcard 22-cadence-innovus-signoff/.prebuilt)","")
22-cadence-innovus-signoff/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib: 22-cadence-innovus-signoff/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call symlink,22-cadence-innovus-signoff/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib)
endif

# execute

ifeq ("$(wildcard 22-cadence-innovus-signoff/.prebuilt)","")

define 22_cadence_innovus_signoff_commands_rule
	mkdir -p 22-cadence-innovus-signoff/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-signoff && chmod +x .mflowgen/22-cadence-innovus-signoff/mflowgen-run && cp -f .mflowgen/22-cadence-innovus-signoff/mflowgen-run 22-cadence-innovus-signoff && if [[ -e .mflowgen/22-cadence-innovus-signoff/mflowgen-debug ]]; then chmod +x .mflowgen/22-cadence-innovus-signoff/mflowgen-debug && cp -f .mflowgen/22-cadence-innovus-signoff/mflowgen-debug 22-cadence-innovus-signoff; fi && if [[ -e .mflowgen/22-cadence-innovus-signoff/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/22-cadence-innovus-signoff/mflowgen-check-preconditions.py && cp -f .mflowgen/22-cadence-innovus-signoff/mflowgen-check-preconditions.py 22-cadence-innovus-signoff; fi && if [[ -e .mflowgen/22-cadence-innovus-signoff/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/22-cadence-innovus-signoff/mflowgen-check-postconditions.py && cp -f .mflowgen/22-cadence-innovus-signoff/mflowgen-check-postconditions.py 22-cadence-innovus-signoff; fi && cd 22-cadence-innovus-signoff && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 22-cadence-innovus-signoff/outputs/*
endef

22-cadence-innovus-signoff/.execstamp: 22-cadence-innovus-signoff/.stamp 22-cadence-innovus-signoff/inputs/.stamp.adk 22-cadence-innovus-signoff/inputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/inputs/.stamp.innovus-foundation-flow 22-cadence-innovus-signoff/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 22-cadence-innovus-signoff/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
	$(call 22_cadence_innovus_signoff_commands_rule)
	touch $@

22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design.lef: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design.sdc: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design.sdf: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz: 22-cadence-innovus-signoff/.execstamp
	touch $@
22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz: 22-cadence-innovus-signoff/.execstamp
	touch $@

endif

# collect outputs

22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint)

22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz)

22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds)

22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v)

22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v)

22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v)

22-cadence-innovus-signoff/outputs/.stamp.design.lef: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.lef)

22-cadence-innovus-signoff/outputs/.stamp.design.def.gz: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.def.gz)

22-cadence-innovus-signoff/outputs/.stamp.design.sdc: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.sdc)

22-cadence-innovus-signoff/outputs/.stamp.design.sdf: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.sdf)

22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v)

22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz)

22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v
	$(call stamp,22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz)

# post-conditions

define 22_cadence_innovus_signoff_post_conditions_commands_rule
	cd 22-cadence-innovus-signoff && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

22-cadence-innovus-signoff/.postconditions.stamp: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v
	$(call 22_cadence_innovus_signoff_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: cadence-innovus-signoff

cadence-innovus-signoff: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/.postconditions.stamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v

.PHONY: 22

22: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/.postconditions.stamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v

# debug

define 22_debug_rule
	cd 22-cadence-innovus-signoff && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-cadence-innovus-signoff: 
	$(call 22_debug_rule)

.PHONY: debug-22

debug-22: debug-cadence-innovus-signoff

# ------------------------------------------------------------------------
# mentor-calibre-gdsmerge
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 23-mentor-calibre-gdsmerge/.prebuilt)","")
23-mentor-calibre-gdsmerge/.stamp: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/.postconditions.stamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v
23-mentor-calibre-gdsmerge/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
23-mentor-calibre-gdsmerge/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
23-mentor-calibre-gdsmerge/.stamp:
	$(call cpdir-and-parameterize,23-mentor-calibre-gdsmerge,../../../mflowgen/steps/mentor-calibre-gdsmerge,23-mentor-calibre-gdsmerge/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 23-mentor-calibre-gdsmerge/.prebuilt)","")
23-mentor-calibre-gdsmerge/inputs/.stamp.adk: 23-mentor-calibre-gdsmerge/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,23-mentor-calibre-gdsmerge/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 23-mentor-calibre-gdsmerge/.prebuilt)","")
23-mentor-calibre-gdsmerge/inputs/.stamp.design.gds.gz: 23-mentor-calibre-gdsmerge/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz
	$(call symlink,23-mentor-calibre-gdsmerge/inputs,design.gds.gz,../../22-cadence-innovus-signoff/outputs/design.gds.gz,.stamp.design.gds.gz)
endif

ifeq ("$(wildcard 23-mentor-calibre-gdsmerge/.prebuilt)","")
23-mentor-calibre-gdsmerge/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds: 23-mentor-calibre-gdsmerge/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds
	$(call symlink,23-mentor-calibre-gdsmerge/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.gds,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.gds,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds)
endif

# execute

ifeq ("$(wildcard 23-mentor-calibre-gdsmerge/.prebuilt)","")

define 23_mentor_calibre_gdsmerge_commands_rule
	mkdir -p 23-mentor-calibre-gdsmerge/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t mentor-calibre-gdsmerge && chmod +x .mflowgen/23-mentor-calibre-gdsmerge/mflowgen-run && cp -f .mflowgen/23-mentor-calibre-gdsmerge/mflowgen-run 23-mentor-calibre-gdsmerge && if [[ -e .mflowgen/23-mentor-calibre-gdsmerge/mflowgen-debug ]]; then chmod +x .mflowgen/23-mentor-calibre-gdsmerge/mflowgen-debug && cp -f .mflowgen/23-mentor-calibre-gdsmerge/mflowgen-debug 23-mentor-calibre-gdsmerge; fi && if [[ -e .mflowgen/23-mentor-calibre-gdsmerge/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/23-mentor-calibre-gdsmerge/mflowgen-check-preconditions.py && cp -f .mflowgen/23-mentor-calibre-gdsmerge/mflowgen-check-preconditions.py 23-mentor-calibre-gdsmerge; fi && if [[ -e .mflowgen/23-mentor-calibre-gdsmerge/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/23-mentor-calibre-gdsmerge/mflowgen-check-postconditions.py && cp -f .mflowgen/23-mentor-calibre-gdsmerge/mflowgen-check-postconditions.py 23-mentor-calibre-gdsmerge; fi && cd 23-mentor-calibre-gdsmerge && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 23-mentor-calibre-gdsmerge/outputs/*
endef

23-mentor-calibre-gdsmerge/.execstamp: 23-mentor-calibre-gdsmerge/.stamp 23-mentor-calibre-gdsmerge/inputs/.stamp.adk 23-mentor-calibre-gdsmerge/inputs/.stamp.design.gds.gz 23-mentor-calibre-gdsmerge/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds
	$(call 23_mentor_calibre_gdsmerge_commands_rule)
	touch $@

23-mentor-calibre-gdsmerge/outputs/.execstamp.design_merged.gds: 23-mentor-calibre-gdsmerge/.execstamp
	touch $@

endif

# collect outputs

23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds: 23-mentor-calibre-gdsmerge/.execstamp 23-mentor-calibre-gdsmerge/outputs/.execstamp.design_merged.gds
	$(call stamp,23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds)

# post-conditions

define 23_mentor_calibre_gdsmerge_post_conditions_commands_rule
	cd 23-mentor-calibre-gdsmerge && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

23-mentor-calibre-gdsmerge/.postconditions.stamp: 23-mentor-calibre-gdsmerge/.execstamp 23-mentor-calibre-gdsmerge/outputs/.execstamp.design_merged.gds 23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds
	$(call 23_mentor_calibre_gdsmerge_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: mentor-calibre-gdsmerge

mentor-calibre-gdsmerge: 23-mentor-calibre-gdsmerge/.execstamp 23-mentor-calibre-gdsmerge/.postconditions.stamp 23-mentor-calibre-gdsmerge/outputs/.execstamp.design_merged.gds 23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds

.PHONY: 23

23: 23-mentor-calibre-gdsmerge/.execstamp 23-mentor-calibre-gdsmerge/.postconditions.stamp 23-mentor-calibre-gdsmerge/outputs/.execstamp.design_merged.gds 23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds

# debug

define 23_debug_rule
	cd 23-mentor-calibre-gdsmerge && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-mentor-calibre-gdsmerge: 
	$(call 23_debug_rule)

.PHONY: debug-23

debug-23: debug-mentor-calibre-gdsmerge

# ------------------------------------------------------------------------
# open-magic-def2spice
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 24-open-magic-def2spice/.prebuilt)","")
24-open-magic-def2spice/.stamp: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/.postconditions.stamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v
24-open-magic-def2spice/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
24-open-magic-def2spice/.stamp:
	$(call cpdir-and-parameterize,24-open-magic-def2spice,../design/open-magic-def2spice,24-open-magic-def2spice/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 24-open-magic-def2spice/.prebuilt)","")
24-open-magic-def2spice/inputs/.stamp.adk: 24-open-magic-def2spice/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,24-open-magic-def2spice/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 24-open-magic-def2spice/.prebuilt)","")
24-open-magic-def2spice/inputs/.stamp.design.def.gz: 24-open-magic-def2spice/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz
	$(call symlink,24-open-magic-def2spice/inputs,design.def.gz,../../22-cadence-innovus-signoff/outputs/design.def.gz,.stamp.design.def.gz)
endif

# execute

ifeq ("$(wildcard 24-open-magic-def2spice/.prebuilt)","")

define 24_open_magic_def2spice_commands_rule
	mkdir -p 24-open-magic-def2spice/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t open-magic-def2spice && chmod +x .mflowgen/24-open-magic-def2spice/mflowgen-run && cp -f .mflowgen/24-open-magic-def2spice/mflowgen-run 24-open-magic-def2spice && if [[ -e .mflowgen/24-open-magic-def2spice/mflowgen-debug ]]; then chmod +x .mflowgen/24-open-magic-def2spice/mflowgen-debug && cp -f .mflowgen/24-open-magic-def2spice/mflowgen-debug 24-open-magic-def2spice; fi && if [[ -e .mflowgen/24-open-magic-def2spice/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/24-open-magic-def2spice/mflowgen-check-preconditions.py && cp -f .mflowgen/24-open-magic-def2spice/mflowgen-check-preconditions.py 24-open-magic-def2spice; fi && if [[ -e .mflowgen/24-open-magic-def2spice/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/24-open-magic-def2spice/mflowgen-check-postconditions.py && cp -f .mflowgen/24-open-magic-def2spice/mflowgen-check-postconditions.py 24-open-magic-def2spice; fi && cd 24-open-magic-def2spice && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 24-open-magic-def2spice/outputs/*
endef

24-open-magic-def2spice/.execstamp: 24-open-magic-def2spice/.stamp 24-open-magic-def2spice/inputs/.stamp.adk 24-open-magic-def2spice/inputs/.stamp.design.def.gz
	$(call 24_open_magic_def2spice_commands_rule)
	touch $@

24-open-magic-def2spice/outputs/.execstamp.design_extracted.spice: 24-open-magic-def2spice/.execstamp
	touch $@

endif

# collect outputs

24-open-magic-def2spice/outputs/.stamp.design_extracted.spice: 24-open-magic-def2spice/.execstamp 24-open-magic-def2spice/outputs/.execstamp.design_extracted.spice
	$(call stamp,24-open-magic-def2spice/outputs/.stamp.design_extracted.spice)

# post-conditions

define 24_open_magic_def2spice_post_conditions_commands_rule
	cd 24-open-magic-def2spice && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

24-open-magic-def2spice/.postconditions.stamp: 24-open-magic-def2spice/.execstamp 24-open-magic-def2spice/outputs/.execstamp.design_extracted.spice 24-open-magic-def2spice/outputs/.stamp.design_extracted.spice
	$(call 24_open_magic_def2spice_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: open-magic-def2spice

open-magic-def2spice: 24-open-magic-def2spice/.execstamp 24-open-magic-def2spice/.postconditions.stamp 24-open-magic-def2spice/outputs/.execstamp.design_extracted.spice 24-open-magic-def2spice/outputs/.stamp.design_extracted.spice

.PHONY: 24

24: 24-open-magic-def2spice/.execstamp 24-open-magic-def2spice/.postconditions.stamp 24-open-magic-def2spice/outputs/.execstamp.design_extracted.spice 24-open-magic-def2spice/outputs/.stamp.design_extracted.spice

# debug

# ------------------------------------------------------------------------
# ptpx-gl
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 25-ptpx-gl/.prebuilt)","")
25-ptpx-gl/.stamp: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/.postconditions.stamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc 13-synopsys-dc-synthesis/outputs/.stamp.design.svf 13-synopsys-dc-synthesis/outputs/.stamp.design.upf 13-synopsys-dc-synthesis/outputs/.stamp.design.v
25-ptpx-gl/.stamp: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/.postconditions.stamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v
25-ptpx-gl/.stamp: 3-gen-saif-gl/.execstamp 3-gen-saif-gl/.postconditions.stamp 3-gen-saif-gl/outputs/.execstamp.run.saif 3-gen-saif-gl/outputs/.stamp.run.saif
25-ptpx-gl/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
25-ptpx-gl/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
25-ptpx-gl/.stamp:
	$(call cpdir-and-parameterize,25-ptpx-gl,../design/synopsys-pt-power,25-ptpx-gl/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 25-ptpx-gl/.prebuilt)","")
25-ptpx-gl/inputs/.stamp.adk: 25-ptpx-gl/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,25-ptpx-gl/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 25-ptpx-gl/.prebuilt)","")
25-ptpx-gl/inputs/.stamp.design.pt.sdc: 25-ptpx-gl/.stamp 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc
	$(call symlink,25-ptpx-gl/inputs,design.pt.sdc,../../13-synopsys-dc-synthesis/outputs/design.sdc,.stamp.design.pt.sdc)
endif

ifeq ("$(wildcard 25-ptpx-gl/.prebuilt)","")
25-ptpx-gl/inputs/.stamp.design.spef.gz: 25-ptpx-gl/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz
	$(call symlink,25-ptpx-gl/inputs,design.spef.gz,../../22-cadence-innovus-signoff/outputs/design.spef.gz,.stamp.design.spef.gz)
endif

ifeq ("$(wildcard 25-ptpx-gl/.prebuilt)","")
25-ptpx-gl/inputs/.stamp.design.vcs.v: 25-ptpx-gl/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v
	$(call symlink,25-ptpx-gl/inputs,design.vcs.v,../../22-cadence-innovus-signoff/outputs/design.vcs.v,.stamp.design.vcs.v)
endif

ifeq ("$(wildcard 25-ptpx-gl/.prebuilt)","")
25-ptpx-gl/inputs/.stamp.run.saif: 25-ptpx-gl/.stamp 3-gen-saif-gl/outputs/.stamp.run.saif
	$(call symlink,25-ptpx-gl/inputs,run.saif,../../3-gen-saif-gl/outputs/run.saif,.stamp.run.saif)
endif

ifeq ("$(wildcard 25-ptpx-gl/.prebuilt)","")
25-ptpx-gl/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db: 25-ptpx-gl/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db
	$(call symlink,25-ptpx-gl/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db)
endif

# execute

ifeq ("$(wildcard 25-ptpx-gl/.prebuilt)","")

define 25_ptpx_gl_commands_rule
	mkdir -p 25-ptpx-gl/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t ptpx-gl && chmod +x .mflowgen/25-ptpx-gl/mflowgen-run && cp -f .mflowgen/25-ptpx-gl/mflowgen-run 25-ptpx-gl && if [[ -e .mflowgen/25-ptpx-gl/mflowgen-debug ]]; then chmod +x .mflowgen/25-ptpx-gl/mflowgen-debug && cp -f .mflowgen/25-ptpx-gl/mflowgen-debug 25-ptpx-gl; fi && if [[ -e .mflowgen/25-ptpx-gl/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/25-ptpx-gl/mflowgen-check-preconditions.py && cp -f .mflowgen/25-ptpx-gl/mflowgen-check-preconditions.py 25-ptpx-gl; fi && if [[ -e .mflowgen/25-ptpx-gl/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/25-ptpx-gl/mflowgen-check-postconditions.py && cp -f .mflowgen/25-ptpx-gl/mflowgen-check-postconditions.py 25-ptpx-gl; fi && cd 25-ptpx-gl && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 25-ptpx-gl/outputs/*
endef

25-ptpx-gl/.execstamp: 25-ptpx-gl/.stamp 25-ptpx-gl/inputs/.stamp.adk 25-ptpx-gl/inputs/.stamp.design.pt.sdc 25-ptpx-gl/inputs/.stamp.design.spef.gz 25-ptpx-gl/inputs/.stamp.design.vcs.v 25-ptpx-gl/inputs/.stamp.run.saif 25-ptpx-gl/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db
	$(call 25_ptpx_gl_commands_rule)
	touch $@

25-ptpx-gl/outputs/.execstamp.primetime.session: 25-ptpx-gl/.execstamp
	touch $@
25-ptpx-gl/outputs/.execstamp.design.sdf: 25-ptpx-gl/.execstamp
	touch $@

endif

# collect outputs

25-ptpx-gl/outputs/.stamp.primetime.session: 25-ptpx-gl/.execstamp 25-ptpx-gl/outputs/.execstamp.design.sdf 25-ptpx-gl/outputs/.execstamp.primetime.session
	$(call stamp,25-ptpx-gl/outputs/.stamp.primetime.session)

25-ptpx-gl/outputs/.stamp.design.sdf: 25-ptpx-gl/.execstamp 25-ptpx-gl/outputs/.execstamp.design.sdf 25-ptpx-gl/outputs/.execstamp.primetime.session
	$(call stamp,25-ptpx-gl/outputs/.stamp.design.sdf)

# post-conditions

define 25_ptpx_gl_post_conditions_commands_rule
	cd 25-ptpx-gl && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

25-ptpx-gl/.postconditions.stamp: 25-ptpx-gl/.execstamp 25-ptpx-gl/outputs/.execstamp.design.sdf 25-ptpx-gl/outputs/.execstamp.primetime.session 25-ptpx-gl/outputs/.stamp.design.sdf 25-ptpx-gl/outputs/.stamp.primetime.session
	$(call 25_ptpx_gl_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: ptpx-gl

ptpx-gl: 25-ptpx-gl/.execstamp 25-ptpx-gl/.postconditions.stamp 25-ptpx-gl/outputs/.execstamp.design.sdf 25-ptpx-gl/outputs/.execstamp.primetime.session 25-ptpx-gl/outputs/.stamp.design.sdf 25-ptpx-gl/outputs/.stamp.primetime.session

.PHONY: 25

25: 25-ptpx-gl/.execstamp 25-ptpx-gl/.postconditions.stamp 25-ptpx-gl/outputs/.execstamp.design.sdf 25-ptpx-gl/outputs/.execstamp.primetime.session 25-ptpx-gl/outputs/.stamp.design.sdf 25-ptpx-gl/outputs/.stamp.primetime.session

# debug

define 25_debug_rule
	cd 25-ptpx-gl && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-ptpx-gl: 
	$(call 25_debug_rule)

.PHONY: debug-25

debug-25: debug-ptpx-gl

# ------------------------------------------------------------------------
# ptpx-rtl
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 26-ptpx-rtl/.prebuilt)","")
26-ptpx-rtl/.stamp: 12-gen-saif-rtl/.execstamp 12-gen-saif-rtl/.postconditions.stamp 12-gen-saif-rtl/outputs/.execstamp.run.saif 12-gen-saif-rtl/outputs/.stamp.run.saif
26-ptpx-rtl/.stamp: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/.postconditions.stamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc 13-synopsys-dc-synthesis/outputs/.stamp.design.svf 13-synopsys-dc-synthesis/outputs/.stamp.design.upf 13-synopsys-dc-synthesis/outputs/.stamp.design.v
26-ptpx-rtl/.stamp: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/.postconditions.stamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v
26-ptpx-rtl/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
26-ptpx-rtl/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
26-ptpx-rtl/.stamp:
	$(call cpdir-and-parameterize,26-ptpx-rtl,../design/synopsys-pt-power,26-ptpx-rtl/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 26-ptpx-rtl/.prebuilt)","")
26-ptpx-rtl/inputs/.stamp.adk: 26-ptpx-rtl/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,26-ptpx-rtl/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 26-ptpx-rtl/.prebuilt)","")
26-ptpx-rtl/inputs/.stamp.design.namemap: 26-ptpx-rtl/.stamp 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap
	$(call symlink,26-ptpx-rtl/inputs,design.namemap,../../13-synopsys-dc-synthesis/outputs/design.namemap,.stamp.design.namemap)
endif

ifeq ("$(wildcard 26-ptpx-rtl/.prebuilt)","")
26-ptpx-rtl/inputs/.stamp.design.pt.sdc: 26-ptpx-rtl/.stamp 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc
	$(call symlink,26-ptpx-rtl/inputs,design.pt.sdc,../../13-synopsys-dc-synthesis/outputs/design.sdc,.stamp.design.pt.sdc)
endif

ifeq ("$(wildcard 26-ptpx-rtl/.prebuilt)","")
26-ptpx-rtl/inputs/.stamp.design.spef.gz: 26-ptpx-rtl/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz
	$(call symlink,26-ptpx-rtl/inputs,design.spef.gz,../../22-cadence-innovus-signoff/outputs/design.spef.gz,.stamp.design.spef.gz)
endif

ifeq ("$(wildcard 26-ptpx-rtl/.prebuilt)","")
26-ptpx-rtl/inputs/.stamp.design.vcs.v: 26-ptpx-rtl/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v
	$(call symlink,26-ptpx-rtl/inputs,design.vcs.v,../../22-cadence-innovus-signoff/outputs/design.vcs.v,.stamp.design.vcs.v)
endif

ifeq ("$(wildcard 26-ptpx-rtl/.prebuilt)","")
26-ptpx-rtl/inputs/.stamp.run.saif: 26-ptpx-rtl/.stamp 12-gen-saif-rtl/outputs/.stamp.run.saif
	$(call symlink,26-ptpx-rtl/inputs,run.saif,../../12-gen-saif-rtl/outputs/run.saif,.stamp.run.saif)
endif

ifeq ("$(wildcard 26-ptpx-rtl/.prebuilt)","")
26-ptpx-rtl/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db: 26-ptpx-rtl/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db
	$(call symlink,26-ptpx-rtl/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db)
endif

# execute

ifeq ("$(wildcard 26-ptpx-rtl/.prebuilt)","")

define 26_ptpx_rtl_commands_rule
	mkdir -p 26-ptpx-rtl/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t ptpx-rtl && chmod +x .mflowgen/26-ptpx-rtl/mflowgen-run && cp -f .mflowgen/26-ptpx-rtl/mflowgen-run 26-ptpx-rtl && if [[ -e .mflowgen/26-ptpx-rtl/mflowgen-debug ]]; then chmod +x .mflowgen/26-ptpx-rtl/mflowgen-debug && cp -f .mflowgen/26-ptpx-rtl/mflowgen-debug 26-ptpx-rtl; fi && if [[ -e .mflowgen/26-ptpx-rtl/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/26-ptpx-rtl/mflowgen-check-preconditions.py && cp -f .mflowgen/26-ptpx-rtl/mflowgen-check-preconditions.py 26-ptpx-rtl; fi && if [[ -e .mflowgen/26-ptpx-rtl/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/26-ptpx-rtl/mflowgen-check-postconditions.py && cp -f .mflowgen/26-ptpx-rtl/mflowgen-check-postconditions.py 26-ptpx-rtl; fi && cd 26-ptpx-rtl && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 26-ptpx-rtl/outputs/*
endef

26-ptpx-rtl/.execstamp: 26-ptpx-rtl/.stamp 26-ptpx-rtl/inputs/.stamp.adk 26-ptpx-rtl/inputs/.stamp.design.namemap 26-ptpx-rtl/inputs/.stamp.design.pt.sdc 26-ptpx-rtl/inputs/.stamp.design.spef.gz 26-ptpx-rtl/inputs/.stamp.design.vcs.v 26-ptpx-rtl/inputs/.stamp.run.saif 26-ptpx-rtl/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db
	$(call 26_ptpx_rtl_commands_rule)
	touch $@

26-ptpx-rtl/outputs/.execstamp.primetime.session: 26-ptpx-rtl/.execstamp
	touch $@
26-ptpx-rtl/outputs/.execstamp.design.sdf: 26-ptpx-rtl/.execstamp
	touch $@

endif

# collect outputs

26-ptpx-rtl/outputs/.stamp.primetime.session: 26-ptpx-rtl/.execstamp 26-ptpx-rtl/outputs/.execstamp.design.sdf 26-ptpx-rtl/outputs/.execstamp.primetime.session
	$(call stamp,26-ptpx-rtl/outputs/.stamp.primetime.session)

26-ptpx-rtl/outputs/.stamp.design.sdf: 26-ptpx-rtl/.execstamp 26-ptpx-rtl/outputs/.execstamp.design.sdf 26-ptpx-rtl/outputs/.execstamp.primetime.session
	$(call stamp,26-ptpx-rtl/outputs/.stamp.design.sdf)

# post-conditions

define 26_ptpx_rtl_post_conditions_commands_rule
	cd 26-ptpx-rtl && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

26-ptpx-rtl/.postconditions.stamp: 26-ptpx-rtl/.execstamp 26-ptpx-rtl/outputs/.execstamp.design.sdf 26-ptpx-rtl/outputs/.execstamp.primetime.session 26-ptpx-rtl/outputs/.stamp.design.sdf 26-ptpx-rtl/outputs/.stamp.primetime.session
	$(call 26_ptpx_rtl_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: ptpx-rtl

ptpx-rtl: 26-ptpx-rtl/.execstamp 26-ptpx-rtl/.postconditions.stamp 26-ptpx-rtl/outputs/.execstamp.design.sdf 26-ptpx-rtl/outputs/.execstamp.primetime.session 26-ptpx-rtl/outputs/.stamp.design.sdf 26-ptpx-rtl/outputs/.stamp.primetime.session

.PHONY: 26

26: 26-ptpx-rtl/.execstamp 26-ptpx-rtl/.postconditions.stamp 26-ptpx-rtl/outputs/.execstamp.design.sdf 26-ptpx-rtl/outputs/.execstamp.primetime.session 26-ptpx-rtl/outputs/.stamp.design.sdf 26-ptpx-rtl/outputs/.stamp.primetime.session

# debug

define 26_debug_rule
	cd 26-ptpx-rtl && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-ptpx-rtl: 
	$(call 26_debug_rule)

.PHONY: debug-26

debug-26: debug-ptpx-rtl

# ------------------------------------------------------------------------
# synopsys-pt-timing-signoff
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 27-synopsys-pt-timing-signoff/.prebuilt)","")
27-synopsys-pt-timing-signoff/.stamp: 13-synopsys-dc-synthesis/.execstamp 13-synopsys-dc-synthesis/.postconditions.stamp 13-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 13-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 13-synopsys-dc-synthesis/outputs/.execstamp.design.svf 13-synopsys-dc-synthesis/outputs/.execstamp.design.upf 13-synopsys-dc-synthesis/outputs/.execstamp.design.v 13-synopsys-dc-synthesis/outputs/.stamp.design.namemap 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc 13-synopsys-dc-synthesis/outputs/.stamp.design.svf 13-synopsys-dc-synthesis/outputs/.stamp.design.upf 13-synopsys-dc-synthesis/outputs/.stamp.design.v
27-synopsys-pt-timing-signoff/.stamp: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/.postconditions.stamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v
27-synopsys-pt-timing-signoff/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
27-synopsys-pt-timing-signoff/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
27-synopsys-pt-timing-signoff/.stamp:
	$(call cpdir-and-parameterize,27-synopsys-pt-timing-signoff,../design/synopsys-pt-timing-signoff,27-synopsys-pt-timing-signoff/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 27-synopsys-pt-timing-signoff/.prebuilt)","")
27-synopsys-pt-timing-signoff/inputs/.stamp.adk: 27-synopsys-pt-timing-signoff/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,27-synopsys-pt-timing-signoff/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 27-synopsys-pt-timing-signoff/.prebuilt)","")
27-synopsys-pt-timing-signoff/inputs/.stamp.design.pt.sdc: 27-synopsys-pt-timing-signoff/.stamp 13-synopsys-dc-synthesis/outputs/.stamp.design.sdc
	$(call symlink,27-synopsys-pt-timing-signoff/inputs,design.pt.sdc,../../13-synopsys-dc-synthesis/outputs/design.sdc,.stamp.design.pt.sdc)
endif

ifeq ("$(wildcard 27-synopsys-pt-timing-signoff/.prebuilt)","")
27-synopsys-pt-timing-signoff/inputs/.stamp.design.spef.gz: 27-synopsys-pt-timing-signoff/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz
	$(call symlink,27-synopsys-pt-timing-signoff/inputs,design.spef.gz,../../22-cadence-innovus-signoff/outputs/design.spef.gz,.stamp.design.spef.gz)
endif

ifeq ("$(wildcard 27-synopsys-pt-timing-signoff/.prebuilt)","")
27-synopsys-pt-timing-signoff/inputs/.stamp.design.vcs.v: 27-synopsys-pt-timing-signoff/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v
	$(call symlink,27-synopsys-pt-timing-signoff/inputs,design.vcs.v,../../22-cadence-innovus-signoff/outputs/design.vcs.v,.stamp.design.vcs.v)
endif

ifeq ("$(wildcard 27-synopsys-pt-timing-signoff/.prebuilt)","")
27-synopsys-pt-timing-signoff/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db: 27-synopsys-pt-timing-signoff/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db
	$(call symlink,27-synopsys-pt-timing-signoff/inputs,sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db)
endif

# execute

ifeq ("$(wildcard 27-synopsys-pt-timing-signoff/.prebuilt)","")

define 27_synopsys_pt_timing_signoff_commands_rule
	mkdir -p 27-synopsys-pt-timing-signoff/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t synopsys-pt-timing-signoff && chmod +x .mflowgen/27-synopsys-pt-timing-signoff/mflowgen-run && cp -f .mflowgen/27-synopsys-pt-timing-signoff/mflowgen-run 27-synopsys-pt-timing-signoff && if [[ -e .mflowgen/27-synopsys-pt-timing-signoff/mflowgen-debug ]]; then chmod +x .mflowgen/27-synopsys-pt-timing-signoff/mflowgen-debug && cp -f .mflowgen/27-synopsys-pt-timing-signoff/mflowgen-debug 27-synopsys-pt-timing-signoff; fi && if [[ -e .mflowgen/27-synopsys-pt-timing-signoff/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/27-synopsys-pt-timing-signoff/mflowgen-check-preconditions.py && cp -f .mflowgen/27-synopsys-pt-timing-signoff/mflowgen-check-preconditions.py 27-synopsys-pt-timing-signoff; fi && if [[ -e .mflowgen/27-synopsys-pt-timing-signoff/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/27-synopsys-pt-timing-signoff/mflowgen-check-postconditions.py && cp -f .mflowgen/27-synopsys-pt-timing-signoff/mflowgen-check-postconditions.py 27-synopsys-pt-timing-signoff; fi && cd 27-synopsys-pt-timing-signoff && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 27-synopsys-pt-timing-signoff/outputs/*
endef

27-synopsys-pt-timing-signoff/.execstamp: 27-synopsys-pt-timing-signoff/.stamp 27-synopsys-pt-timing-signoff/inputs/.stamp.adk 27-synopsys-pt-timing-signoff/inputs/.stamp.design.pt.sdc 27-synopsys-pt-timing-signoff/inputs/.stamp.design.spef.gz 27-synopsys-pt-timing-signoff/inputs/.stamp.design.vcs.v 27-synopsys-pt-timing-signoff/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db
	$(call 27_synopsys_pt_timing_signoff_commands_rule)
	touch $@

27-synopsys-pt-timing-signoff/outputs/.execstamp.design.sdf: 27-synopsys-pt-timing-signoff/.execstamp
	touch $@

endif

# collect outputs

27-synopsys-pt-timing-signoff/outputs/.stamp.design.sdf: 27-synopsys-pt-timing-signoff/.execstamp 27-synopsys-pt-timing-signoff/outputs/.execstamp.design.sdf
	$(call stamp,27-synopsys-pt-timing-signoff/outputs/.stamp.design.sdf)

# post-conditions

define 27_synopsys_pt_timing_signoff_post_conditions_commands_rule
	cd 27-synopsys-pt-timing-signoff && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

27-synopsys-pt-timing-signoff/.postconditions.stamp: 27-synopsys-pt-timing-signoff/.execstamp 27-synopsys-pt-timing-signoff/outputs/.execstamp.design.sdf 27-synopsys-pt-timing-signoff/outputs/.stamp.design.sdf
	$(call 27_synopsys_pt_timing_signoff_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: synopsys-pt-timing-signoff

synopsys-pt-timing-signoff: 27-synopsys-pt-timing-signoff/.execstamp 27-synopsys-pt-timing-signoff/.postconditions.stamp 27-synopsys-pt-timing-signoff/outputs/.execstamp.design.sdf 27-synopsys-pt-timing-signoff/outputs/.stamp.design.sdf

.PHONY: 27

27: 27-synopsys-pt-timing-signoff/.execstamp 27-synopsys-pt-timing-signoff/.postconditions.stamp 27-synopsys-pt-timing-signoff/outputs/.execstamp.design.sdf 27-synopsys-pt-timing-signoff/outputs/.stamp.design.sdf

# debug

# ------------------------------------------------------------------------
# gl-sim
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 28-gl-sim/.prebuilt)","")
28-gl-sim/.stamp: 10-testbench/.execstamp 10-testbench/.postconditions.stamp 10-testbench/outputs/.execstamp.design.args 10-testbench/outputs/.execstamp.design.args.gls 10-testbench/outputs/.execstamp.input_data.txt 10-testbench/outputs/.execstamp.instr_data.txt 10-testbench/outputs/.execstamp.testbench.sv 10-testbench/outputs/.stamp.design.args 10-testbench/outputs/.stamp.design.args.gls 10-testbench/outputs/.stamp.input_data.txt 10-testbench/outputs/.stamp.instr_data.txt 10-testbench/outputs/.stamp.testbench.sv
28-gl-sim/.stamp: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/.postconditions.stamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v
28-gl-sim/.stamp: 27-synopsys-pt-timing-signoff/.execstamp 27-synopsys-pt-timing-signoff/.postconditions.stamp 27-synopsys-pt-timing-signoff/outputs/.execstamp.design.sdf 27-synopsys-pt-timing-signoff/outputs/.stamp.design.sdf
28-gl-sim/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
28-gl-sim/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
28-gl-sim/.stamp:
	$(call cpdir-and-parameterize,28-gl-sim,../design/synopsys-vcs-sim-sdf,28-gl-sim/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 28-gl-sim/.prebuilt)","")
28-gl-sim/inputs/.stamp.adk: 28-gl-sim/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,28-gl-sim/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 28-gl-sim/.prebuilt)","")
28-gl-sim/inputs/.stamp.design.args: 28-gl-sim/.stamp 10-testbench/outputs/.stamp.design.args.gls
	$(call symlink,28-gl-sim/inputs,design.args,../../10-testbench/outputs/design.args.gls,.stamp.design.args)
endif

ifeq ("$(wildcard 28-gl-sim/.prebuilt)","")
28-gl-sim/inputs/.stamp.design.sdf: 28-gl-sim/.stamp 27-synopsys-pt-timing-signoff/outputs/.stamp.design.sdf
	$(call symlink,28-gl-sim/inputs,design.sdf,../../27-synopsys-pt-timing-signoff/outputs/design.sdf,.stamp.design.sdf)
endif

ifeq ("$(wildcard 28-gl-sim/.prebuilt)","")
28-gl-sim/inputs/.stamp.design.vcs.v: 28-gl-sim/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v
	$(call symlink,28-gl-sim/inputs,design.vcs.v,../../22-cadence-innovus-signoff/outputs/design.vcs.pg.v,.stamp.design.vcs.v)
endif

ifeq ("$(wildcard 28-gl-sim/.prebuilt)","")
28-gl-sim/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v: 28-gl-sim/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v
	$(call symlink,28-gl-sim/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.v,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.v,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v)
endif

ifeq ("$(wildcard 28-gl-sim/.prebuilt)","")
28-gl-sim/inputs/.stamp.testbench.sv: 28-gl-sim/.stamp 10-testbench/outputs/.stamp.testbench.sv
	$(call symlink,28-gl-sim/inputs,testbench.sv,../../10-testbench/outputs/testbench.sv,.stamp.testbench.sv)
endif

# execute

ifeq ("$(wildcard 28-gl-sim/.prebuilt)","")

define 28_gl_sim_commands_rule
	mkdir -p 28-gl-sim/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t gl-sim && chmod +x .mflowgen/28-gl-sim/mflowgen-run && cp -f .mflowgen/28-gl-sim/mflowgen-run 28-gl-sim && if [[ -e .mflowgen/28-gl-sim/mflowgen-debug ]]; then chmod +x .mflowgen/28-gl-sim/mflowgen-debug && cp -f .mflowgen/28-gl-sim/mflowgen-debug 28-gl-sim; fi && if [[ -e .mflowgen/28-gl-sim/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/28-gl-sim/mflowgen-check-preconditions.py && cp -f .mflowgen/28-gl-sim/mflowgen-check-preconditions.py 28-gl-sim; fi && if [[ -e .mflowgen/28-gl-sim/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/28-gl-sim/mflowgen-check-postconditions.py && cp -f .mflowgen/28-gl-sim/mflowgen-check-postconditions.py 28-gl-sim; fi && cd 28-gl-sim && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 28-gl-sim/outputs/*
endef

28-gl-sim/.execstamp: 28-gl-sim/.stamp 28-gl-sim/inputs/.stamp.adk 28-gl-sim/inputs/.stamp.design.args 28-gl-sim/inputs/.stamp.design.sdf 28-gl-sim/inputs/.stamp.design.vcs.v 28-gl-sim/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 28-gl-sim/inputs/.stamp.testbench.sv
	$(call 28_gl_sim_commands_rule)
	touch $@

28-gl-sim/outputs/.execstamp.run.fsdb: 28-gl-sim/.execstamp
	touch $@

endif

# collect outputs

28-gl-sim/outputs/.stamp.run.fsdb: 28-gl-sim/.execstamp 28-gl-sim/outputs/.execstamp.run.fsdb
	$(call stamp,28-gl-sim/outputs/.stamp.run.fsdb)

# post-conditions

define 28_gl_sim_post_conditions_commands_rule
	cd 28-gl-sim && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

28-gl-sim/.postconditions.stamp: 28-gl-sim/.execstamp 28-gl-sim/outputs/.execstamp.run.fsdb 28-gl-sim/outputs/.stamp.run.fsdb
	$(call 28_gl_sim_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: gl-sim

gl-sim: 28-gl-sim/.execstamp 28-gl-sim/.postconditions.stamp 28-gl-sim/outputs/.execstamp.run.fsdb 28-gl-sim/outputs/.stamp.run.fsdb

.PHONY: 28

28: 28-gl-sim/.execstamp 28-gl-sim/.postconditions.stamp 28-gl-sim/outputs/.execstamp.run.fsdb 28-gl-sim/outputs/.stamp.run.fsdb

# debug

# ------------------------------------------------------------------------
# netgen-lvs-def
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 29-netgen-lvs-def/.prebuilt)","")
29-netgen-lvs-def/.stamp: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/.postconditions.stamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v
29-netgen-lvs-def/.stamp: 24-open-magic-def2spice/.execstamp 24-open-magic-def2spice/.postconditions.stamp 24-open-magic-def2spice/outputs/.execstamp.design_extracted.spice 24-open-magic-def2spice/outputs/.stamp.design_extracted.spice
29-netgen-lvs-def/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
29-netgen-lvs-def/.stamp:
	$(call cpdir-and-parameterize,29-netgen-lvs-def,../design/netgen-lvs-def,29-netgen-lvs-def/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 29-netgen-lvs-def/.prebuilt)","")
29-netgen-lvs-def/inputs/.stamp.adk: 29-netgen-lvs-def/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,29-netgen-lvs-def/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 29-netgen-lvs-def/.prebuilt)","")
29-netgen-lvs-def/inputs/.stamp.design.lvs.v: 29-netgen-lvs-def/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v
	$(call symlink,29-netgen-lvs-def/inputs,design.lvs.v,../../22-cadence-innovus-signoff/outputs/design.lvs.v,.stamp.design.lvs.v)
endif

ifeq ("$(wildcard 29-netgen-lvs-def/.prebuilt)","")
29-netgen-lvs-def/inputs/.stamp.design_extracted.spice: 29-netgen-lvs-def/.stamp 24-open-magic-def2spice/outputs/.stamp.design_extracted.spice
	$(call symlink,29-netgen-lvs-def/inputs,design_extracted.spice,../../24-open-magic-def2spice/outputs/design_extracted.spice,.stamp.design_extracted.spice)
endif

# execute

ifeq ("$(wildcard 29-netgen-lvs-def/.prebuilt)","")

define 29_netgen_lvs_def_commands_rule
	mkdir -p 29-netgen-lvs-def/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t netgen-lvs-def && chmod +x .mflowgen/29-netgen-lvs-def/mflowgen-run && cp -f .mflowgen/29-netgen-lvs-def/mflowgen-run 29-netgen-lvs-def && if [[ -e .mflowgen/29-netgen-lvs-def/mflowgen-debug ]]; then chmod +x .mflowgen/29-netgen-lvs-def/mflowgen-debug && cp -f .mflowgen/29-netgen-lvs-def/mflowgen-debug 29-netgen-lvs-def; fi && if [[ -e .mflowgen/29-netgen-lvs-def/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/29-netgen-lvs-def/mflowgen-check-preconditions.py && cp -f .mflowgen/29-netgen-lvs-def/mflowgen-check-preconditions.py 29-netgen-lvs-def; fi && if [[ -e .mflowgen/29-netgen-lvs-def/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/29-netgen-lvs-def/mflowgen-check-postconditions.py && cp -f .mflowgen/29-netgen-lvs-def/mflowgen-check-postconditions.py 29-netgen-lvs-def; fi && cd 29-netgen-lvs-def && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 29-netgen-lvs-def/outputs/*
endef

29-netgen-lvs-def/.execstamp: 29-netgen-lvs-def/.stamp 29-netgen-lvs-def/inputs/.stamp.adk 29-netgen-lvs-def/inputs/.stamp.design.lvs.v 29-netgen-lvs-def/inputs/.stamp.design_extracted.spice
	$(call 29_netgen_lvs_def_commands_rule)
	touch $@

29-netgen-lvs-def/outputs/.execstamp.lvs_results.log: 29-netgen-lvs-def/.execstamp
	touch $@

endif

# collect outputs

29-netgen-lvs-def/outputs/.stamp.lvs_results.log: 29-netgen-lvs-def/.execstamp 29-netgen-lvs-def/outputs/.execstamp.lvs_results.log
	$(call stamp,29-netgen-lvs-def/outputs/.stamp.lvs_results.log)

# post-conditions

define 29_netgen_lvs_def_post_conditions_commands_rule
	cd 29-netgen-lvs-def && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

29-netgen-lvs-def/.postconditions.stamp: 29-netgen-lvs-def/.execstamp 29-netgen-lvs-def/outputs/.execstamp.lvs_results.log 29-netgen-lvs-def/outputs/.stamp.lvs_results.log
	$(call 29_netgen_lvs_def_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: netgen-lvs-def

netgen-lvs-def: 29-netgen-lvs-def/.execstamp 29-netgen-lvs-def/.postconditions.stamp 29-netgen-lvs-def/outputs/.execstamp.lvs_results.log 29-netgen-lvs-def/outputs/.stamp.lvs_results.log

.PHONY: 29

29: 29-netgen-lvs-def/.execstamp 29-netgen-lvs-def/.postconditions.stamp 29-netgen-lvs-def/outputs/.execstamp.lvs_results.log 29-netgen-lvs-def/outputs/.stamp.lvs_results.log

# debug

# ------------------------------------------------------------------------
# open-magic-antenna
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 30-open-magic-antenna/.prebuilt)","")
30-open-magic-antenna/.stamp: 23-mentor-calibre-gdsmerge/.execstamp 23-mentor-calibre-gdsmerge/.postconditions.stamp 23-mentor-calibre-gdsmerge/outputs/.execstamp.design_merged.gds 23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds
30-open-magic-antenna/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
30-open-magic-antenna/.stamp:
	$(call cpdir-and-parameterize,30-open-magic-antenna,../design/open-magic-antenna,30-open-magic-antenna/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 30-open-magic-antenna/.prebuilt)","")
30-open-magic-antenna/inputs/.stamp.adk: 30-open-magic-antenna/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,30-open-magic-antenna/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 30-open-magic-antenna/.prebuilt)","")
30-open-magic-antenna/inputs/.stamp.design_merged.gds: 30-open-magic-antenna/.stamp 23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds
	$(call symlink,30-open-magic-antenna/inputs,design_merged.gds,../../23-mentor-calibre-gdsmerge/outputs/design_merged.gds,.stamp.design_merged.gds)
endif

# execute

ifeq ("$(wildcard 30-open-magic-antenna/.prebuilt)","")

define 30_open_magic_antenna_commands_rule
	mkdir -p 30-open-magic-antenna/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t open-magic-antenna && chmod +x .mflowgen/30-open-magic-antenna/mflowgen-run && cp -f .mflowgen/30-open-magic-antenna/mflowgen-run 30-open-magic-antenna && if [[ -e .mflowgen/30-open-magic-antenna/mflowgen-debug ]]; then chmod +x .mflowgen/30-open-magic-antenna/mflowgen-debug && cp -f .mflowgen/30-open-magic-antenna/mflowgen-debug 30-open-magic-antenna; fi && if [[ -e .mflowgen/30-open-magic-antenna/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/30-open-magic-antenna/mflowgen-check-preconditions.py && cp -f .mflowgen/30-open-magic-antenna/mflowgen-check-preconditions.py 30-open-magic-antenna; fi && if [[ -e .mflowgen/30-open-magic-antenna/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/30-open-magic-antenna/mflowgen-check-postconditions.py && cp -f .mflowgen/30-open-magic-antenna/mflowgen-check-postconditions.py 30-open-magic-antenna; fi && cd 30-open-magic-antenna && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 30-open-magic-antenna/outputs/*
endef

30-open-magic-antenna/.execstamp: 30-open-magic-antenna/.stamp 30-open-magic-antenna/inputs/.stamp.adk 30-open-magic-antenna/inputs/.stamp.design_merged.gds
	$(call 30_open_magic_antenna_commands_rule)
	touch $@

30-open-magic-antenna/outputs/.execstamp.antenna_check.log: 30-open-magic-antenna/.execstamp
	touch $@

endif

# collect outputs

30-open-magic-antenna/outputs/.stamp.antenna_check.log: 30-open-magic-antenna/.execstamp 30-open-magic-antenna/outputs/.execstamp.antenna_check.log
	$(call stamp,30-open-magic-antenna/outputs/.stamp.antenna_check.log)

# post-conditions

define 30_open_magic_antenna_post_conditions_commands_rule
	cd 30-open-magic-antenna && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

30-open-magic-antenna/.postconditions.stamp: 30-open-magic-antenna/.execstamp 30-open-magic-antenna/outputs/.execstamp.antenna_check.log 30-open-magic-antenna/outputs/.stamp.antenna_check.log
	$(call 30_open_magic_antenna_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: open-magic-antenna

open-magic-antenna: 30-open-magic-antenna/.execstamp 30-open-magic-antenna/.postconditions.stamp 30-open-magic-antenna/outputs/.execstamp.antenna_check.log 30-open-magic-antenna/outputs/.stamp.antenna_check.log

.PHONY: 30

30: 30-open-magic-antenna/.execstamp 30-open-magic-antenna/.postconditions.stamp 30-open-magic-antenna/outputs/.execstamp.antenna_check.log 30-open-magic-antenna/outputs/.stamp.antenna_check.log

# debug

# ------------------------------------------------------------------------
# open-magic-drc
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 31-open-magic-drc/.prebuilt)","")
31-open-magic-drc/.stamp: 23-mentor-calibre-gdsmerge/.execstamp 23-mentor-calibre-gdsmerge/.postconditions.stamp 23-mentor-calibre-gdsmerge/outputs/.execstamp.design_merged.gds 23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds
31-open-magic-drc/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
31-open-magic-drc/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
31-open-magic-drc/.stamp:
	$(call cpdir-and-parameterize,31-open-magic-drc,../design/open-magic-drc,31-open-magic-drc/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 31-open-magic-drc/.prebuilt)","")
31-open-magic-drc/inputs/.stamp.adk: 31-open-magic-drc/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,31-open-magic-drc/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 31-open-magic-drc/.prebuilt)","")
31-open-magic-drc/inputs/.stamp.design_merged.gds: 31-open-magic-drc/.stamp 23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds
	$(call symlink,31-open-magic-drc/inputs,design_merged.gds,../../23-mentor-calibre-gdsmerge/outputs/design_merged.gds,.stamp.design_merged.gds)
endif

ifeq ("$(wildcard 31-open-magic-drc/.prebuilt)","")
31-open-magic-drc/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef: 31-open-magic-drc/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call symlink,31-open-magic-drc/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.lef,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.lef,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef)
endif

# execute

ifeq ("$(wildcard 31-open-magic-drc/.prebuilt)","")

define 31_open_magic_drc_commands_rule
	mkdir -p 31-open-magic-drc/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t open-magic-drc && chmod +x .mflowgen/31-open-magic-drc/mflowgen-run && cp -f .mflowgen/31-open-magic-drc/mflowgen-run 31-open-magic-drc && if [[ -e .mflowgen/31-open-magic-drc/mflowgen-debug ]]; then chmod +x .mflowgen/31-open-magic-drc/mflowgen-debug && cp -f .mflowgen/31-open-magic-drc/mflowgen-debug 31-open-magic-drc; fi && if [[ -e .mflowgen/31-open-magic-drc/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/31-open-magic-drc/mflowgen-check-preconditions.py && cp -f .mflowgen/31-open-magic-drc/mflowgen-check-preconditions.py 31-open-magic-drc; fi && if [[ -e .mflowgen/31-open-magic-drc/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/31-open-magic-drc/mflowgen-check-postconditions.py && cp -f .mflowgen/31-open-magic-drc/mflowgen-check-postconditions.py 31-open-magic-drc; fi && cd 31-open-magic-drc && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 31-open-magic-drc/outputs/*
endef

31-open-magic-drc/.execstamp: 31-open-magic-drc/.stamp 31-open-magic-drc/inputs/.stamp.adk 31-open-magic-drc/inputs/.stamp.design_merged.gds 31-open-magic-drc/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef
	$(call 31_open_magic_drc_commands_rule)
	touch $@

31-open-magic-drc/outputs/.execstamp.drc_results.log: 31-open-magic-drc/.execstamp
	touch $@

endif

# collect outputs

31-open-magic-drc/outputs/.stamp.drc_results.log: 31-open-magic-drc/.execstamp 31-open-magic-drc/outputs/.execstamp.drc_results.log
	$(call stamp,31-open-magic-drc/outputs/.stamp.drc_results.log)

# post-conditions

define 31_open_magic_drc_post_conditions_commands_rule
	cd 31-open-magic-drc && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

31-open-magic-drc/.postconditions.stamp: 31-open-magic-drc/.execstamp 31-open-magic-drc/outputs/.execstamp.drc_results.log 31-open-magic-drc/outputs/.stamp.drc_results.log
	$(call 31_open_magic_drc_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: open-magic-drc

open-magic-drc: 31-open-magic-drc/.execstamp 31-open-magic-drc/.postconditions.stamp 31-open-magic-drc/outputs/.execstamp.drc_results.log 31-open-magic-drc/outputs/.stamp.drc_results.log

.PHONY: 31

31: 31-open-magic-drc/.execstamp 31-open-magic-drc/.postconditions.stamp 31-open-magic-drc/outputs/.execstamp.drc_results.log 31-open-magic-drc/outputs/.stamp.drc_results.log

# debug

# ------------------------------------------------------------------------
# open-magic-gds2spice
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 32-open-magic-gds2spice/.prebuilt)","")
32-open-magic-gds2spice/.stamp: 23-mentor-calibre-gdsmerge/.execstamp 23-mentor-calibre-gdsmerge/.postconditions.stamp 23-mentor-calibre-gdsmerge/outputs/.execstamp.design_merged.gds 23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds
32-open-magic-gds2spice/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
32-open-magic-gds2spice/.stamp:
	$(call cpdir-and-parameterize,32-open-magic-gds2spice,../design/open-magic-gds2spice,32-open-magic-gds2spice/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 32-open-magic-gds2spice/.prebuilt)","")
32-open-magic-gds2spice/inputs/.stamp.adk: 32-open-magic-gds2spice/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,32-open-magic-gds2spice/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 32-open-magic-gds2spice/.prebuilt)","")
32-open-magic-gds2spice/inputs/.stamp.design_merged.gds: 32-open-magic-gds2spice/.stamp 23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds
	$(call symlink,32-open-magic-gds2spice/inputs,design_merged.gds,../../23-mentor-calibre-gdsmerge/outputs/design_merged.gds,.stamp.design_merged.gds)
endif

# execute

ifeq ("$(wildcard 32-open-magic-gds2spice/.prebuilt)","")

define 32_open_magic_gds2spice_commands_rule
	mkdir -p 32-open-magic-gds2spice/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t open-magic-gds2spice && chmod +x .mflowgen/32-open-magic-gds2spice/mflowgen-run && cp -f .mflowgen/32-open-magic-gds2spice/mflowgen-run 32-open-magic-gds2spice && if [[ -e .mflowgen/32-open-magic-gds2spice/mflowgen-debug ]]; then chmod +x .mflowgen/32-open-magic-gds2spice/mflowgen-debug && cp -f .mflowgen/32-open-magic-gds2spice/mflowgen-debug 32-open-magic-gds2spice; fi && if [[ -e .mflowgen/32-open-magic-gds2spice/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/32-open-magic-gds2spice/mflowgen-check-preconditions.py && cp -f .mflowgen/32-open-magic-gds2spice/mflowgen-check-preconditions.py 32-open-magic-gds2spice; fi && if [[ -e .mflowgen/32-open-magic-gds2spice/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/32-open-magic-gds2spice/mflowgen-check-postconditions.py && cp -f .mflowgen/32-open-magic-gds2spice/mflowgen-check-postconditions.py 32-open-magic-gds2spice; fi && cd 32-open-magic-gds2spice && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 32-open-magic-gds2spice/outputs/*
endef

32-open-magic-gds2spice/.execstamp: 32-open-magic-gds2spice/.stamp 32-open-magic-gds2spice/inputs/.stamp.adk 32-open-magic-gds2spice/inputs/.stamp.design_merged.gds
	$(call 32_open_magic_gds2spice_commands_rule)
	touch $@

32-open-magic-gds2spice/outputs/.execstamp.design_extracted.spice: 32-open-magic-gds2spice/.execstamp
	touch $@

endif

# collect outputs

32-open-magic-gds2spice/outputs/.stamp.design_extracted.spice: 32-open-magic-gds2spice/.execstamp 32-open-magic-gds2spice/outputs/.execstamp.design_extracted.spice
	$(call stamp,32-open-magic-gds2spice/outputs/.stamp.design_extracted.spice)

# post-conditions

define 32_open_magic_gds2spice_post_conditions_commands_rule
	cd 32-open-magic-gds2spice && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

32-open-magic-gds2spice/.postconditions.stamp: 32-open-magic-gds2spice/.execstamp 32-open-magic-gds2spice/outputs/.execstamp.design_extracted.spice 32-open-magic-gds2spice/outputs/.stamp.design_extracted.spice
	$(call 32_open_magic_gds2spice_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: open-magic-gds2spice

open-magic-gds2spice: 32-open-magic-gds2spice/.execstamp 32-open-magic-gds2spice/.postconditions.stamp 32-open-magic-gds2spice/outputs/.execstamp.design_extracted.spice 32-open-magic-gds2spice/outputs/.stamp.design_extracted.spice

.PHONY: 32

32: 32-open-magic-gds2spice/.execstamp 32-open-magic-gds2spice/.postconditions.stamp 32-open-magic-gds2spice/outputs/.execstamp.design_extracted.spice 32-open-magic-gds2spice/outputs/.stamp.design_extracted.spice

# debug

# ------------------------------------------------------------------------
# open-magic-gds2spice-nobbox
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 33-open-magic-gds2spice-nobbox/.prebuilt)","")
33-open-magic-gds2spice-nobbox/.stamp: 23-mentor-calibre-gdsmerge/.execstamp 23-mentor-calibre-gdsmerge/.postconditions.stamp 23-mentor-calibre-gdsmerge/outputs/.execstamp.design_merged.gds 23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds
33-open-magic-gds2spice-nobbox/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
33-open-magic-gds2spice-nobbox/.stamp:
	$(call cpdir-and-parameterize,33-open-magic-gds2spice-nobbox,../design/open-magic-gds2spice-nobbox,33-open-magic-gds2spice-nobbox/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 33-open-magic-gds2spice-nobbox/.prebuilt)","")
33-open-magic-gds2spice-nobbox/inputs/.stamp.adk: 33-open-magic-gds2spice-nobbox/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,33-open-magic-gds2spice-nobbox/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 33-open-magic-gds2spice-nobbox/.prebuilt)","")
33-open-magic-gds2spice-nobbox/inputs/.stamp.design_merged.gds: 33-open-magic-gds2spice-nobbox/.stamp 23-mentor-calibre-gdsmerge/outputs/.stamp.design_merged.gds
	$(call symlink,33-open-magic-gds2spice-nobbox/inputs,design_merged.gds,../../23-mentor-calibre-gdsmerge/outputs/design_merged.gds,.stamp.design_merged.gds)
endif

# execute

ifeq ("$(wildcard 33-open-magic-gds2spice-nobbox/.prebuilt)","")

define 33_open_magic_gds2spice_nobbox_commands_rule
	mkdir -p 33-open-magic-gds2spice-nobbox/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t open-magic-gds2spice-nobbox && chmod +x .mflowgen/33-open-magic-gds2spice-nobbox/mflowgen-run && cp -f .mflowgen/33-open-magic-gds2spice-nobbox/mflowgen-run 33-open-magic-gds2spice-nobbox && if [[ -e .mflowgen/33-open-magic-gds2spice-nobbox/mflowgen-debug ]]; then chmod +x .mflowgen/33-open-magic-gds2spice-nobbox/mflowgen-debug && cp -f .mflowgen/33-open-magic-gds2spice-nobbox/mflowgen-debug 33-open-magic-gds2spice-nobbox; fi && if [[ -e .mflowgen/33-open-magic-gds2spice-nobbox/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/33-open-magic-gds2spice-nobbox/mflowgen-check-preconditions.py && cp -f .mflowgen/33-open-magic-gds2spice-nobbox/mflowgen-check-preconditions.py 33-open-magic-gds2spice-nobbox; fi && if [[ -e .mflowgen/33-open-magic-gds2spice-nobbox/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/33-open-magic-gds2spice-nobbox/mflowgen-check-postconditions.py && cp -f .mflowgen/33-open-magic-gds2spice-nobbox/mflowgen-check-postconditions.py 33-open-magic-gds2spice-nobbox; fi && cd 33-open-magic-gds2spice-nobbox && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 33-open-magic-gds2spice-nobbox/outputs/*
endef

33-open-magic-gds2spice-nobbox/.execstamp: 33-open-magic-gds2spice-nobbox/.stamp 33-open-magic-gds2spice-nobbox/inputs/.stamp.adk 33-open-magic-gds2spice-nobbox/inputs/.stamp.design_merged.gds
	$(call 33_open_magic_gds2spice_nobbox_commands_rule)
	touch $@

33-open-magic-gds2spice-nobbox/outputs/.execstamp.design_extracted.spice: 33-open-magic-gds2spice-nobbox/.execstamp
	touch $@

endif

# collect outputs

33-open-magic-gds2spice-nobbox/outputs/.stamp.design_extracted.spice: 33-open-magic-gds2spice-nobbox/.execstamp 33-open-magic-gds2spice-nobbox/outputs/.execstamp.design_extracted.spice
	$(call stamp,33-open-magic-gds2spice-nobbox/outputs/.stamp.design_extracted.spice)

# post-conditions

define 33_open_magic_gds2spice_nobbox_post_conditions_commands_rule
	cd 33-open-magic-gds2spice-nobbox && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

33-open-magic-gds2spice-nobbox/.postconditions.stamp: 33-open-magic-gds2spice-nobbox/.execstamp 33-open-magic-gds2spice-nobbox/outputs/.execstamp.design_extracted.spice 33-open-magic-gds2spice-nobbox/outputs/.stamp.design_extracted.spice
	$(call 33_open_magic_gds2spice_nobbox_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: open-magic-gds2spice-nobbox

open-magic-gds2spice-nobbox: 33-open-magic-gds2spice-nobbox/.execstamp 33-open-magic-gds2spice-nobbox/.postconditions.stamp 33-open-magic-gds2spice-nobbox/outputs/.execstamp.design_extracted.spice 33-open-magic-gds2spice-nobbox/outputs/.stamp.design_extracted.spice

.PHONY: 33

33: 33-open-magic-gds2spice-nobbox/.execstamp 33-open-magic-gds2spice-nobbox/.postconditions.stamp 33-open-magic-gds2spice-nobbox/outputs/.execstamp.design_extracted.spice 33-open-magic-gds2spice-nobbox/outputs/.stamp.design_extracted.spice

# debug

# ------------------------------------------------------------------------
# mentor-calibre-comparison
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 34-mentor-calibre-comparison/.prebuilt)","")
34-mentor-calibre-comparison/.stamp: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/.postconditions.stamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v
34-mentor-calibre-comparison/.stamp: 32-open-magic-gds2spice/.execstamp 32-open-magic-gds2spice/.postconditions.stamp 32-open-magic-gds2spice/outputs/.execstamp.design_extracted.spice 32-open-magic-gds2spice/outputs/.stamp.design_extracted.spice
34-mentor-calibre-comparison/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
34-mentor-calibre-comparison/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
34-mentor-calibre-comparison/.stamp:
	$(call cpdir-and-parameterize,34-mentor-calibre-comparison,../design/mentor-calibre-comparison,34-mentor-calibre-comparison/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 34-mentor-calibre-comparison/.prebuilt)","")
34-mentor-calibre-comparison/inputs/.stamp.adk: 34-mentor-calibre-comparison/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,34-mentor-calibre-comparison/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 34-mentor-calibre-comparison/.prebuilt)","")
34-mentor-calibre-comparison/inputs/.stamp.design.lvs.v: 34-mentor-calibre-comparison/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v
	$(call symlink,34-mentor-calibre-comparison/inputs,design.lvs.v,../../22-cadence-innovus-signoff/outputs/design.lvs.v,.stamp.design.lvs.v)
endif

ifeq ("$(wildcard 34-mentor-calibre-comparison/.prebuilt)","")
34-mentor-calibre-comparison/inputs/.stamp.design_extracted.spice: 34-mentor-calibre-comparison/.stamp 32-open-magic-gds2spice/outputs/.stamp.design_extracted.spice
	$(call symlink,34-mentor-calibre-comparison/inputs,design_extracted.spice,../../32-open-magic-gds2spice/outputs/design_extracted.spice,.stamp.design_extracted.spice)
endif

ifeq ("$(wildcard 34-mentor-calibre-comparison/.prebuilt)","")
34-mentor-calibre-comparison/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp: 34-mentor-calibre-comparison/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp
	$(call symlink,34-mentor-calibre-comparison/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.sp,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.sp,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp)
endif

# execute

ifeq ("$(wildcard 34-mentor-calibre-comparison/.prebuilt)","")

define 34_mentor_calibre_comparison_commands_rule
	mkdir -p 34-mentor-calibre-comparison/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t mentor-calibre-comparison && chmod +x .mflowgen/34-mentor-calibre-comparison/mflowgen-run && cp -f .mflowgen/34-mentor-calibre-comparison/mflowgen-run 34-mentor-calibre-comparison && if [[ -e .mflowgen/34-mentor-calibre-comparison/mflowgen-debug ]]; then chmod +x .mflowgen/34-mentor-calibre-comparison/mflowgen-debug && cp -f .mflowgen/34-mentor-calibre-comparison/mflowgen-debug 34-mentor-calibre-comparison; fi && if [[ -e .mflowgen/34-mentor-calibre-comparison/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/34-mentor-calibre-comparison/mflowgen-check-preconditions.py && cp -f .mflowgen/34-mentor-calibre-comparison/mflowgen-check-preconditions.py 34-mentor-calibre-comparison; fi && if [[ -e .mflowgen/34-mentor-calibre-comparison/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/34-mentor-calibre-comparison/mflowgen-check-postconditions.py && cp -f .mflowgen/34-mentor-calibre-comparison/mflowgen-check-postconditions.py 34-mentor-calibre-comparison; fi && cd 34-mentor-calibre-comparison && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 34-mentor-calibre-comparison/outputs/*
endef

34-mentor-calibre-comparison/.execstamp: 34-mentor-calibre-comparison/.stamp 34-mentor-calibre-comparison/inputs/.stamp.adk 34-mentor-calibre-comparison/inputs/.stamp.design.lvs.v 34-mentor-calibre-comparison/inputs/.stamp.design_extracted.spice 34-mentor-calibre-comparison/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp
	$(call 34_mentor_calibre_comparison_commands_rule)
	touch $@

34-mentor-calibre-comparison/outputs/.execstamp.lvs.report: 34-mentor-calibre-comparison/.execstamp
	touch $@

endif

# collect outputs

34-mentor-calibre-comparison/outputs/.stamp.lvs.report: 34-mentor-calibre-comparison/.execstamp 34-mentor-calibre-comparison/outputs/.execstamp.lvs.report
	$(call stamp,34-mentor-calibre-comparison/outputs/.stamp.lvs.report)

# post-conditions

define 34_mentor_calibre_comparison_post_conditions_commands_rule
	cd 34-mentor-calibre-comparison && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

34-mentor-calibre-comparison/.postconditions.stamp: 34-mentor-calibre-comparison/.execstamp 34-mentor-calibre-comparison/outputs/.execstamp.lvs.report 34-mentor-calibre-comparison/outputs/.stamp.lvs.report
	$(call 34_mentor_calibre_comparison_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: mentor-calibre-comparison

mentor-calibre-comparison: 34-mentor-calibre-comparison/.execstamp 34-mentor-calibre-comparison/.postconditions.stamp 34-mentor-calibre-comparison/outputs/.execstamp.lvs.report 34-mentor-calibre-comparison/outputs/.stamp.lvs.report

.PHONY: 34

34: 34-mentor-calibre-comparison/.execstamp 34-mentor-calibre-comparison/.postconditions.stamp 34-mentor-calibre-comparison/outputs/.execstamp.lvs.report 34-mentor-calibre-comparison/outputs/.stamp.lvs.report

# debug

define 34_debug_rule
	cd 34-mentor-calibre-comparison && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-mentor-calibre-comparison: 
	$(call 34_debug_rule)

.PHONY: debug-34

debug-34: debug-mentor-calibre-comparison

# ------------------------------------------------------------------------
# mentor-calibre-comparison-nobbox
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 35-mentor-calibre-comparison-nobbox/.prebuilt)","")
35-mentor-calibre-comparison-nobbox/.stamp: 33-open-magic-gds2spice-nobbox/.execstamp 33-open-magic-gds2spice-nobbox/.postconditions.stamp 33-open-magic-gds2spice-nobbox/outputs/.execstamp.design_extracted.spice 33-open-magic-gds2spice-nobbox/outputs/.stamp.design_extracted.spice
35-mentor-calibre-comparison-nobbox/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
35-mentor-calibre-comparison-nobbox/.stamp: 8-sram/.execstamp 8-sram/.postconditions.stamp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.execstamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.gds 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lef 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.lvs.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.v 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.db 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib
35-mentor-calibre-comparison-nobbox/.stamp:
	$(call cpdir-and-parameterize,35-mentor-calibre-comparison-nobbox,../design/mentor-calibre-comparison-nobbox,35-mentor-calibre-comparison-nobbox/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 35-mentor-calibre-comparison-nobbox/.prebuilt)","")
35-mentor-calibre-comparison-nobbox/inputs/.stamp.adk: 35-mentor-calibre-comparison-nobbox/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,35-mentor-calibre-comparison-nobbox/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 35-mentor-calibre-comparison-nobbox/.prebuilt)","")
35-mentor-calibre-comparison-nobbox/inputs/.stamp.design_extracted.spice: 35-mentor-calibre-comparison-nobbox/.stamp 33-open-magic-gds2spice-nobbox/outputs/.stamp.design_extracted.spice
	$(call symlink,35-mentor-calibre-comparison-nobbox/inputs,design_extracted.spice,../../33-open-magic-gds2spice-nobbox/outputs/design_extracted.spice,.stamp.design_extracted.spice)
endif

ifeq ("$(wildcard 35-mentor-calibre-comparison-nobbox/.prebuilt)","")
35-mentor-calibre-comparison-nobbox/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp: 35-mentor-calibre-comparison-nobbox/.stamp 8-sram/outputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp
	$(call symlink,35-mentor-calibre-comparison-nobbox/inputs,sky130_sram_1kbyte_1rw1r_32x256_8.sp,../../8-sram/outputs/sky130_sram_1kbyte_1rw1r_32x256_8.sp,.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp)
endif

# execute

ifeq ("$(wildcard 35-mentor-calibre-comparison-nobbox/.prebuilt)","")

define 35_mentor_calibre_comparison_nobbox_commands_rule
	mkdir -p 35-mentor-calibre-comparison-nobbox/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t mentor-calibre-comparison-nobbox && chmod +x .mflowgen/35-mentor-calibre-comparison-nobbox/mflowgen-run && cp -f .mflowgen/35-mentor-calibre-comparison-nobbox/mflowgen-run 35-mentor-calibre-comparison-nobbox && if [[ -e .mflowgen/35-mentor-calibre-comparison-nobbox/mflowgen-debug ]]; then chmod +x .mflowgen/35-mentor-calibre-comparison-nobbox/mflowgen-debug && cp -f .mflowgen/35-mentor-calibre-comparison-nobbox/mflowgen-debug 35-mentor-calibre-comparison-nobbox; fi && if [[ -e .mflowgen/35-mentor-calibre-comparison-nobbox/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/35-mentor-calibre-comparison-nobbox/mflowgen-check-preconditions.py && cp -f .mflowgen/35-mentor-calibre-comparison-nobbox/mflowgen-check-preconditions.py 35-mentor-calibre-comparison-nobbox; fi && if [[ -e .mflowgen/35-mentor-calibre-comparison-nobbox/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/35-mentor-calibre-comparison-nobbox/mflowgen-check-postconditions.py && cp -f .mflowgen/35-mentor-calibre-comparison-nobbox/mflowgen-check-postconditions.py 35-mentor-calibre-comparison-nobbox; fi && cd 35-mentor-calibre-comparison-nobbox && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 35-mentor-calibre-comparison-nobbox/outputs/*
endef

35-mentor-calibre-comparison-nobbox/.execstamp: 35-mentor-calibre-comparison-nobbox/.stamp 35-mentor-calibre-comparison-nobbox/inputs/.stamp.adk 35-mentor-calibre-comparison-nobbox/inputs/.stamp.design_extracted.spice 35-mentor-calibre-comparison-nobbox/inputs/.stamp.sky130_sram_1kbyte_1rw1r_32x256_8.sp
	$(call 35_mentor_calibre_comparison_nobbox_commands_rule)
	touch $@

35-mentor-calibre-comparison-nobbox/outputs/.execstamp.lvs.report: 35-mentor-calibre-comparison-nobbox/.execstamp
	touch $@

endif

# collect outputs

35-mentor-calibre-comparison-nobbox/outputs/.stamp.lvs.report: 35-mentor-calibre-comparison-nobbox/.execstamp 35-mentor-calibre-comparison-nobbox/outputs/.execstamp.lvs.report
	$(call stamp,35-mentor-calibre-comparison-nobbox/outputs/.stamp.lvs.report)

# post-conditions

define 35_mentor_calibre_comparison_nobbox_post_conditions_commands_rule
	cd 35-mentor-calibre-comparison-nobbox && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

35-mentor-calibre-comparison-nobbox/.postconditions.stamp: 35-mentor-calibre-comparison-nobbox/.execstamp 35-mentor-calibre-comparison-nobbox/outputs/.execstamp.lvs.report 35-mentor-calibre-comparison-nobbox/outputs/.stamp.lvs.report
	$(call 35_mentor_calibre_comparison_nobbox_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: mentor-calibre-comparison-nobbox

mentor-calibre-comparison-nobbox: 35-mentor-calibre-comparison-nobbox/.execstamp 35-mentor-calibre-comparison-nobbox/.postconditions.stamp 35-mentor-calibre-comparison-nobbox/outputs/.execstamp.lvs.report 35-mentor-calibre-comparison-nobbox/outputs/.stamp.lvs.report

.PHONY: 35

35: 35-mentor-calibre-comparison-nobbox/.execstamp 35-mentor-calibre-comparison-nobbox/.postconditions.stamp 35-mentor-calibre-comparison-nobbox/outputs/.execstamp.lvs.report 35-mentor-calibre-comparison-nobbox/outputs/.stamp.lvs.report

# debug

define 35_debug_rule
	cd 35-mentor-calibre-comparison-nobbox && ./mflowgen-debug 2>&1 | tee mflowgen-debug.log
endef

debug-mentor-calibre-comparison-nobbox: 
	$(call 35_debug_rule)

.PHONY: debug-35

debug-35: debug-mentor-calibre-comparison-nobbox

# ------------------------------------------------------------------------
# netgen-lvs-gds
# ------------------------------------------------------------------------

# build dir

ifeq ("$(wildcard 36-netgen-lvs-gds/.prebuilt)","")
36-netgen-lvs-gds/.stamp: 22-cadence-innovus-signoff/.execstamp 22-cadence-innovus-signoff/.postconditions.stamp 22-cadence-innovus-signoff/outputs/.execstamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.execstamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.execstamp.design.def.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.lef 22-cadence-innovus-signoff/outputs/.execstamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.sdc 22-cadence-innovus-signoff/outputs/.execstamp.design.sdf 22-cadence-innovus-signoff/outputs/.execstamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.execstamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.execstamp.design.virtuoso.v 22-cadence-innovus-signoff/outputs/.stamp.design-merged.gds 22-cadence-innovus-signoff/outputs/.stamp.design.checkpoint 22-cadence-innovus-signoff/outputs/.stamp.design.def.gz 22-cadence-innovus-signoff/outputs/.stamp.design.gds.gz 22-cadence-innovus-signoff/outputs/.stamp.design.lef 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v 22-cadence-innovus-signoff/outputs/.stamp.design.rcbest.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.sdc 22-cadence-innovus-signoff/outputs/.stamp.design.sdf 22-cadence-innovus-signoff/outputs/.stamp.design.spef.gz 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.pg.v 22-cadence-innovus-signoff/outputs/.stamp.design.vcs.v 22-cadence-innovus-signoff/outputs/.stamp.design.virtuoso.v
36-netgen-lvs-gds/.stamp: 33-open-magic-gds2spice-nobbox/.execstamp 33-open-magic-gds2spice-nobbox/.postconditions.stamp 33-open-magic-gds2spice-nobbox/outputs/.execstamp.design_extracted.spice 33-open-magic-gds2spice-nobbox/outputs/.stamp.design_extracted.spice
36-netgen-lvs-gds/.stamp: 7-skywater-130nm/.execstamp 7-skywater-130nm/.postconditions.stamp 7-skywater-130nm/outputs/.execstamp.adk 7-skywater-130nm/outputs/.stamp.adk
36-netgen-lvs-gds/.stamp:
	$(call cpdir-and-parameterize,36-netgen-lvs-gds,../design/netgen-lvs-gds,36-netgen-lvs-gds/.stamp)
endif

# collect inputs

ifeq ("$(wildcard 36-netgen-lvs-gds/.prebuilt)","")
36-netgen-lvs-gds/inputs/.stamp.adk: 36-netgen-lvs-gds/.stamp 7-skywater-130nm/outputs/.stamp.adk
	$(call symlink,36-netgen-lvs-gds/inputs,adk,../../7-skywater-130nm/outputs/adk,.stamp.adk)
endif

ifeq ("$(wildcard 36-netgen-lvs-gds/.prebuilt)","")
36-netgen-lvs-gds/inputs/.stamp.design.lvs.v: 36-netgen-lvs-gds/.stamp 22-cadence-innovus-signoff/outputs/.stamp.design.lvs.v
	$(call symlink,36-netgen-lvs-gds/inputs,design.lvs.v,../../22-cadence-innovus-signoff/outputs/design.lvs.v,.stamp.design.lvs.v)
endif

ifeq ("$(wildcard 36-netgen-lvs-gds/.prebuilt)","")
36-netgen-lvs-gds/inputs/.stamp.design_extracted.spice: 36-netgen-lvs-gds/.stamp 33-open-magic-gds2spice-nobbox/outputs/.stamp.design_extracted.spice
	$(call symlink,36-netgen-lvs-gds/inputs,design_extracted.spice,../../33-open-magic-gds2spice-nobbox/outputs/design_extracted.spice,.stamp.design_extracted.spice)
endif

# execute

ifeq ("$(wildcard 36-netgen-lvs-gds/.prebuilt)","")

define 36_netgen_lvs_gds_commands_rule
	mkdir -p 36-netgen-lvs-gds/outputs && set -o pipefail && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t netgen-lvs-gds && chmod +x .mflowgen/36-netgen-lvs-gds/mflowgen-run && cp -f .mflowgen/36-netgen-lvs-gds/mflowgen-run 36-netgen-lvs-gds && if [[ -e .mflowgen/36-netgen-lvs-gds/mflowgen-debug ]]; then chmod +x .mflowgen/36-netgen-lvs-gds/mflowgen-debug && cp -f .mflowgen/36-netgen-lvs-gds/mflowgen-debug 36-netgen-lvs-gds; fi && if [[ -e .mflowgen/36-netgen-lvs-gds/mflowgen-check-preconditions.py ]]; then chmod +x .mflowgen/36-netgen-lvs-gds/mflowgen-check-preconditions.py && cp -f .mflowgen/36-netgen-lvs-gds/mflowgen-check-preconditions.py 36-netgen-lvs-gds; fi && if [[ -e .mflowgen/36-netgen-lvs-gds/mflowgen-check-postconditions.py ]]; then chmod +x .mflowgen/36-netgen-lvs-gds/mflowgen-check-postconditions.py && cp -f .mflowgen/36-netgen-lvs-gds/mflowgen-check-postconditions.py 36-netgen-lvs-gds; fi && cd 36-netgen-lvs-gds && if [[ -e mflowgen-check-preconditions.py ]]; then ./mflowgen-check-preconditions.py || exit 1; fi && ./mflowgen-run 2>&1 | tee mflowgen-run.log || exit 1 && cd .. && touch -c 36-netgen-lvs-gds/outputs/*
endef

36-netgen-lvs-gds/.execstamp: 36-netgen-lvs-gds/.stamp 36-netgen-lvs-gds/inputs/.stamp.adk 36-netgen-lvs-gds/inputs/.stamp.design.lvs.v 36-netgen-lvs-gds/inputs/.stamp.design_extracted.spice
	$(call 36_netgen_lvs_gds_commands_rule)
	touch $@

36-netgen-lvs-gds/outputs/.execstamp.lvs_results.log: 36-netgen-lvs-gds/.execstamp
	touch $@

endif

# collect outputs

36-netgen-lvs-gds/outputs/.stamp.lvs_results.log: 36-netgen-lvs-gds/.execstamp 36-netgen-lvs-gds/outputs/.execstamp.lvs_results.log
	$(call stamp,36-netgen-lvs-gds/outputs/.stamp.lvs_results.log)

# post-conditions

define 36_netgen_lvs_gds_post_conditions_commands_rule
	cd 36-netgen-lvs-gds && if [[ -e mflowgen-check-postconditions.py ]]; then ./mflowgen-check-postconditions.py || exit 1; fi && cd ..
endef

36-netgen-lvs-gds/.postconditions.stamp: 36-netgen-lvs-gds/.execstamp 36-netgen-lvs-gds/outputs/.execstamp.lvs_results.log 36-netgen-lvs-gds/outputs/.stamp.lvs_results.log
	$(call 36_netgen_lvs_gds_post_conditions_commands_rule)
	touch $@

# alias

.PHONY: netgen-lvs-gds

netgen-lvs-gds: 36-netgen-lvs-gds/.execstamp 36-netgen-lvs-gds/.postconditions.stamp 36-netgen-lvs-gds/outputs/.execstamp.lvs_results.log 36-netgen-lvs-gds/outputs/.stamp.lvs_results.log

.PHONY: 36

36: 36-netgen-lvs-gds/.execstamp 36-netgen-lvs-gds/.postconditions.stamp 36-netgen-lvs-gds/outputs/.execstamp.lvs_results.log 36-netgen-lvs-gds/outputs/.stamp.lvs_results.log

# debug

# ------------------------------------------------------------------------
# Misc
# ------------------------------------------------------------------------

# Clean

.PHONY: clean-all

clean-all:
	@find . -maxdepth 1 ! -name Makefile ! -name .mflowgen\* ! -name \. ! -name \.\. -exec rm -rf {} +

.PHONY: clean-0

clean-0:
	rm -rf ./0-constraints

.PHONY: clean-constraints

clean-constraints: clean-0

.PHONY: clean-1

clean-1:
	rm -rf ./1-custom-flowstep

.PHONY: clean-custom-flowstep

clean-custom-flowstep: clean-1

.PHONY: clean-10

clean-10:
	rm -rf ./10-testbench

.PHONY: clean-testbench

clean-testbench: clean-10

.PHONY: clean-11

clean-11:
	rm -rf ./11-rtl-sim

.PHONY: clean-rtl-sim

clean-rtl-sim: clean-11

.PHONY: clean-12

clean-12:
	rm -rf ./12-gen-saif-rtl

.PHONY: clean-gen-saif-rtl

clean-gen-saif-rtl: clean-12

.PHONY: clean-13

clean-13:
	rm -rf ./13-synopsys-dc-synthesis

.PHONY: clean-synopsys-dc-synthesis

clean-synopsys-dc-synthesis: clean-13

.PHONY: clean-14

clean-14:
	rm -rf ./14-cadence-innovus-flowsetup

.PHONY: clean-cadence-innovus-flowsetup

clean-cadence-innovus-flowsetup: clean-14

.PHONY: clean-15

clean-15:
	rm -rf ./15-cadence-innovus-init

.PHONY: clean-cadence-innovus-init

clean-cadence-innovus-init: clean-15

.PHONY: clean-16

clean-16:
	rm -rf ./16-cadence-innovus-power

.PHONY: clean-cadence-innovus-power

clean-cadence-innovus-power: clean-16

.PHONY: clean-17

clean-17:
	rm -rf ./17-cadence-innovus-place

.PHONY: clean-cadence-innovus-place

clean-cadence-innovus-place: clean-17

.PHONY: clean-18

clean-18:
	rm -rf ./18-cadence-innovus-cts

.PHONY: clean-cadence-innovus-cts

clean-cadence-innovus-cts: clean-18

.PHONY: clean-19

clean-19:
	rm -rf ./19-cadence-innovus-postcts_hold

.PHONY: clean-cadence-innovus-postcts_hold

clean-cadence-innovus-postcts_hold: clean-19

.PHONY: clean-2

clean-2:
	rm -rf ./2-floorplan

.PHONY: clean-floorplan

clean-floorplan: clean-2

.PHONY: clean-20

clean-20:
	rm -rf ./20-cadence-innovus-route

.PHONY: clean-cadence-innovus-route

clean-cadence-innovus-route: clean-20

.PHONY: clean-21

clean-21:
	rm -rf ./21-cadence-innovus-postroute

.PHONY: clean-cadence-innovus-postroute

clean-cadence-innovus-postroute: clean-21

.PHONY: clean-22

clean-22:
	rm -rf ./22-cadence-innovus-signoff

.PHONY: clean-cadence-innovus-signoff

clean-cadence-innovus-signoff: clean-22

.PHONY: clean-23

clean-23:
	rm -rf ./23-mentor-calibre-gdsmerge

.PHONY: clean-mentor-calibre-gdsmerge

clean-mentor-calibre-gdsmerge: clean-23

.PHONY: clean-24

clean-24:
	rm -rf ./24-open-magic-def2spice

.PHONY: clean-open-magic-def2spice

clean-open-magic-def2spice: clean-24

.PHONY: clean-25

clean-25:
	rm -rf ./25-ptpx-gl

.PHONY: clean-ptpx-gl

clean-ptpx-gl: clean-25

.PHONY: clean-26

clean-26:
	rm -rf ./26-ptpx-rtl

.PHONY: clean-ptpx-rtl

clean-ptpx-rtl: clean-26

.PHONY: clean-27

clean-27:
	rm -rf ./27-synopsys-pt-timing-signoff

.PHONY: clean-synopsys-pt-timing-signoff

clean-synopsys-pt-timing-signoff: clean-27

.PHONY: clean-28

clean-28:
	rm -rf ./28-gl-sim

.PHONY: clean-gl-sim

clean-gl-sim: clean-28

.PHONY: clean-29

clean-29:
	rm -rf ./29-netgen-lvs-def

.PHONY: clean-netgen-lvs-def

clean-netgen-lvs-def: clean-29

.PHONY: clean-3

clean-3:
	rm -rf ./3-gen-saif-gl

.PHONY: clean-gen-saif-gl

clean-gen-saif-gl: clean-3

.PHONY: clean-30

clean-30:
	rm -rf ./30-open-magic-antenna

.PHONY: clean-open-magic-antenna

clean-open-magic-antenna: clean-30

.PHONY: clean-31

clean-31:
	rm -rf ./31-open-magic-drc

.PHONY: clean-open-magic-drc

clean-open-magic-drc: clean-31

.PHONY: clean-32

clean-32:
	rm -rf ./32-open-magic-gds2spice

.PHONY: clean-open-magic-gds2spice

clean-open-magic-gds2spice: clean-32

.PHONY: clean-33

clean-33:
	rm -rf ./33-open-magic-gds2spice-nobbox

.PHONY: clean-open-magic-gds2spice-nobbox

clean-open-magic-gds2spice-nobbox: clean-33

.PHONY: clean-34

clean-34:
	rm -rf ./34-mentor-calibre-comparison

.PHONY: clean-mentor-calibre-comparison

clean-mentor-calibre-comparison: clean-34

.PHONY: clean-35

clean-35:
	rm -rf ./35-mentor-calibre-comparison-nobbox

.PHONY: clean-mentor-calibre-comparison-nobbox

clean-mentor-calibre-comparison-nobbox: clean-35

.PHONY: clean-36

clean-36:
	rm -rf ./36-netgen-lvs-gds

.PHONY: clean-netgen-lvs-gds

clean-netgen-lvs-gds: clean-36

.PHONY: clean-4

clean-4:
	rm -rf ./4-info

.PHONY: clean-info

clean-info: clean-4

.PHONY: clean-5

clean-5:
	rm -rf ./5-pin-placement

.PHONY: clean-pin-placement

clean-pin-placement: clean-5

.PHONY: clean-6

clean-6:
	rm -rf ./6-rtl

.PHONY: clean-rtl

clean-rtl: clean-6

.PHONY: clean-7

clean-7:
	rm -rf ./7-skywater-130nm

.PHONY: clean-skywater-130nm

clean-skywater-130nm: clean-7

.PHONY: clean-8

clean-8:
	rm -rf ./8-sram

.PHONY: clean-sram

clean-sram: clean-8

.PHONY: clean-9

clean-9:
	rm -rf ./9-synopsys-dc-compile

.PHONY: clean-synopsys-dc-compile

clean-synopsys-dc-compile: clean-9

# Diff

.PHONY: diff-0

diff-0:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/constraints 0-constraints | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/constraints.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 0-constraints.*' && echo || true

.PHONY: diff-1

diff-1:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/custom-flowstep 1-custom-flowstep | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/custom-flowstep.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 1-custom-flowstep.*' && echo || true

.PHONY: diff-2

diff-2:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/floorplan 2-floorplan | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/floorplan.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 2-floorplan.*' && echo || true

.PHONY: diff-3

diff-3:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/synopsys-vcd2saif-convert 3-gen-saif-gl | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/synopsys-vcd2saif-convert.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 3-gen-saif-gl.*' && echo || true

.PHONY: diff-4

diff-4:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/info 4-info | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/info.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 4-info.*' && echo || true

.PHONY: diff-5

diff-5:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/pin-placement 5-pin-placement | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/pin-placement.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 5-pin-placement.*' && echo || true

.PHONY: diff-6

diff-6:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/rtl 6-rtl | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/rtl.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 6-rtl.*' && echo || true

.PHONY: diff-7

diff-7:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../../../../../farmshare/home/classes/ee/372/PDKs/skywater-130nm-adk 7-skywater-130nm | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../../../../../farmshare/home/classes/ee/372/PDKs/skywater-130nm-adk.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 7-skywater-130nm.*' && echo || true

.PHONY: diff-8

diff-8:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/sram 8-sram | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/sram.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 8-sram.*' && echo || true

.PHONY: diff-9

diff-9:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/synopsys-dc-compile 9-synopsys-dc-compile | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/synopsys-dc-compile.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 9-synopsys-dc-compile.*' && echo || true

.PHONY: diff-10

diff-10:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/testbench 10-testbench | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/testbench.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 10-testbench.*' && echo || true

.PHONY: diff-11

diff-11:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/synopsys-vcs-sim 11-rtl-sim | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/synopsys-vcs-sim.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 11-rtl-sim.*' && echo || true

.PHONY: diff-12

diff-12:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/synopsys-vcd2saif-convert 12-gen-saif-rtl | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/synopsys-vcd2saif-convert.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 12-gen-saif-rtl.*' && echo || true

.PHONY: diff-13

diff-13:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/synopsys-dc-synthesis 13-synopsys-dc-synthesis | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/synopsys-dc-synthesis.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 13-synopsys-dc-synthesis.*' && echo || true

.PHONY: diff-14

diff-14:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/cadence-innovus-flowsetup 14-cadence-innovus-flowsetup | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/cadence-innovus-flowsetup.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 14-cadence-innovus-flowsetup.*' && echo || true

.PHONY: diff-15

diff-15:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/cadence-innovus-init 15-cadence-innovus-init | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/cadence-innovus-init.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 15-cadence-innovus-init.*' && echo || true

.PHONY: diff-16

diff-16:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/cadence-innovus-power 16-cadence-innovus-power | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/cadence-innovus-power.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 16-cadence-innovus-power.*' && echo || true

.PHONY: diff-17

diff-17:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/cadence-innovus-place 17-cadence-innovus-place | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/cadence-innovus-place.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 17-cadence-innovus-place.*' && echo || true

.PHONY: diff-18

diff-18:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/cadence-innovus-cts 18-cadence-innovus-cts | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/cadence-innovus-cts.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 18-cadence-innovus-cts.*' && echo || true

.PHONY: diff-19

diff-19:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/cadence-innovus-postcts_hold 19-cadence-innovus-postcts_hold | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/cadence-innovus-postcts_hold.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 19-cadence-innovus-postcts_hold.*' && echo || true

.PHONY: diff-20

diff-20:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/cadence-innovus-route 20-cadence-innovus-route | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/cadence-innovus-route.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 20-cadence-innovus-route.*' && echo || true

.PHONY: diff-21

diff-21:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/cadence-innovus-postroute 21-cadence-innovus-postroute | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/cadence-innovus-postroute.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 21-cadence-innovus-postroute.*' && echo || true

.PHONY: diff-22

diff-22:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/cadence-innovus-signoff 22-cadence-innovus-signoff | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/cadence-innovus-signoff.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 22-cadence-innovus-signoff.*' && echo || true

.PHONY: diff-23

diff-23:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../../../mflowgen/steps/mentor-calibre-gdsmerge 23-mentor-calibre-gdsmerge | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../mflowgen/steps/mentor-calibre-gdsmerge.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 23-mentor-calibre-gdsmerge.*' && echo || true

.PHONY: diff-24

diff-24:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/open-magic-def2spice 24-open-magic-def2spice | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/open-magic-def2spice.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 24-open-magic-def2spice.*' && echo || true

.PHONY: diff-25

diff-25:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/synopsys-pt-power 25-ptpx-gl | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/synopsys-pt-power.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 25-ptpx-gl.*' && echo || true

.PHONY: diff-26

diff-26:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/synopsys-pt-power 26-ptpx-rtl | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/synopsys-pt-power.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 26-ptpx-rtl.*' && echo || true

.PHONY: diff-27

diff-27:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/synopsys-pt-timing-signoff 27-synopsys-pt-timing-signoff | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/synopsys-pt-timing-signoff.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 27-synopsys-pt-timing-signoff.*' && echo || true

.PHONY: diff-28

diff-28:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/synopsys-vcs-sim-sdf 28-gl-sim | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/synopsys-vcs-sim-sdf.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 28-gl-sim.*' && echo || true

.PHONY: diff-29

diff-29:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/netgen-lvs-def 29-netgen-lvs-def | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/netgen-lvs-def.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 29-netgen-lvs-def.*' && echo || true

.PHONY: diff-30

diff-30:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/open-magic-antenna 30-open-magic-antenna | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/open-magic-antenna.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 30-open-magic-antenna.*' && echo || true

.PHONY: diff-31

diff-31:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/open-magic-drc 31-open-magic-drc | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/open-magic-drc.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 31-open-magic-drc.*' && echo || true

.PHONY: diff-32

diff-32:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/open-magic-gds2spice 32-open-magic-gds2spice | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/open-magic-gds2spice.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 32-open-magic-gds2spice.*' && echo || true

.PHONY: diff-33

diff-33:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/open-magic-gds2spice-nobbox 33-open-magic-gds2spice-nobbox | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/open-magic-gds2spice-nobbox.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 33-open-magic-gds2spice-nobbox.*' && echo || true

.PHONY: diff-34

diff-34:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/mentor-calibre-comparison 34-mentor-calibre-comparison | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/mentor-calibre-comparison.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 34-mentor-calibre-comparison.*' && echo || true

.PHONY: diff-35

diff-35:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/mentor-calibre-comparison-nobbox 35-mentor-calibre-comparison-nobbox | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/mentor-calibre-comparison-nobbox.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 35-mentor-calibre-comparison-nobbox.*' && echo || true

.PHONY: diff-36

diff-36:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run*,mflowgen-debug,.stamp,inputs,outputs} ../design/netgen-lvs-gds 36-netgen-lvs-gds | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/netgen-lvs-gds.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 36-netgen-lvs-gds.*' && echo || true

# Info

.PHONY: info-0

info-0:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t constraints && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/0-constraints/configure.yml

.PHONY: info-1

info-1:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t custom-flowstep && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/1-custom-flowstep/configure.yml

.PHONY: info-2

info-2:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t floorplan && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/2-floorplan/configure.yml

.PHONY: info-3

info-3:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t gen-saif-gl && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/3-gen-saif-gl/configure.yml

.PHONY: info-4

info-4:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t info && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/4-info/configure.yml

.PHONY: info-5

info-5:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t pin-placement && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/5-pin-placement/configure.yml

.PHONY: info-6

info-6:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t rtl && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/6-rtl/configure.yml

.PHONY: info-7

info-7:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t skywater-130nm && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/7-skywater-130nm/configure.yml

.PHONY: info-8

info-8:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t sram && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/8-sram/configure.yml

.PHONY: info-9

info-9:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t synopsys-dc-compile && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/9-synopsys-dc-compile/configure.yml

.PHONY: info-10

info-10:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t testbench && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/10-testbench/configure.yml

.PHONY: info-11

info-11:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t rtl-sim && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/11-rtl-sim/configure.yml

.PHONY: info-12

info-12:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t gen-saif-rtl && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/12-gen-saif-rtl/configure.yml

.PHONY: info-13

info-13:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t synopsys-dc-synthesis && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/13-synopsys-dc-synthesis/configure.yml

.PHONY: info-14

info-14:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-flowsetup && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/14-cadence-innovus-flowsetup/configure.yml

.PHONY: info-15

info-15:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-init && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/15-cadence-innovus-init/configure.yml

.PHONY: info-16

info-16:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-power && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/16-cadence-innovus-power/configure.yml

.PHONY: info-17

info-17:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-place && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/17-cadence-innovus-place/configure.yml

.PHONY: info-18

info-18:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-cts && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/18-cadence-innovus-cts/configure.yml

.PHONY: info-19

info-19:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-postcts_hold && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/19-cadence-innovus-postcts_hold/configure.yml

.PHONY: info-20

info-20:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-route && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/20-cadence-innovus-route/configure.yml

.PHONY: info-21

info-21:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-postroute && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/21-cadence-innovus-postroute/configure.yml

.PHONY: info-22

info-22:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t cadence-innovus-signoff && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/22-cadence-innovus-signoff/configure.yml

.PHONY: info-23

info-23:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t mentor-calibre-gdsmerge && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/23-mentor-calibre-gdsmerge/configure.yml

.PHONY: info-24

info-24:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t open-magic-def2spice && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/24-open-magic-def2spice/configure.yml

.PHONY: info-25

info-25:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t ptpx-gl && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/25-ptpx-gl/configure.yml

.PHONY: info-26

info-26:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t ptpx-rtl && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/26-ptpx-rtl/configure.yml

.PHONY: info-27

info-27:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t synopsys-pt-timing-signoff && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/27-synopsys-pt-timing-signoff/configure.yml

.PHONY: info-28

info-28:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t gl-sim && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/28-gl-sim/configure.yml

.PHONY: info-29

info-29:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t netgen-lvs-def && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/29-netgen-lvs-def/configure.yml

.PHONY: info-30

info-30:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t open-magic-antenna && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/30-open-magic-antenna/configure.yml

.PHONY: info-31

info-31:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t open-magic-drc && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/31-open-magic-drc/configure.yml

.PHONY: info-32

info-32:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t open-magic-gds2spice && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/32-open-magic-gds2spice/configure.yml

.PHONY: info-33

info-33:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t open-magic-gds2spice-nobbox && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/33-open-magic-gds2spice-nobbox/configure.yml

.PHONY: info-34

info-34:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t mentor-calibre-comparison && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/34-mentor-calibre-comparison/configure.yml

.PHONY: info-35

info-35:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t mentor-calibre-comparison-nobbox && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/35-mentor-calibre-comparison-nobbox/configure.yml

.PHONY: info-36

info-36:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-letters -c -t netgen-lvs-gds && /home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-info -y .mflowgen/36-netgen-lvs-gds/configure.yml

# Runtimes

.PHONY: runtimes

runtimes:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-runtimes

# List

.PHONY: list

list:
	@echo && echo Generic Targets: && echo && printf " - %s\\n" "list      -- List all steps" "status    -- Print build status for each step" "runtimes  -- Print runtimes for each step" "graph     -- Generate a PDF of the step dependency graph" "clean-all -- Remove all build directories" "clean-N   -- Clean target N" "info-N    -- Print configured info for step N" "diff-N    -- Diff target N" && echo && echo Targets: && echo && printf " - %s\\n" "  0 : constraints" "  1 : custom-flowstep" "  2 : floorplan" "  3 : gen-saif-gl" "  4 : info" "  5 : pin-placement" "  6 : rtl" "  7 : skywater-130nm" "  8 : sram" "  9 : synopsys-dc-compile" " 10 : testbench" " 11 : rtl-sim" " 12 : gen-saif-rtl" " 13 : synopsys-dc-synthesis" " 14 : cadence-innovus-flowsetup" " 15 : cadence-innovus-init" " 16 : cadence-innovus-power" " 17 : cadence-innovus-place" " 18 : cadence-innovus-cts" " 19 : cadence-innovus-postcts_hold" " 20 : cadence-innovus-route" " 21 : cadence-innovus-postroute" " 22 : cadence-innovus-signoff" " 23 : mentor-calibre-gdsmerge" " 24 : open-magic-def2spice" " 25 : ptpx-gl" " 26 : ptpx-rtl" " 27 : synopsys-pt-timing-signoff" " 28 : gl-sim" " 29 : netgen-lvs-def" " 30 : open-magic-antenna" " 31 : open-magic-drc" " 32 : open-magic-gds2spice" " 33 : open-magic-gds2spice-nobbox" " 34 : mentor-calibre-comparison" " 35 : mentor-calibre-comparison-nobbox" " 36 : netgen-lvs-gds" && echo && echo Debug Targets: && echo && printf " - %s\\n" "debug-13 : debug-synopsys-dc-synthesis" "debug-15 : debug-cadence-innovus-init" "debug-16 : debug-cadence-innovus-power" "debug-17 : debug-cadence-innovus-place" "debug-18 : debug-cadence-innovus-cts" "debug-19 : debug-cadence-innovus-postcts_hold" "debug-20 : debug-cadence-innovus-route" "debug-21 : debug-cadence-innovus-postroute" "debug-22 : debug-cadence-innovus-signoff" "debug-23 : debug-mentor-calibre-gdsmerge" "debug-25 : debug-ptpx-gl" "debug-26 : debug-ptpx-rtl" "debug-34 : debug-mentor-calibre-comparison" "debug-35 : debug-mentor-calibre-comparison-nobbox" && echo

# Graph

.PHONY: graph

graph:
	dot -Tpdf .mflowgen/graph.dot > graph.pdf

# Status

.PHONY: status

status:
	@/home/users/jeffreyy/ee372/mflowgen/mflowgen/scripts/mflowgen-status --backend make -s 0-constraints,1-custom-flowstep,2-floorplan,3-gen-saif-gl,4-info,5-pin-placement,6-rtl,7-skywater-130nm,8-sram,9-synopsys-dc-compile,10-testbench,11-rtl-sim,12-gen-saif-rtl,13-synopsys-dc-synthesis,14-cadence-innovus-flowsetup,15-cadence-innovus-init,16-cadence-innovus-power,17-cadence-innovus-place,18-cadence-innovus-cts,19-cadence-innovus-postcts_hold,20-cadence-innovus-route,21-cadence-innovus-postroute,22-cadence-innovus-signoff,23-mentor-calibre-gdsmerge,24-open-magic-def2spice,25-ptpx-gl,26-ptpx-rtl,27-synopsys-pt-timing-signoff,28-gl-sim,29-netgen-lvs-def,30-open-magic-antenna,31-open-magic-drc,32-open-magic-gds2spice,33-open-magic-gds2spice-nobbox,34-mentor-calibre-comparison,35-mentor-calibre-comparison-nobbox,36-netgen-lvs-gds

