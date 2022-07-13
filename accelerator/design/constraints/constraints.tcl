#=========================================================================
# Design Constraints File
#=========================================================================

# This constraint sets the target clock period for the chip in
# nanoseconds. Note that the first parameter is the name of the clock
# signal in your verlog design. If you called it something different than
# clk you will need to change this. You should set this constraint
# carefully. If the period is unrealistically small then the tools will
# spend forever trying to meet timing and ultimately fail. If the period
# is too large the tools will have no trouble but you will get a very
# conservative implementation.

set io_clock_net  io_in[37]
set io_clock_name ideal_clock_io

set wb_clock_net  wb_clk_i
set wb_clock_name ideal_clock_wb

create_clock -name ${io_clock_name} -period ${dc_clock_period} [get_ports ${io_clock_net}]
create_clock -name ${wb_clock_name} -period 100 [get_ports ${wb_clock_net}]

set_clock_groups -asynchronous \
                 -group [get_clocks ${io_clock_name}] \
                 -group [get_clocks ${wb_clock_name}]

set_false_path -from [get_ports *in*] -to [get_ports *out*]
set_false_path -from [get_ports *in*] -to [get_ports *oeb*]

# This constraint sets the load capacitance in picofarads of the
# output pins of your design.

set_load -pin_load $ADK_TYPICAL_ON_CHIP_LOAD [all_outputs]

# This constraint sets the input drive strength of the input pins of
# your design. We specify a specific standard cell which models what
# would be driving the inputs. This should usually be a small inverter
# which is reasonable if another block of on-chip logic is driving
# your inputs.

set_driving_cell -no_design_rule \
    -lib_cell $ADK_DRIVING_CELL [all_inputs]

# set_input_delay constraints for input ports
# Make this non-zero to avoid hold buffers on input-registered designs

set_input_delay -clock ${io_clock_name} 10 [get_ports -regexp {(?=io_in)(?!.*37)^.*$}]
set_input_delay -clock ${wb_clock_name} 50 [get_ports -regexp {(?=wb.*i)(?!.*clk)^.*$}]

# set_output_delay constraints for output ports

set_output_delay -clock ${io_clock_name} 10 [get_ports "io_o*"]
set_output_delay -clock ${wb_clock_name} 50 [get_ports "wb*_o"]

set_timing_derate -early [expr {1-0.05}]
set_timing_derate -late [expr {1+0.05}]

set_clock_uncertainty 0.25 [get_clocks ${io_clock_name}]
set_clock_uncertainty 0.25 [get_clocks ${wb_clock_name}]

set_clock_transition 0.15 [get_clocks ${io_clock_name}]
set_clock_transition 0.15 [get_clocks ${wb_clock_name}]

# Make all signals limit their fanout

set_max_fanout 20 $dc_design_name

# Make all signals meet good slew

set_max_transition [expr 0.25*${dc_clock_period}] $dc_design_name

#set_input_transition 1 [all_inputs]
#set_max_transition 10 [all_outputs]

set_optimize_registers true -designs DW_fp_mac_DG_inst_pipe_SIG_WIDTH23_EXP_WIDTH8_IEEE_COMPLIANCE0_NUM_STAGES3
set_optimize_registers true -designs DW_fp_dp4_inst_pipe_SIG_WIDTH23_EXP_WIDTH8_IEEE_COMPLIANCE0_ARCH_TYPE1_NUM_STAGES4
set_optimize_registers true -designs DW_lp_fp_multifunc_DG_inst_pipe_SIG_WIDTH23_EXP_WIDTH8_IEEE_COMPLIANCE0_NUM_STAGES3

set_dont_use [get_lib_cells {*/*probec* }]

set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__probec_p_8]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__probe_p_8]

set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__clkinvlp_2]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__clkinvlp_4]

set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__dlygate4sd1_1]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__dlygate4sd2_1]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__dlygate4sd3_1]

set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__dlymetal6s2s_1]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__dlymetal6s4s_1]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__dlymetal6s6s_1]

set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__buf_16]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow*]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__clkinv_16]

set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__clkdlybuf4s15_1]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__clkdlybuf4s15_2]

set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__clkdlybuf4s18_1]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__clkdlybuf4s18_2]

set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__clkdlybuf4s25_1]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__clkdlybuf4s25_2]

set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__clkdlybuf4s50_1]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__clkdlybuf4s50_2]

set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__and2_0]
set_dont_use [get_lib_cell -quiet sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__and3_1]
