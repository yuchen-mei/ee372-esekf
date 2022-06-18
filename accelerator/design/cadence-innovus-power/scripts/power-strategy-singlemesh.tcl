#=========================================================================
# power-strategy-singlemesh.tcl
#=========================================================================
# This script implements a single power mesh on the upper metal layers.
# Note that M2 is expected to be vertical, and the lower metal layer of
# the power mesh is expected to be horizontal.
#
# Author : Christopher Torng
# Date   : January 20, 2019

#-------------------------------------------------------------------------
# Stdcell power rail preroute
#-------------------------------------------------------------------------
# Generate horizontal stdcell preroutes

sroute -nets {vccd1 vssd1} -connect {corePin}

#-------------------------------------------------------------------------
# Shorter names from the ADK
#-------------------------------------------------------------------------

set pmesh_bot $ADK_POWER_MESH_BOT_LAYER
set pmesh_top $ADK_POWER_MESH_TOP_LAYER

#-------------------------------------------------------------------------
# Power ring
#-------------------------------------------------------------------------

addRing -nets {vccd1 vssd1} -type core_rings -follow core   \
        -layer [list top  $pmesh_top bottom $pmesh_top  \
                     left $pmesh_bot right  $pmesh_bot] \
        -width   3.1 \
        -spacing 3.1 \
        -offset  0   \
        -extend_corner {tl tr bl br lt lb rt rb}

# selectInst sram
selectInst acc_inst/instr_mem/genblk1_depth_macro_1__width_macro_0__sram_macro
selectInst acc_inst/instr_mem/genblk1_depth_macro_0__width_macro_0__sram_macro
selectInst acc_inst/data_mem/genblk1_width_macro_7__sram_macro
selectInst acc_inst/data_mem/genblk1_width_macro_6__sram_macro
selectInst acc_inst/data_mem/genblk1_width_macro_5__sram_macro
selectInst acc_inst/data_mem/genblk1_width_macro_4__sram_macro
selectInst acc_inst/data_mem/genblk1_width_macro_3__sram_macro
selectInst acc_inst/data_mem/genblk1_width_macro_2__sram_macro
selectInst acc_inst/data_mem/genblk1_width_macro_1__sram_macro
selectInst acc_inst/data_mem/genblk1_width_macro_0__sram_macro

setAddRingMode -ring_target default -extend_over_row 0 \
               -ignore_rows 0 -avoid_short 0 \
               -skip_crossing_trunks none \
               -stacked_via_top_layer met5 \
               -stacked_via_bottom_layer met3 \
               -via_using_exact_crossover_size 1 \
               -orthogonal_only true \
               -skip_via_on_pin { standardcell } \
               -skip_via_on_wire_shape { noshape }

addRing -nets {vssd1 vccd1} -type block_rings -around each_block \
        -layer {top met3 bottom met3 left met4 right met4} \
        -width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
        -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} \
        -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
        -center 0 -threshold 0 -jog_distance 0 \
        -snap_wire_center_to_grid None

#-------------------------------------------------------------------------
# Power mesh bottom settings (vertical)
#-------------------------------------------------------------------------
# - pmesh_bot_str_width            : 8X thickness compared to 3 * M1 width
# - pmesh_bot_str_pitch            : Arbitrarily choosing the stripe pitch
# - pmesh_bot_str_intraset_spacing : Space between VSS/VDD, choosing
#                                    constant pitch across VSS/VDD stripes
# - pmesh_bot_str_interset_pitch   : Pitch between same-signal stripes

# Get M1 min width and signal routing pitch as defined in the LEF

set M1_min_width    [dbGet [dbGetLayerByZ 2].minWidth]
set M1_route_pitchX [dbGet [dbGetLayerByZ 2].pitchX]

# Bottom stripe params, coming from user project wrapper
# See: https://github.com/efabless/caravel_user_project/blob/main/openlane/user_project_wrapper/config.json

set pmesh_bot_str_width [expr  8 *  3 * $M1_min_width   ]
set pmesh_bot_str_pitch [expr 20 * 10 * $M1_route_pitchX]

set pmesh_bot_str_intraset_spacing [expr $pmesh_bot_str_pitch - $pmesh_bot_str_width]
set pmesh_bot_str_interset_pitch   [expr 2*$pmesh_bot_str_pitch]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer met1 \
                 -stacked_via_top_layer    $pmesh_top \
                 -trim_antenna_back_to_shape stripe \
                 -break_at {  block_ring  } 
# Add the stripes
#
# Use -start to offset the stripes slightly away from the core edge.
# Allow same-layer jogs to connect stripes to the core ring if some
# blockage is in the way (e.g., connections from core ring to pads).
# Restrict any routing around blockages to use only layers for power.

addStripe -nets {vssd1 vccd1} -layer $pmesh_bot -direction vertical \
    -width $pmesh_bot_str_width                                 \
    -spacing $pmesh_bot_str_intraset_spacing                    \
    -set_to_set_distance $pmesh_bot_str_interset_pitch          \
    -max_same_layer_jog_length $pmesh_bot_str_pitch             \
    -padcore_ring_bottom_layer_limit $pmesh_bot                 \
    -padcore_ring_top_layer_limit $pmesh_top                    \
    -start [expr 1*$pmesh_bot_str_pitch]

#-------------------------------------------------------------------------
# Power mesh top settings (horizontal)
#-------------------------------------------------------------------------
# - pmesh_top_str_width            : 8X thickness compared to 3 * M1 width
# - pmesh_top_str_pitch            : Arbitrarily choosing the stripe pitch
# - pmesh_top_str_intraset_spacing : Space between VSS/VDD, choosing
#                                    constant pitch across VSS/VDD stripes
# - pmesh_top_str_interset_pitch   : Pitch between same-signal stripes

set pmesh_top_str_width [expr  8 *  3 * $M1_min_width  ]
set pmesh_top_str_pitch [expr 4 * 10 * $M1_route_pitchX]

set pmesh_top_str_intraset_spacing [expr 3.1]
set pmesh_top_str_interset_pitch   [expr 90]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer $pmesh_bot \
                 -stacked_via_top_layer    $pmesh_top \
                 -trim_antenna_back_to_shape stripe
# Add the stripes
#
# Use -start to offset the stripes slightly away from the core edge.
# Allow same-layer jogs to connect stripes to the core ring if some
# blockage is in the way (e.g., connections from core ring to pads).
# Restrict any routing around blockages to use only layers for power.

addStripe -nets {vssd1 vccd1} -layer $pmesh_top -direction horizontal \
    -width $pmesh_top_str_width                                   \
    -spacing $pmesh_top_str_intraset_spacing                      \
    -set_to_set_distance $pmesh_top_str_interset_pitch            \
    -max_same_layer_jog_length $pmesh_top_str_pitch               \
    -padcore_ring_bottom_layer_limit $pmesh_bot                   \
    -padcore_ring_top_layer_limit $pmesh_top                      \
    -block_ring_bottom_layer_limit met4                           \
    -start 65


# trim the dangling stripes
editTrim -nets {vccd1 vssd1}

# Change PG to cover so they don't get removed in post-route
editChangeStatus -nets {vccd1 vssd1} -to COVER

# Stop metal 5 routing for later steps
setPlaceMode -prerouteAsObs {5}

# create Routing Blockage
createRouteBlk -name defLayerBlkName -layer met5 -box { 0.03000 0.00000 2859.82000 19.04500 }
createRouteBlk -name defLayerBlkName -layer met5 -box { 0.00500 28.81500 2859.82000 3439.39500 }
createRouteBlk -name defLayerBlkName -layer met5 -box { 0.01500 3449.16000 2859.82000 3470.02500 }