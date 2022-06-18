#=========================================================================
# main.tcl
#=========================================================================
# Run the foundation flow step
#
# Author : Christopher Torng
# Date   : January 13, 2020

setOptMode -holdTargetSlack  2
setOptMode -setupTargetSlack 2
source -verbose innovus-foundation-flow/INNOVUS/run_route.tcl


