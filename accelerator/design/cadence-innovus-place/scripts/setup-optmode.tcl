#=========================================================================
# setup-optmode.tcl
#=========================================================================
# Useful knobs for setOptMode
#
# Author : Christopher Torng
# Date   : May 15, 2020

# Useful skew
#
# setOptMode -usefulSkew [ true | false ]
#
# - This enables/disables all other -usefulSkew* options (e.g.,
#   -usefulSkewCCOpt, -usefulSkewPostRoute, and -usefulSkewPreCTS)
#
# setOptMode -usefulSkewPreCTS [ true | false ]
#
# - If setOptMode -usefulSkew is false, then this entire option is ignored
#

puts "Info: Useful skew = $::env(useful_skew)"

if { $::env(useful_skew) } {
  setOptMode -usefulSkew       true
  setOptMode -usefulSkewPreCTS true
} else {
  setOptMode -usefulSkew      false
}

setOptMode -holdTargetSlack  $::env(hold_target_slack)
setOptMode -setupTargetSlack $::env(setup_target_slack)

setOptMode -drcMargin        0.3
setOptMode -fixCap true
setOptMode -fixTran true
setOptMode -bufferAssignNets true

# setOptMode -fixDRC
# setOptMode -fixFanoutLoad true
# optDesign -preCTS -drv
# optDesign -preCTS

assignPtnPin