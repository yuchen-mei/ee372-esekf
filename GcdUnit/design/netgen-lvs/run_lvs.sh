v2lvs -lsp inputs/adk/stdcells.spi -s inputs/adk/stdcells.spi -v inputs/design.lvs.v -o outputs/design.lvs.spice

netgen -batch lvs "inputs/design.extracted.spice $::env(design_name)" "outputs/design.lvs.spice $::env(design_name)" adk/netgen.tcl | tee outputs/lvs_results.log  


