# setNanoRouteMode -drouteFixAntenna 0
# setNanoRouteMode -routeWithTimingDriven 1
# setNanoRouteMode -quiet -routeWithSiDriven false
# routeDesign -globalDetail -viaOpt -wireOpt

# setAnalysisMode -analysisType onChipVariation -cppr both
# setNanoRouteMode -quiet -drouteFixAntenna 1
# setNanoRouteMode -quiet -routeInsertAntennaDiode 1
# setNanoRouteMode -quiet -routeAntennaCellName "sky130_fd_sc_hd__diode_2"
# setnanoroutemode -routeInsertDiodeForClockNets true
# setNanoRouteMode -quiet -drouteEndIteration 1000

# editDelete -regular_wire_with_drc
# ecoRoute

# get_db base_cells -if {.num_base_pins == 1}
setAnalysisMode -analysisType onChipVariation -cppr both
setNanoRouteMode -quiet -drouteFixAntenna 1
setNanoRouteMode -quiet -routeInsertAntennaDiode 1
setNanoRouteMode -quiet -routeInsertDiodeForClockNets 1
setNanoRouteMode -quiet -routeAntennaCellName "sky130_fd_sc_hd__diode_2"
setNanoRouteMode -quiet -drouteEndIteration 500
verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# need a second fix
verify_drc
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute

setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute

# setAnalysisMode -analysisType onChipVariation -cppr both
# setNanoRouteMode -quiet -drouteFixAntenna 1
# setNanoRouteMode -quiet -routeInsertAntennaDiode 1
# setNanoRouteMode -quiet -routeInsertDiodeForClockNets 1
# setNanoRouteMode -quiet -routeAntennaCellName "sky130_fd_sc_hd__diode_2"
# setNanoRouteMode -quiet -drouteEndIteration 500
# editDelete -regular_wire_with_drc
# ecoRoute
