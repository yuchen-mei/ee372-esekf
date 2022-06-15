# get diode cell name
# get_db base_cells -if {.num_base_pins == 1}


# temporarily turn off antenna fixing and reduce timing optimization
# setNanoRouteMode -drouteFixAntenna 0
# setNanoRouteMode -routeWithTimingDriven 1
# setNanoRouteMode -quiet -routeWithSiDriven false
# routeDesign -globalDetail -viaOpt -wireOpt

# fix drv violations

# setOptMode -fixCap true -fixTran true -fixFanoutLoad false
# setOptMode -drcMargin 0.4
# setOptMode -setupTargetSlack 1
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

