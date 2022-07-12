#=========================================================================
# main.tcl
#=========================================================================
# Run the foundation flow step
#
# Author : Christopher Torng
# Date   : January 13, 2020

setOptMode -holdTargetSlack  $::env(hold_target_slack)
setOptMode -setupTargetSlack $::env(setup_target_slack)

source -verbose innovus-foundation-flow/INNOVUS/run_route.tcl


