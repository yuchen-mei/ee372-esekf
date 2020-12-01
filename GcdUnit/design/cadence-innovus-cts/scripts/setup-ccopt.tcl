#=========================================================================
# setup-ccopt.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 26, 2018

# Allow clock gate cloning and merging

set_ccopt_property clone_clock_gates true
set_ccopt_property clone_clock_logic true
set_ccopt_property ccopt_merge_clock_gates true
set_ccopt_property ccopt_merge_clock_logic true
set_ccopt_property cts_merge_clock_gates true
set_ccopt_property cts_merge_clock_logic true

# Useful skew
#
# setOptMode -usefulSkew [ true | false ]
#
# - This enables/disables all other -usefulSkew* options (e.g.,
#   -usefulSkewCCOpt, -usefulSkewPostRoute, and -usefulSkewPreCTS)
#
# setOptMode -usefulSkewCCOpt [ none | standard | medium | extreme ]
#
# - If setOptMode -usefulSkew is false, then this entire option is ignored
#
# - Connection to "set_ccopt_effort" .. these are the same:
#   - "set_ccopt_effort -low"    and "setOptMode -usefulSkewCCOpt standard"
#   - "set_ccopt_effort -medium" and "setOptMode -usefulSkewCCOpt medium"
#   - "set_ccopt_effort -high"   and "setOptMode -usefulSkewCCOpt extreme"
#

puts "Info: Useful skew = $::env(useful_skew)"
puts "Info: Useful skew ccopt effort = $::env(useful_skew_ccopt_effort)"

if { $::env(useful_skew) } {
  setOptMode -usefulSkew      true
  setOptMode -usefulSkewCCOpt $::env(useful_skew_ccopt_effort)
} else {
  setOptMode -usefulSkew      false
}

set vars(cts_inverter_cells) { sky130_fd_sc_hd__clkinv_1 sky130_fd_sc_hd__clkinv_2 sky130_fd_sc_hd__clkinv_4 sky130_fd_sc_hd__clkinv_8 sky130_fd_sc_hd__clkinv_16 sky130_fd_sc_hd__clkinvlp_2 sky130_fd_sc_hd__clkinvlp_4 }
set vars(cts_buffer_cells) { sky130_fd_sc_hd__clkbuf_1  sky130_fd_sc_hd__clkbuf_2  sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_16 sky130_fd_sc_hd__clkdlybuf4s15_1 sky130_fd_sc_hd__clkdlybuf4s15_2 sky130_fd_sc_hd__clkdlybuf4s18_1 sky130_fd_sc_hd__clkdlybuf4s18_2 sky130_fd_sc_hd__clkdlybuf4s25_1 sky130_fd_sc_hd__clkdlybuf4s25_2  sky130_fd_sc_hd__clkdlybuf4s50_1 sky130_fd_sc_hd__clkdlybuf4s50_2 }
