v2lvs -lsp inputs/adk/stdcells.spi -s inputs/adk/stdcells.spi -v inputs/design.lvs.v -o design_lvs.spice

netgen -batch lvs "inputs/design_extracted.spice GcdUnit" "design_lvs.spice GcdUnit" adk/netgen.tcl | tee outputs/lvs_results.log  


