#=========================================================================
# main.tcl
#=========================================================================
# Run the foundation flow step
#
# Author : Christopher Torng
# Date   : January 13, 2020

setOptMode -holdTargetSlack  0.050
setOptMode -setupTargetSlack 1.200
source -verbose innovus-foundation-flow/INNOVUS/run_route.tcl


