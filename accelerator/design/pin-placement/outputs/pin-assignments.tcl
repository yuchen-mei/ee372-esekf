#=========================================================================
# pin-assignments.tcl
#=========================================================================
# The ports of this design become physical pins along the perimeter of the
# design. The commands below will spread the pins along the left and right
# perimeters of the core area. This will work for most designs, but a
# detail-oriented project should customize or replace this section.
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Pin Assignments
#-------------------------------------------------------------------------

# Here pin assignments are done keeping in mind the location of the SRAM pins
# If you update pin assignments below you should rerun the pin-placement step 
# before re-running init step

# We are assigning pins clockwise here, starting from the top side we go left
# to right, then on the right side we go top to bottom, then on the bottom
# side, we go right to left, then on the left side we go bottom to top.

# Pins on the top side. The first pin in this list (here dout1[31]) is on the
# top left and the last pin is on the top right.

set pins_top {\
}

# Pins on the right side. In this example we are not placing pins on the right
# side, since we haven't routed out the pins on the right side of the SRAM. In
# your design, you can use the right side as well.

set pins_right {\
  {input_data[7]}     {input_data[8]}     {input_data[9]}    {input_data[10]}    {input_data[11]}    {input_data[12]} \
  {input_data[13]}    {input_data[14]}    {input_data[15]} \
}

# Pins on the bottom side from right (dout0[0]) to left (din0[31]). I list pins
# out explicitly here because the dout0 and din0 pins on the SRAM macro are
# interleaved somewhat randomly, but if in your case the pins of the same bus
# are to be kept together then you can generate this pin list using a tcl for
# loop.

# set pins_bottom {\         
# }

# Pins on the left side from bottom (rst_n) to top (addr0[0]).

set pins_left {\
  clk                input_rdy          rst_n              output_vld         input_vld           {output_data[0]} \
  output_rdy         {output_data[1]}   {input_data[0]}    {output_data[2]}   {input_data[1]}     {output_data[3]} \
  {input_data[2]}    {output_data[4]}   {input_data[3]}    {output_data[5]}   {input_data[4]}     {output_data[6]} \
  {input_data[5]}    {output_data[7]}   {input_data[6]} \
}

# Spread the pins evenly along the sides of the block

editPin -layer met3 -pin $pins_right  -side RIGHT  -spreadType SIDE
editPin -layer met3 -pin $pins_left   -side LEFT   -spreadType SIDE
# editPin -layer met2 -pin $pins_bottom -side BOTTOM -spreadType SIDE
# editPin -layer met2 -pin $pins_top    -side TOP    -spreadType SIDE

