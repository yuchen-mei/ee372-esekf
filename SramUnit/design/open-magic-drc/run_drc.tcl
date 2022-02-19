# To treat SRAM as a blackbox
lef read /farmshare/classes/ee/272/sky130_sram_macros/sky130_sram_1kbyte_1rw1r_32x256_8/sky130_sram_1kbyte_1rw1r_32x256_8.lef

gds noduplicates true
gds ordering true

# Read design
gds read inputs/design_merged.gds
load $::env(design_name)

# Count number of DRC errors
drc catchup
drc count

quit
