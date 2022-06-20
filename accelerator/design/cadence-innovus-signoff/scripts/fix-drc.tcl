# get diode cell name
# get_db base_cells -if {.num_base_pins == 1}


# temporarily turn off antenna fixing and reduce timing optimization
setNanoRouteMode -drouteFixAntenna 0
setNanoRouteMode -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail -viaOpt -wireOpt

# fix drv violations

# setOptMode -drcMargin 0.4
# setOptMode -setupTargetSlack 1
# setOptMode -fixCap true -fixTran true -fixFanoutLoad false
# optDesign -postRoute


# report all drc and antenna violations and reroute violated nets
setAnalysisMode -analysisType onChipVariation -cppr both
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -routeInsertDiodeForClockNets true
setNanoRouteMode -routeAntennaCellName "sky130_fd_sc_hd__diode_2"
setNanoRouteMode -drouteEndIteration 1000
# 1st fixing
verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 2nd fixing
verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 3rd fixing
verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 4th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 5th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 6th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 7th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 8th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 9th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 10th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 11th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 12th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 13th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 14th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 15th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 16th fixing
# verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 17th fixing
verifyProcessAntenna
addDiode user_proj_example.antenna.rpt sky130_fd_sc_hd__diode_2
# 18th fixing
verifyProcessAntenna
addDiode user_proj_example.antenna.rpt sky130_fd_sc_hd__diode_2
# delete route blockage to remove drc violation
deleteRouteBlk -name "defLayerBlkName" -layer {met5}
deleteRouteBlk -name "defLayerBlkName" -layer {met5}
deleteRouteBlk -name "defLayerBlkName" -layer {met5}
verify_drc
verifyProcessAntenna