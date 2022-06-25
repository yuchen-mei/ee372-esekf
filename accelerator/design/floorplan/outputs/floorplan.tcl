#=========================================================================
# floorplan.tcl
#=========================================================================
# This script is called from the Innovus init flow step.
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Floorplan variables
#-------------------------------------------------------------------------

# Make room in the floorplan for the core power ring
set pwr_net_list {VDD VSS}; # List of power nets in the core power ring

set M1_min_width   [dbGet [dbGetLayerByZ 1].minWidth]
set M1_min_spacing [dbGet [dbGetLayerByZ 1].minSpacing]

set savedvars(p_ring_width)   [expr 48 * $M1_min_width];   # Arbitrary!
set savedvars(p_ring_spacing) [expr 24 * $M1_min_spacing]; # Arbitrary!

# Core bounding box margins
set core_margin_t [expr ([llength $pwr_net_list] * ($savedvars(p_ring_width) + $savedvars(p_ring_spacing))) + $savedvars(p_ring_spacing)]
set core_margin_b [expr ([llength $pwr_net_list] * ($savedvars(p_ring_width) + $savedvars(p_ring_spacing))) + $savedvars(p_ring_spacing)]
set core_margin_r [expr ([llength $pwr_net_list] * ($savedvars(p_ring_width) + $savedvars(p_ring_spacing))) + $savedvars(p_ring_spacing)]
set core_margin_l [expr ([llength $pwr_net_list] * ($savedvars(p_ring_width) + $savedvars(p_ring_spacing))) + $savedvars(p_ring_spacing)]

# User project area is limited to 2920um x 3520um
floorPlan -d [expr 2860] \
             [expr 3470] \
             $core_margin_l $core_margin_b $core_margin_r $core_margin_t


setFlipping s


# Use automatic floorplan synthesis to pack macros (e.g., SRAMs) together
# planDesign

# placeInstance acc_inst/data_mem/genblk1_width_macro_7__sram_macro 2208.4450000000 1451.0750000000 R0
# addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_7__sram_macro
# setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_7__sram_macro
# placeInstance acc_inst/data_mem/genblk1_width_macro_6__sram_macro 1598.6650000000 1451.0750000000 R0
# addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_6__sram_macro
# setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_6__sram_macro
# placeInstance acc_inst/data_mem/genblk1_width_macro_5__sram_macro 2208.4450000000 1948.5750000000 R0
# addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_5__sram_macro
# setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_5__sram_macro
# placeInstance acc_inst/data_mem/genblk1_width_macro_4__sram_macro 1598.6650000000 1948.5750000000 R0
# addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_4__sram_macro
# setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_4__sram_macro
# placeInstance acc_inst/data_mem/genblk1_width_macro_3__sram_macro 2208.4450000000 2446.0750000000 R0
# addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_3__sram_macro
# setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_3__sram_macro
# placeInstance acc_inst/data_mem/genblk1_width_macro_2__sram_macro 1598.6650000000 2446.0750000000 R0
# addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_2__sram_macro
# setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_2__sram_macro
# placeInstance acc_inst/data_mem/genblk1_width_macro_1__sram_macro 2208.4450000000 2943.5750000000 R0
# addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_1__sram_macro
# setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_1__sram_macro
# placeInstance acc_inst/data_mem/genblk1_width_macro_0__sram_macro 1598.6650000000 2943.5750000000 R0
# addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_0__sram_macro
# setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_0__sram_macro
# placeInstance acc_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro 988.8850000000 2943.5750000000 R0
# addHaloToBlock 20 20 20 20 acc_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
# setInstancePlacementStatus -status fixed -name acc_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
# placeInstance acc_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro 369.1050000000 2943.5750000000 R0
# addHaloToBlock 20 20 20 20 acc_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro
# setInstancePlacementStatus -status fixed -name acc_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro

placeInstance acc_inst/data_mem/genblk1_width_macro_7__sram_macro 2208.4450000000 1451.0750000000 R0
addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_7__sram_macro
setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_7__sram_macro
placeInstance acc_inst/data_mem/genblk1_width_macro_6__sram_macro 1528.6650000000 1451.0750000000 R0
addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_6__sram_macro
setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_6__sram_macro
placeInstance acc_inst/data_mem/genblk1_width_macro_5__sram_macro 2208.4450000000 1948.5750000000 R0
addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_5__sram_macro
setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_5__sram_macro
placeInstance acc_inst/data_mem/genblk1_width_macro_4__sram_macro 1528.6650000000 1948.5750000000 R0
addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_4__sram_macro
setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_4__sram_macro
placeInstance acc_inst/data_mem/genblk1_width_macro_3__sram_macro 2208.4450000000 2446.0750000000 R0
addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_3__sram_macro
setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_3__sram_macro
placeInstance acc_inst/data_mem/genblk1_width_macro_2__sram_macro 1528.6650000000 2446.0750000000 R0
addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_2__sram_macro
setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_2__sram_macro
placeInstance acc_inst/data_mem/genblk1_width_macro_1__sram_macro 2208.4450000000 2943.5750000000 R0
addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_1__sram_macro
setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_1__sram_macro
placeInstance acc_inst/data_mem/genblk1_width_macro_0__sram_macro 1528.6650000000 2943.5750000000 R0
addHaloToBlock 20 20 20 20 acc_inst/data_mem/genblk1_width_macro_0__sram_macro
setInstancePlacementStatus -status fixed -name acc_inst/data_mem/genblk1_width_macro_0__sram_macro
placeInstance acc_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro 868.8850000000 2943.5750000000 R0
addHaloToBlock 20 20 20 20 acc_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
setInstancePlacementStatus -status fixed -name acc_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
placeInstance acc_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro 239.1050000000 2943.5750000000 R0
addHaloToBlock 20 20 20 20 acc_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro
setInstancePlacementStatus -status fixed -name acc_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro

selectInst acc_inst/data_mem/genblk1_width_macro_7__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst acc_inst/data_mem/genblk1_width_macro_6__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst acc_inst/data_mem/genblk1_width_macro_5__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst acc_inst/data_mem/genblk1_width_macro_4__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst acc_inst/data_mem/genblk1_width_macro_3__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst acc_inst/data_mem/genblk1_width_macro_2__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst acc_inst/data_mem/genblk1_width_macro_1__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst acc_inst/data_mem/genblk1_width_macro_0__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst acc_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst acc_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

# set dont use cells
echo "Adding dont-use-cells"
setDontUse sky130_fd_sc_hd__probec_p_8     true
setDontUse sky130_fd_sc_hd__probe_p_8      true

setDontUse sky130_fd_sc_hd__clkinvlp_2     true
setDontUse sky130_fd_sc_hd__clkinvlp_4     true

setDontUse sky130_fd_sc_hd__dlygate4sd1_1  true
setDontUse sky130_fd_sc_hd__dlygate4sd2_1  true
setDontUse sky130_fd_sc_hd__dlygate4sd3_1  true

setDontUse sky130_fd_sc_hd__dlymetal6s2s_1 true
setDontUse sky130_fd_sc_hd__dlymetal6s4s_1 true
setDontUse sky130_fd_sc_hd__dlymetal6s6s_1 true

setDontUse sky130_fd_sc_hd__buf_16         true
setDontUse sky130_fd_sc_hd__lpflow*        true
setDontUse sky130_fd_sc_hd__clkinv_16      true

setDontUse sky130_fd_sc_hd__clkdlybuf4s15_1 true
setDontUse sky130_fd_sc_hd__clkdlybuf4s15_2 true
setDontUse sky130_fd_sc_hd__clkdlybuf4s18_1 true
setDontUse sky130_fd_sc_hd__clkdlybuf4s18_2 true
setDontUse sky130_fd_sc_hd__clkdlybuf4s25_1 true
setDontUse sky130_fd_sc_hd__clkdlybuf4s25_2 true
setDontUse sky130_fd_sc_hd__clkdlybuf4s50_1 true
setDontUse sky130_fd_sc_hd__clkdlybuf4s50_2 true

setDontUse sky130_fd_sc_hd__and2_0 true

setOptMode -drcMargin 0.3
setOptMode -fixFanoutLoad false
setOptMode -bufferAssignNets true
setOptMode -maxLength 800
setOptMode -fixCap true
setOptMode -fixTran true