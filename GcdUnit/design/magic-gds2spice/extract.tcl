#gds read inputs/design_merged.gds

lef read rtk-tech.lef
lef read inputs/adk/stdcells.lef

def read design.def
load $::env(design_name)

# Extract for LVS
extract all
ext2spice lvs
ext2spice subcircuit off
ext2spice subcircuit top on
ext2spice -o outputs/design_extracted.spice

quit
