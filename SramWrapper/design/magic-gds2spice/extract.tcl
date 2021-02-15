#gds read inputs/design_merged.gds

lef read rtk-tech.lef
lef read inputs/adk/stdcells.lef

def read design.def

load GcdUnit

#select top cell

#findlabel clk\[0\] 
#port make

#findlabel req_msg\[31\] 
#port make

#findlabel req_msg\[30\] 
#port make

#findlabel req_msg\[29\] 
#port make

#findlabel req_msg\[28\] 
#port make

#findlabel req_msg\[27\] 
#port make

#findlabel req_msg\[26\]
#port make

#findlabel req_msg\[25\]
#port make 

#findlabel req_msg\[24\] 
#port make

#findlabel req_msg\[23\] 
#port make

#findlabel req_msg\[22\] 
#port make

#findlabel req_msg\[21\] 
#port make

#findlabel req_msg\[20\] 
#port make

#findlabel req_msg\[19\]
#port make

#findlabel req_msg\[18\]
#port make 

#findlabel req_msg\[17\] 
#port make

#findlabel req_msg\[16\] 
#port make

#findlabel req_msg\[15\] 
#port make

#findlabel req_msg\[14\] 
#port make

#findlabel req_msg\[13\] 
#port make

#findlabel req_msg\[12\]
#port make

#findlabel req_msg\[11\]
#port make 

#findlabel req_msg\[10\] 
#port make

#findlabel req_msg\[9\] 
#port make

#findlabel req_msg\[8\] 
#port make

#findlabel req_msg\[7\] 
#port make

#findlabel req_msg\[6\] 
#port make

#findlabel req_msg\[5\]
#port make

#findlabel req_msg\[4\]
#port make 

#findlabel req_msg\[3\] 
#port make

#findlabel req_msg\[2\] 
#port make

#findlabel req_msg\[1\]
#port make

#findlabel req_msg\[0\]
#port make 

#findlabel req_rdy\[0\] 
#port make

#findlabel req_val\[0\]
#port make

#findlabel reset\[0\]
#port make

#findlabel resp_msg\[15\] 
#port make

#findlabel resp_msg\[14\] 
#port make

#findlabel resp_msg\[13\] 
#port make

#findlabel resp_msg\[12\] 
#port make

#findlabel resp_msg\[11\] 
#port make

#findlabel resp_msg\[10\] 
#port make

#findlabel resp_msg\[9\] 
#port make

#findlabel resp_msg\[8\] 
#port make

#findlabel resp_msg\[7\] 
#port make

#findlabel resp_msg\[6\] 
#port make

#findlabel resp_msg\[5\] 
#port make

#findlabel resp_msg\[4\] 
#port make

#findlabel resp_msg\[3\] 
#port make

#findlabel resp_msg\[2\] 
#port make

#findlabel resp_msg\[1\] 
#port make

#findlabel resp_msg\[0\] 
#port make

#findlabel resp_rdy\[0\]
#port make

#findlabel resp_val\[0\]
#port make

#findlabel VSS 
#port make

#findlabel VDD
#port make

#save design.mag

# Extract for LVS
#extract all
extract do local
extract no capacitance
extract no coupling
extract no resisitance
extract no adjust
extract unique
extract
ext2spice lvs
ext2spice subcircuit on
#ext2spice subcircuit off
ext2spice subcircuit top on
ext2spice -o outputs/design_extracted.spice

quit
