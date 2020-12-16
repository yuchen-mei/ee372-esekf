gds read inputs/design_merged.gds
load $::env(design_name)

# Extract for LVS
extract all
ext2spice lvs
ext2spice subcircuits off
ext2spice -o outputs/design_extracted.spice

quit
