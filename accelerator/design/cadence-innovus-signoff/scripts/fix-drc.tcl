setNanoRouteMode -drouteFixAntenna 0
setNanoRouteMode -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail -viaOpt -wireOpt

# get_db base_cells -if {.num_base_pins == 1}
setAnalysisMode -analysisType onChipVariation -cppr both
setNanoRouteMode -quiet -drouteFixAntenna 1
setNanoRouteMode -quiet -routeInsertAntennaDiode 1
setNanoRouteMode -quiet -routeInsertDiodeForClockNets 1
setNanoRouteMode -quiet -routeAntennaCellName "sky130_fd_sc_hd__diode_2"
setNanoRouteMode -quiet -drouteEndIteration 100
editDelete -regular_wire_with_drc
ecoRoute

setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute

# 2nd fix
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 3rd fix
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 4th fix
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 5th fix
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 6th fix
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 7th fix
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute
# 8th fix
verifyProcessAntenna
editDelete -regular_wire_with_drc
ecoRoute

# delete route blockages that cause drc violations
deleteRouteBlk -name defLayerBlkName -layer met5
