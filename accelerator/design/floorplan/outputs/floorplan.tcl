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

# placeInstance accelerator_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro 2278.4450000000 1163.0750000000 R0
# addHaloToBlock 30 100 25 30 accelerator_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
# placeInstance accelerator_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro 1748.6650000000 1163.0750000000 R0
# addHaloToBlock 100 100 25 30 accelerator_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_7__sram_macro 2278.4450000000 1620.5750000000 R0
# addHaloToBlock 25 30 25 30 accelerator_inst/data_mem/genblk1_width_macro_7__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_7__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_6__sram_macro 1748.6650000000 1620.5750000000 R0
# addHaloToBlock 100 30 25 30 accelerator_inst/data_mem/genblk1_width_macro_6__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_6__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_5__sram_macro 2278.4450000000 2078.0750000000 R0
# addHaloToBlock 25 30 25 30 accelerator_inst/data_mem/genblk1_width_macro_5__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_5__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_4__sram_macro 1748.6650000000 2078.0750000000 R0
# addHaloToBlock 100 30 25 30 accelerator_inst/data_mem/genblk1_width_macro_4__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_4__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_3__sram_macro 2278.4450000000 2535.5750000000 R0
# addHaloToBlock 25 30 25 30 accelerator_inst/data_mem/genblk1_width_macro_3__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_3__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_2__sram_macro 1748.6650000000 2535.5750000000 R0
# addHaloToBlock 100 30 25 30 accelerator_inst/data_mem/genblk1_width_macro_2__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_2__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_1__sram_macro 2278.4450000000 2993.0750000000 R0
# addHaloToBlock 25 30 25 30 accelerator_inst/data_mem/genblk1_width_macro_1__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_1__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_0__sram_macro 1748.6650000000 2993.0750000000 R0
# addHaloToBlock 100 30 25 30 accelerator_inst/data_mem/genblk1_width_macro_0__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_0__sram_macro
# createPlaceBlockage -type partial -density 60 -name defScreenName -box {1329.8600000000 858.1600000000 2785.7600000000 1062.1600000000}
# createPlaceBlockage -type partial -density 60 -name defScreenName -box {1330.7800000000 1062.1600000000 1645.8800000000 3417.6800000000}

# createPlaceBlockage -type hard -name defScreenName -box {1463.2600000000 1260.7200000000 2763.6800000000 1396.7200000000}
# createPlaceBlockage -type hard -name defScreenName -box {1460.9600000000 1399.4400000000 1596.2000000000 2713.2000000000}
# createPlaceBlockage -type hard -name defScreenName -box {438.3800000000 2715.9200000000 1597.1200000000 2892.7200000000}
# createPlaceBlockage -type hard -name defScreenName -box {284.2800000000 2713.2000000000 440.2200000000 3387.7600000000}
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_7__sram_macro 2228.4450000000 1451.0750000000 R0
# addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_7__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_7__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_6__sram_macro 1648.6650000000 1451.0750000000 R0
# addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_6__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_6__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_5__sram_macro 2228.4450000000 1948.5750000000 R0
# addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_5__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_5__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_4__sram_macro 1648.6650000000 1948.5750000000 R0
# addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_4__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_4__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_3__sram_macro 2228.4450000000 2446.0750000000 R0
# addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_3__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_3__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_2__sram_macro 1648.6650000000 2446.0750000000 R0
# addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_2__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_2__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_1__sram_macro 2228.4450000000 2943.5750000000 R0
# addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_1__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_1__sram_macro
# placeInstance accelerator_inst/data_mem/genblk1_width_macro_0__sram_macro 1648.6650000000 2943.5750000000 R0
# addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_0__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_0__sram_macro
# placeInstance accelerator_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro 1068.8850000000 2943.5750000000 R0
# addHaloToBlock 20 20 20 20 accelerator_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
# placeInstance accelerator_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro 489.1050000000 2943.5750000000 R0
# addHaloToBlock 20 20 20 20 accelerator_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro
# setInstancePlacementStatus -status fixed -name accelerator_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro
# createPlaceBlockage -type partial -density 20 -name defScreenName -box {379.0400000000 2645.2000000000 2810.6000000000 3414.9600000000}
# createPlaceBlockage -type partial -density 20 -name defScreenName -box {1352.8600000000 1132.8800000000 2806.9200000000 2762.1600000000}

placeInstance accelerator_inst/data_mem/genblk1_width_macro_7__sram_macro 2208.4450000000 1451.0750000000 R0
addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_7__sram_macro
setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_7__sram_macro
placeInstance accelerator_inst/data_mem/genblk1_width_macro_6__sram_macro 1598.6650000000 1451.0750000000 R0
addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_6__sram_macro
setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_6__sram_macro
placeInstance accelerator_inst/data_mem/genblk1_width_macro_5__sram_macro 2208.4450000000 1948.5750000000 R0
addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_5__sram_macro
setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_5__sram_macro
placeInstance accelerator_inst/data_mem/genblk1_width_macro_4__sram_macro 1598.6650000000 1948.5750000000 R0
addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_4__sram_macro
setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_4__sram_macro
placeInstance accelerator_inst/data_mem/genblk1_width_macro_3__sram_macro 2208.4450000000 2446.0750000000 R0
addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_3__sram_macro
setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_3__sram_macro
placeInstance accelerator_inst/data_mem/genblk1_width_macro_2__sram_macro 1598.6650000000 2446.0750000000 R0
addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_2__sram_macro
setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_2__sram_macro
placeInstance accelerator_inst/data_mem/genblk1_width_macro_1__sram_macro 2208.4450000000 2943.5750000000 R0
addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_1__sram_macro
setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_1__sram_macro
placeInstance accelerator_inst/data_mem/genblk1_width_macro_0__sram_macro 1598.6650000000 2943.5750000000 R0
addHaloToBlock 20 20 20 20 accelerator_inst/data_mem/genblk1_width_macro_0__sram_macro
setInstancePlacementStatus -status fixed -name accelerator_inst/data_mem/genblk1_width_macro_0__sram_macro
placeInstance accelerator_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro 988.8850000000 2943.5750000000 R0
addHaloToBlock 20 20 20 20 accelerator_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
setInstancePlacementStatus -status fixed -name accelerator_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
placeInstance accelerator_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro 369.1050000000 2943.5750000000 R0
addHaloToBlock 20 20 20 20 accelerator_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro
setInstancePlacementStatus -status fixed -name accelerator_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro

selectInst accelerator_inst/data_mem/genblk1_width_macro_7__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst accelerator_inst/data_mem/genblk1_width_macro_6__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst accelerator_inst/data_mem/genblk1_width_macro_5__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst accelerator_inst/data_mem/genblk1_width_macro_4__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst accelerator_inst/data_mem/genblk1_width_macro_3__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst accelerator_inst/data_mem/genblk1_width_macro_2__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst accelerator_inst/data_mem/genblk1_width_macro_1__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst accelerator_inst/data_mem/genblk1_width_macro_0__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst accelerator_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll

selectInst accelerator_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro
set llx [dbGet selected.box_llx]
set lly [dbGet selected.box_lly]
set urx [dbGet selected.box_urx]
set ury [dbGet selected.box_ury]
set box "$llx $lly $urx $ury"

createRouteBlk -box $box -layer {li1}
deselectAll


# create Routing Blockage
createRouteBlk -name top_route_blk -layer met5 -box { 10.06000 30.53000 2840.00000 3437.23000 }

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
setOptMode -fixFanoutLoad    false
setOptMode -bufferAssignNets true
setOptMode -maxLength 800
setOptMode -fixCap true
setOptMode -fixTran true


specifyNetWeight accelerator_inst/data_mem_rdata[18] 512
specifyNetWeight accelerator_inst/data_mem_rdata[25] 512
specifyNetWeight accelerator_inst/data_mem_rdata[162] 512
specifyNetWeight accelerator_inst/data_mem_rdata[165] 512
specifyNetWeight accelerator_inst/data_mem_rdata[163] 512
specifyNetWeight accelerator_inst/data_mem_rdata[19] 512
specifyNetWeight accelerator_inst/output_wb_data[211] 512
specifyNetWeight accelerator_inst/data_mem_rdata[9] 512
specifyNetWeight accelerator_inst/data_mem_rdata[31] 512
specifyNetWeight accelerator_inst/data_mem_rdata[167] 512
specifyNetWeight accelerator_inst/data_mem_rdata[20] 512
specifyNetWeight accelerator_inst/output_wb_data[216] 512
specifyNetWeight accelerator_inst/output_wb_data[230] 512
specifyNetWeight accelerator_inst/data_mem_rdata[174] 512
specifyNetWeight accelerator_inst/data_mem_rdata[30] 512
specifyNetWeight accelerator_inst/data_mem_rdata[103] 512
specifyNetWeight accelerator_inst/data_mem_rdata[36] 512
specifyNetWeight accelerator_inst/output_wb_data[224] 512
specifyNetWeight accelerator_inst/data_mem_rdata[160] 512
specifyNetWeight accelerator_inst/data_mem_rdata[28] 512
specifyNetWeight accelerator_inst/data_mem_rdata[23] 512
specifyNetWeight accelerator_inst/data_mem_rdata[148] 512
specifyNetWeight accelerator_inst/data_mem_rdata[109] 512
specifyNetWeight accelerator_inst/data_mem_rdata[173] 512
specifyNetWeight accelerator_inst/data_mem_rdata[98] 512
specifyNetWeight accelerator_inst/output_wb_data[98] 512
specifyNetWeight accelerator_inst/data_mem_rdata[97] 512
specifyNetWeight accelerator_inst/data_mem_rdata[27] 512
specifyNetWeight accelerator_inst/data_mem_rdata[157] 512
specifyNetWeight accelerator_inst/output_wb_data[225] 512
specifyNetWeight accelerator_inst/data_mem_rdata[87] 512
specifyNetWeight accelerator_inst/data_mem_rdata[152] 512
specifyNetWeight accelerator_inst/output_wb_data[101] 512
specifyNetWeight accelerator_inst/data_mem_rdata[29] 512
specifyNetWeight accelerator_inst/data_mem_rdata[84] 512
specifyNetWeight accelerator_inst/data_mem_rdata[16] 512
specifyNetWeight accelerator_inst/output_wb_data[92] 512
specifyNetWeight accelerator_inst/output_wb_data[91] 512
specifyNetWeight accelerator_inst/output_wb_data[160] 512
specifyNetWeight accelerator_inst/data_mem_rdata[22] 512
specifyNetWeight accelerator_inst/data_mem_rdata[99] 512
specifyNetWeight accelerator_inst/data_mem_rdata[161] 512
specifyNetWeight accelerator_inst/data_mem_rdata[38] 512
specifyNetWeight accelerator_inst/data_mem_rdata[41] 512
specifyNetWeight accelerator_inst/output_wb_data[89] 512
specifyNetWeight accelerator_inst/output_wb_data[99] 512
specifyNetWeight accelerator_inst/data_mem_rdata[106] 512
specifyNetWeight accelerator_inst/output_wb_data[88] 512
specifyNetWeight accelerator_inst/output_wb_data[103] 512
specifyNetWeight accelerator_inst/output_wb_data[163] 512
specifyNetWeight accelerator_inst/output_wb_data[100] 512
specifyNetWeight accelerator_inst/output_wb_data[95] 512
specifyNetWeight accelerator_inst/data_mem_rdata[86] 512
specifyNetWeight accelerator_inst/data_mem_rdata[154] 512
specifyNetWeight accelerator_inst/data_mem_rdata[81] 512
specifyNetWeight accelerator_inst/data_mem_rdata[26] 512
specifyNetWeight accelerator_inst/data_mem_rdata[149] 512
specifyNetWeight accelerator_inst/data_mem_rdata[5] 512
specifyNetWeight accelerator_inst/output_wb_data[161] 512
specifyNetWeight accelerator_inst/data_mem_rdata[159] 512
specifyNetWeight accelerator_inst/output_wb_data[158] 512
specifyNetWeight accelerator_inst/output_wb_data[143] 512
specifyNetWeight accelerator_inst/data_mem_rdata[151] 512
specifyNetWeight accelerator_inst/data_mem_rdata[11] 512
specifyNetWeight accelerator_inst/output_wb_data[215] 512
specifyNetWeight accelerator_inst/output_wb_data[221] 512
specifyNetWeight accelerator_inst/data_mem_rdata[158] 512
specifyNetWeight accelerator_inst/output_wb_data[235] 512
specifyNetWeight accelerator_inst/data_mem_rdata[164] 512
specifyNetWeight accelerator_inst/output_wb_data[90] 512
specifyNetWeight accelerator_inst/data_mem_rdata[17] 512
specifyNetWeight accelerator_inst/output_wb_data[217] 512
specifyNetWeight accelerator_inst/data_mem_rdata[91] 512
specifyNetWeight accelerator_inst/data_mem_rdata[21] 512
specifyNetWeight accelerator_inst/data_mem_rdata[92] 512
specifyNetWeight accelerator_inst/output_wb_data[174] 512
specifyNetWeight accelerator_inst/data_mem_rdata[150] 512
specifyNetWeight accelerator_inst/data_mem_rdata[93] 512
specifyNetWeight accelerator_inst/output_wb_data[222] 512
specifyNetWeight accelerator_inst/data_mem_rdata[45] 512
specifyNetWeight accelerator_inst/output_wb_data[223] 512
specifyNetWeight accelerator_inst/output_wb_data[212] 512
specifyNetWeight accelerator_inst/data_mem_rdata[90] 512
specifyNetWeight accelerator_inst/data_mem_rdata[147] 512
specifyNetWeight accelerator_inst/output_wb_data[151] 512
specifyNetWeight accelerator_inst/data_mem_rdata[34] 512
specifyNetWeight accelerator_inst/output_wb_data[218] 512
specifyNetWeight accelerator_inst/output_wb_data[167] 512
specifyNetWeight accelerator_inst/output_wb_data[152] 512
specifyNetWeight accelerator_inst/output_wb_data[220] 512
specifyNetWeight accelerator_inst/data_mem_rdata[191] 512
specifyNetWeight accelerator_inst/data_mem_rdata[166] 512
specifyNetWeight accelerator_inst/output_wb_data[145] 512
specifyNetWeight accelerator_inst/data_mem_rdata[102] 512
specifyNetWeight accelerator_inst/output_wb_data[172] 512
specifyNetWeight accelerator_inst/data_mem_rdata[170] 512
specifyNetWeight accelerator_inst/data_mem_rdata[175] 512
specifyNetWeight accelerator_inst/data_mem_rdata[176] 512
specifyNetWeight accelerator_inst/data_mem_rdata[171] 512
specifyNetWeight accelerator_inst/data_mem_rdata[37] 512
specifyNetWeight accelerator_inst/output_wb_data[234] 512
specifyNetWeight accelerator_inst/data_mem_rdata[89] 512
specifyNetWeight accelerator_inst/data_mem_rdata[104] 512
specifyNetWeight accelerator_inst/output_wb_data[102] 512
specifyNetWeight accelerator_inst/data_mem_rdata[101] 512
specifyNetWeight accelerator_inst/output_wb_data[226] 512
specifyNetWeight accelerator_inst/data_mem_rdata[187] 512
specifyNetWeight accelerator_inst/data_mem_rdata[95] 512
specifyNetWeight accelerator_inst/output_wb_data[164] 512
specifyNetWeight accelerator_inst/output_wb_data[76] 512
specifyNetWeight accelerator_inst/data_mem_rdata[169] 512
specifyNetWeight accelerator_inst/data_mem_rdata[117] 512
specifyNetWeight accelerator_inst/output_wb_data[168] 512
specifyNetWeight accelerator_inst/output_wb_data[204] 512
specifyNetWeight accelerator_inst/output_wb_data[169] 512
specifyNetWeight accelerator_inst/data_mem_rdata[105] 512
specifyNetWeight accelerator_inst/output_wb_data[150] 512
specifyNetWeight accelerator_inst/output_wb_data[231] 512
specifyNetWeight accelerator_inst/output_wb_data[177] 512
specifyNetWeight accelerator_inst/data_mem_rdata[83] 512
specifyNetWeight accelerator_inst/output_wb_data[82] 512
specifyNetWeight accelerator_inst/data_mem_rdata[35] 512
specifyNetWeight accelerator_inst/output_wb_data[86] 512
specifyNetWeight accelerator_inst/data_mem_rdata[10] 512
specifyNetWeight accelerator_inst/data_mem_rdata[94] 512
specifyNetWeight accelerator_inst/output_wb_data[107] 512
specifyNetWeight accelerator_inst/data_mem_rdata[49] 512
specifyNetWeight accelerator_inst/output_wb_data[144] 512
specifyNetWeight accelerator_inst/output_wb_data[104] 512
specifyNetWeight accelerator_inst/output_wb_data[165] 512
specifyNetWeight accelerator_inst/output_wb_data[209] 512
specifyNetWeight accelerator_inst/data_mem_rdata[168] 512
specifyNetWeight accelerator_inst/output_wb_data[87] 512
specifyNetWeight accelerator_inst/output_wb_data[106] 512
specifyNetWeight accelerator_inst/data_mem_rdata[44] 512
specifyNetWeight accelerator_inst/output_wb_data[149] 512
specifyNetWeight accelerator_inst/output_wb_data[105] 512
specifyNetWeight accelerator_inst/output_wb_data[155] 512
specifyNetWeight accelerator_inst/data_mem_rdata[96] 512
specifyNetWeight accelerator_inst/output_wb_data[74] 512
specifyNetWeight accelerator_inst/output_wb_data[214] 512
specifyNetWeight accelerator_inst/output_wb_data[146] 512
specifyNetWeight accelerator_inst/data_mem_rdata[153] 512
specifyNetWeight accelerator_inst/output_wb_data[166] 512
specifyNetWeight accelerator_inst/data_mem_rdata[172] 512
specifyNetWeight accelerator_inst/output_wb_data[213] 512
specifyNetWeight accelerator_inst/data_mem_rdata[178] 512
specifyNetWeight accelerator_inst/output_wb_data[229] 512
specifyNetWeight accelerator_inst/output_wb_data[117] 512
specifyNetWeight accelerator_inst/data_mem_rdata[43] 512
specifyNetWeight accelerator_inst/data_mem_rdata[32] 512
specifyNetWeight accelerator_inst/output_wb_data[170] 512
specifyNetWeight accelerator_inst/output_wb_data[96] 512
specifyNetWeight accelerator_inst/output_wb_data[153] 512
specifyNetWeight accelerator_inst/output_wb_data[79] 512
specifyNetWeight accelerator_inst/output_wb_data[227] 512
specifyNetWeight accelerator_inst/data_mem_rdata[146] 512
specifyNetWeight accelerator_inst/output_wb_data[175] 512
specifyNetWeight accelerator_inst/output_wb_data[83] 512
specifyNetWeight accelerator_inst/data_mem_rdata[7] 512
specifyNetWeight accelerator_inst/output_wb_data[94] 512
specifyNetWeight accelerator_inst/output_wb_data[84] 512
specifyNetWeight accelerator_inst/output_wb_data[173] 512
specifyNetWeight accelerator_inst/output_wb_data[148] 512
specifyNetWeight accelerator_inst/output_wb_data[109] 512
specifyNetWeight accelerator_inst/data_mem_rdata[110] 512
specifyNetWeight accelerator_inst/output_wb_data[110] 512
specifyNetWeight accelerator_inst/data_mem_rdata[156] 512
specifyNetWeight accelerator_inst/output_wb_data[111] 512
specifyNetWeight accelerator_inst/output_wb_data[162] 512
specifyNetWeight accelerator_inst/output_wb_data[159] 512
specifyNetWeight accelerator_inst/output_wb_data[97] 512
specifyNetWeight accelerator_inst/output_wb_data[80] 512
specifyNetWeight accelerator_inst/data_mem_rdata[39] 512
specifyNetWeight accelerator_inst/data_mem_rdata[24] 512
specifyNetWeight accelerator_inst/output_wb_data[154] 512
specifyNetWeight accelerator_inst/output_wb_data[75] 512
specifyNetWeight accelerator_inst/output_wb_data[171] 512
specifyNetWeight accelerator_inst/output_wb_data[219] 512
specifyNetWeight accelerator_inst/output_wb_data[85] 512
specifyNetWeight accelerator_inst/data_mem_rdata[46] 512
specifyNetWeight accelerator_inst/output_wb_data[200] 512
specifyNetWeight accelerator_inst/data_mem_rdata[177] 512
specifyNetWeight accelerator_inst/data_mem_rdata[100] 512
specifyNetWeight accelerator_inst/data_mem_rdata[155] 512
specifyNetWeight accelerator_inst/output_wb_data[142] 512
specifyNetWeight accelerator_inst/output_wb_data[112] 512
specifyNetWeight accelerator_inst/data_mem_rdata[108] 512
specifyNetWeight accelerator_inst/data_mem_rdata[113] 512
specifyNetWeight accelerator_inst/data_mem_rdata[15] 512
specifyNetWeight accelerator_inst/data_mem_rdata[120] 512
specifyNetWeight accelerator_inst/output_wb_data[237] 512
specifyNetWeight accelerator_inst/output_wb_data[147] 512
specifyNetWeight accelerator_inst/output_wb_data[208] 512
specifyNetWeight accelerator_inst/data_mem_rdata[115] 512
specifyNetWeight accelerator_inst/data_mem_rdata[33] 512
specifyNetWeight accelerator_inst/output_wb_data[141] 512
specifyNetWeight accelerator_inst/output_wb_data[114] 512
specifyNetWeight accelerator_inst/data_mem_rdata[145] 512
specifyNetWeight accelerator_inst/data_mem_rdata[107] 512
specifyNetWeight accelerator_inst/output_wb_data[238] 512
specifyNetWeight accelerator_inst/data_mem_rdata[180] 512
specifyNetWeight accelerator_inst/output_wb_data[93] 512
specifyNetWeight accelerator_inst/output_wb_data[210] 512
specifyNetWeight accelerator_inst/output_wb_data[236] 512
specifyNetWeight accelerator_inst/data_mem_rdata[8] 512
specifyNetWeight accelerator_inst/output_wb_data[157] 512
specifyNetWeight accelerator_inst/output_wb_data[123] 512
specifyNetWeight accelerator_inst/output_wb_data[228] 512
specifyNetWeight accelerator_inst/output_wb_data[119] 512
specifyNetWeight accelerator_inst/output_wb_data[78] 512
specifyNetWeight accelerator_inst/data_mem_rdata[47] 512
specifyNetWeight accelerator_inst/output_wb_data[233] 512
specifyNetWeight accelerator_inst/data_mem_rdata[13] 512
specifyNetWeight accelerator_inst/output_wb_data[156] 512
specifyNetWeight accelerator_inst/output_wb_data[205] 512
specifyNetWeight accelerator_inst/data_mem_rdata[144] 512
specifyNetWeight accelerator_inst/data_mem_rdata[78] 512
specifyNetWeight accelerator_inst/output_wb_data[113] 512
specifyNetWeight accelerator_inst/output_wb_data[203] 512
specifyNetWeight accelerator_inst/output_wb_data[108] 512
specifyNetWeight accelerator_inst/output_wb_data[181] 512
specifyNetWeight accelerator_inst/output_wb_data[72] 512
specifyNetWeight accelerator_inst/output_wb_data[240] 512
specifyNetWeight accelerator_inst/data_mem_rdata[56] 512
specifyNetWeight accelerator_inst/output_wb_data[136] 512
specifyNetWeight accelerator_inst/data_mem_rdata[141] 512
specifyNetWeight accelerator_inst/data_mem_rdata[179] 512
specifyNetWeight accelerator_inst/output_wb_data[81] 512
specifyNetWeight accelerator_inst/data_mem_rdata[14] 512
specifyNetWeight accelerator_inst/data_mem_rdata[143] 512
specifyNetWeight accelerator_inst/data_mem_rdata[116] 512
specifyNetWeight accelerator_inst/data_mem_rdata[138] 512
specifyNetWeight accelerator_inst/output_wb_data[194] 512
specifyNetWeight accelerator_inst/data_mem_rdata[111] 512
specifyNetWeight accelerator_inst/data_mem_rdata[40] 512
specifyNetWeight accelerator_inst/data_mem_rdata[66] 512
specifyNetWeight accelerator_inst/data_mem_rdata[6] 512
specifyNetWeight accelerator_inst/output_wb_data[232] 512
specifyNetWeight accelerator_inst/output_wb_data[199] 512
specifyNetWeight accelerator_inst/output_wb_data[179] 512
specifyNetWeight accelerator_inst/output_wb_data[202] 512
specifyNetWeight accelerator_inst/data_mem_rdata[88] 512
specifyNetWeight accelerator_inst/data_mem_rdata[12] 512
specifyNetWeight accelerator_inst/output_wb_data[77] 512
specifyNetWeight accelerator_inst/output_wb_data[201] 512
specifyNetWeight accelerator_inst/data_mem_rdata[82] 512
specifyNetWeight accelerator_inst/data_mem_rdata[67] 512
specifyNetWeight accelerator_inst/output_wb_data[241] 512
specifyNetWeight accelerator_inst/output_wb_data[207] 512
specifyNetWeight accelerator_inst/data_mem_rdata[184] 512
specifyNetWeight accelerator_inst/data_mem_rdata[85] 512
specifyNetWeight accelerator_inst/data_mem_rdata[79] 512
specifyNetWeight accelerator_inst/output_wb_data[183] 512
specifyNetWeight accelerator_inst/data_mem_rdata[126] 512
specifyNetWeight accelerator_inst/data_mem_rdata[135] 512
specifyNetWeight accelerator_inst/output_wb_data[243] 512
specifyNetWeight accelerator_inst/output_wb_data[206] 512
specifyNetWeight accelerator_inst/data_mem_rdata[124] 512
specifyNetWeight accelerator_inst/data_mem_rdata[139] 512
specifyNetWeight accelerator_inst/data_mem_rdata[189] 512
specifyNetWeight accelerator_inst/output_wb_data[239] 512
specifyNetWeight accelerator_inst/data_mem_rdata[77] 512
specifyNetWeight accelerator_inst/data_mem_rdata[50] 512
specifyNetWeight accelerator_inst/data_mem_rdata[182] 512
specifyNetWeight accelerator_inst/output_wb_data[180] 512
specifyNetWeight accelerator_inst/data_mem_rdata[119] 512
specifyNetWeight accelerator_inst/data_mem_rdata[75] 512
specifyNetWeight accelerator_inst/data_mem_rdata[183] 512
specifyNetWeight accelerator_inst/data_mem_rdata[42] 512
specifyNetWeight accelerator_inst/output_wb_data[176] 512
specifyNetWeight accelerator_inst/output_wb_data[182] 512
specifyNetWeight accelerator_inst/output_wb_data[244] 512
specifyNetWeight accelerator_inst/output_wb_data[115] 512
specifyNetWeight accelerator_inst/data_mem_rdata[53] 512
specifyNetWeight accelerator_inst/output_wb_data[118] 512
specifyNetWeight accelerator_inst/data_mem_rdata[181] 512
specifyNetWeight accelerator_inst/data_mem_rdata[185] 512
specifyNetWeight accelerator_inst/data_mem_rdata[133] 512
specifyNetWeight accelerator_inst/data_mem_rdata[72] 512
specifyNetWeight accelerator_inst/data_mem_rdata[112] 512
specifyNetWeight accelerator_inst/data_mem_rdata[69] 512
specifyNetWeight accelerator_inst/data_mem_rdata[137] 512
specifyNetWeight accelerator_inst/data_mem_rdata[74] 512
specifyNetWeight accelerator_inst/output_wb_data[246] 512
specifyNetWeight accelerator_inst/output_wb_data[67] 512
specifyNetWeight accelerator_inst/output_wb_data[198] 512
specifyNetWeight accelerator_inst/output_wb_data[140] 512
specifyNetWeight accelerator_inst/output_wb_data[245] 512
specifyNetWeight accelerator_inst/data_mem_rdata[73] 512
specifyNetWeight accelerator_inst/output_wb_data[129] 512
specifyNetWeight accelerator_inst/output_wb_data[135] 512
specifyNetWeight accelerator_inst/data_mem_rdata[54] 512
specifyNetWeight accelerator_inst/output_wb_data[195] 512
specifyNetWeight accelerator_inst/output_wb_data[188] 512
specifyNetWeight accelerator_inst/data_mem_rdata[142] 512
specifyNetWeight accelerator_inst/data_mem_rdata[71] 512
specifyNetWeight accelerator_inst/data_mem_rdata[76] 512
specifyNetWeight accelerator_inst/data_mem_rdata[57] 512
specifyNetWeight accelerator_inst/output_wb_data[138] 512
specifyNetWeight accelerator_inst/data_mem_rdata[51] 512
specifyNetWeight accelerator_inst/data_mem_rdata[121] 512
specifyNetWeight accelerator_inst/data_mem_rdata[3] 512
specifyNetWeight accelerator_inst/data_mem_rdata[80] 512
specifyNetWeight accelerator_inst/output_wb_data[197] 512
specifyNetWeight accelerator_inst/data_mem_rdata[52] 512
specifyNetWeight accelerator_inst/data_mem_rdata[136] 512
specifyNetWeight accelerator_inst/data_mem_rdata[127] 512
specifyNetWeight accelerator_inst/data_mem_rdata[2] 512
specifyNetWeight accelerator_inst/output_wb_data[193] 512
specifyNetWeight accelerator_inst/output_wb_data[249] 512
specifyNetWeight accelerator_inst/output_wb_data[64] 512
specifyNetWeight accelerator_inst/output_wb_data[178] 512
specifyNetWeight accelerator_inst/output_wb_data[137] 512
specifyNetWeight accelerator_inst/output_wb_data[191] 512
specifyNetWeight accelerator_inst/data_mem_rdata[70] 512
specifyNetWeight accelerator_inst/output_wb_data[116] 512
specifyNetWeight accelerator_inst/output_wb_data[134] 512
specifyNetWeight accelerator_inst/output_wb_data[187] 512
specifyNetWeight accelerator_inst/data_mem_rdata[118] 512
specifyNetWeight accelerator_inst/data_mem_rdata[59] 512
specifyNetWeight accelerator_inst/data_mem_rdata[186] 512
specifyNetWeight accelerator_inst/output_wb_data[71] 512
specifyNetWeight accelerator_inst/data_mem_rdata[1] 512
specifyNetWeight accelerator_inst/data_mem_rdata[4] 512
specifyNetWeight accelerator_inst/output_wb_data[196] 512
specifyNetWeight accelerator_inst/output_wb_data[186] 512
specifyNetWeight accelerator_inst/data_mem_rdata[123] 512
specifyNetWeight accelerator_inst/data_mem_rdata[58] 512
specifyNetWeight accelerator_inst/data_mem_rdata[129] 512
specifyNetWeight accelerator_inst/data_mem_rdata[48] 512
specifyNetWeight accelerator_inst/data_mem_rdata[188] 512
specifyNetWeight accelerator_inst/data_mem_rdata[140] 512
specifyNetWeight accelerator_inst/output_wb_data[68] 512
specifyNetWeight accelerator_inst/output_wb_data[242] 512
specifyNetWeight accelerator_inst/output_wb_data[121] 512
specifyNetWeight accelerator_inst/data_mem_rdata[131] 512
specifyNetWeight accelerator_inst/output_wb_data[126] 512
specifyNetWeight accelerator_inst/data_mem_rdata[55] 512
specifyNetWeight accelerator_inst/output_wb_data[122] 512
specifyNetWeight accelerator_inst/output_wb_data[73] 512
specifyNetWeight accelerator_inst/data_mem_rdata[60] 512
specifyNetWeight accelerator_inst/output_wb_data[185] 512
specifyNetWeight accelerator_inst/data_mem_rdata[114] 512
specifyNetWeight accelerator_inst/output_wb_data[252] 512
specifyNetWeight accelerator_inst/output_wb_data[189] 512
specifyNetWeight accelerator_inst/output_wb_data[131] 512
specifyNetWeight accelerator_inst/data_mem_rdata[134] 512
specifyNetWeight accelerator_inst/data_mem_rdata[190] 512
specifyNetWeight accelerator_inst/output_wb_data[247] 512
specifyNetWeight accelerator_inst/output_wb_data[125] 512
specifyNetWeight accelerator_inst/output_wb_data[139] 512
specifyNetWeight accelerator_inst/data_mem_rdata[61] 512
specifyNetWeight accelerator_inst/data_mem_rdata[63] 512
specifyNetWeight accelerator_inst/output_wb_data[65] 512
specifyNetWeight accelerator_inst/output_wb_data[69] 512
specifyNetWeight accelerator_inst/output_wb_data[70] 512
specifyNetWeight accelerator_inst/data_mem_rdata[130] 512
specifyNetWeight accelerator_inst/output_wb_data[120] 512
specifyNetWeight accelerator_inst/data_mem_rdata[122] 512
specifyNetWeight accelerator_inst/output_wb_data[190] 512
specifyNetWeight accelerator_inst/output_wb_data[128] 512
specifyNetWeight accelerator_inst/output_wb_data[66] 512
specifyNetWeight accelerator_inst/output_wb_data[251] 512
specifyNetWeight accelerator_inst/output_wb_data[248] 512
specifyNetWeight accelerator_inst/output_wb_data[132] 512
specifyNetWeight accelerator_inst/data_mem_rdata[132] 512
specifyNetWeight accelerator_inst/output_wb_data[254] 512
specifyNetWeight accelerator_inst/data_mem_rdata[0] 512
specifyNetWeight accelerator_inst/output_wb_data[127] 512
specifyNetWeight accelerator_inst/output_wb_data[130] 512
specifyNetWeight accelerator_inst/output_wb_data[253] 512
specifyNetWeight accelerator_inst/data_mem_rdata[68] 512
specifyNetWeight accelerator_inst/output_wb_data[184] 512
specifyNetWeight accelerator_inst/output_wb_data[133] 512
specifyNetWeight accelerator_inst/output_wb_data[250] 512
specifyNetWeight accelerator_inst/data_mem_rdata[125] 512
specifyNetWeight accelerator_inst/output_wb_data[192] 512
specifyNetWeight accelerator_inst/data_mem_rdata[64] 512
specifyNetWeight accelerator_inst/output_wb_data[255] 512
specifyNetWeight accelerator_inst/data_mem_rdata[128] 512
specifyNetWeight accelerator_inst/data_mem_rdata[62] 512
specifyNetWeight accelerator_inst/output_wb_data[124] 512
specifyNetWeight accelerator_inst/data_mem_rdata[65] 512
    
