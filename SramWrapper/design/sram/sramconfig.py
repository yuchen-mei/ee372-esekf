# Data word size
word_size = 2
# Number of words in the memory
num_words = 16

# Technology to use in $OPENRAM_TECH
tech_name = "freepdk45"
# Process corners to characterize
process_corners = ["TT"]
# Voltage corners to characterize
supply_voltages = [ 1.1 ]
# Temperature corners to characterize
temperatures = [ 25 ]

# Output directory for the results
output_path = "outputs"
# Output file base name
output_name = "sram"
# Helpful if you have multiple SRAMs
#output_name = "sram_{0}_{1}_{2}".format(word_size,num_words,tech_name)

# Disable analytical models for full characterization (WARNING: slow!)
# analytical_delay = False

# To force this to use calibre for DRC/LVS/PEX
drc_name = "calibre"
lvs_name = "calibre"
pex_name = "calibre"

route_supplies = True
check_lvsdrc = False
# This determines whether LVS and DRC is checked for every submodule.
inline_lvsdrc = False
