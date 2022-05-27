#=========================================================================
# floorplan.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Floorplan variables
#-------------------------------------------------------------------------

# Set the floorplan to target a reasonable placement density with a good
# aspect ratio (height:width). An aspect ratio of 2.0 here will make a
# rectangular chip with a height that is twice the width.

# set core_aspect_ratio   1.00; # Aspect ratio 1.0 for a square chip
# set core_density_target 0.75; # Placement density of 70% is reasonable

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

#-------------------------------------------------------------------------
# Floorplan
#-------------------------------------------------------------------------

# Calling floorPlan with the "-r" flag sizes the floorplan according to
# the core aspect ratio and a density target (70% is a reasonable
# density).
#

# floorPlan -r $core_aspect_ratio $core_density_target \
#              $core_margin_l $core_margin_b $core_margin_r $core_margin_t

# User project area is limited to 2920um x 3520um
floorPlan -d [expr 2860] \
             [expr 3470] \
             $core_margin_l $core_margin_b $core_margin_r $core_margin_t

setFlipping s

# Use automatic floorplan synthesis to pack macros (e.g., SRAMs) together
placeInstance instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro 2315.8150000000 2915.4350000000 R90
addHaloToBlock 7 7 7 7 instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
placeInstance instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro 2315.8150000000 2346.6650000000 R90
addHaloToBlock 7 7 7 7 instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro
placeInstance glb_mem/genblk1_width_macro_15__sram 1650.1100000000 2346.6650000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_15__sram
placeInstance glb_mem/genblk1_width_macro_14__sram 1143.7100000000 2346.6650000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_14__sram
placeInstance glb_mem/genblk1_width_macro_13__sram 1650.1100000000 2915.4350000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_13__sram
placeInstance glb_mem/genblk1_width_macro_12__sram 1143.7100000000 2915.4350000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_12__sram
placeInstance glb_mem/genblk1_width_macro_11__sram 637.3100000000 2915.4350000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_11__sram
placeInstance glb_mem/genblk1_width_macro_10__sram 130.9100000000 2915.4350000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_10__sram
placeInstance glb_mem/genblk1_width_macro_9__sram 637.3100000000 2346.6650000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_9__sram
placeInstance glb_mem/genblk1_width_macro_8__sram 130.9100000000 2346.6650000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_8__sram
placeInstance glb_mem/genblk1_width_macro_7__sram 637.3100000000 1777.8950000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_7__sram
placeInstance glb_mem/genblk1_width_macro_6__sram 130.9100000000 1777.8950000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_6__sram
placeInstance glb_mem/genblk1_width_macro_5__sram 637.3100000000 1209.1300000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_5__sram
placeInstance glb_mem/genblk1_width_macro_4__sram 130.9100000000 1209.1300000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_4__sram
placeInstance glb_mem/genblk1_width_macro_3__sram 637.3100000000 640.3600000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_3__sram
placeInstance glb_mem/genblk1_width_macro_2__sram 130.9100000000 640.3600000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_2__sram
placeInstance glb_mem/genblk1_width_macro_1__sram 637.3100000000 71.5900000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_1__sram
placeInstance glb_mem/genblk1_width_macro_0__sram 130.9100000000 71.5900000000 R90
addHaloToBlock 7 7 7 7 glb_mem/genblk1_width_macro_0__sram



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
