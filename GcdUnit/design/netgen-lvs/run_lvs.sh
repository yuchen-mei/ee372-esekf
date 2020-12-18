#sed -i 's/.VGND(VSS)/.VGND(VSS), .VPB(VPB), .VNB(VNB)/g' inputs/design.lvs.v
#sed -i 's/inout VSS;/inout VSS; inout VPB; inout VNB;/g' inputs/design.lvs.v

v2lvs -i -lsp inputs/adk/stdcells.spi -s inputs/adk/stdcells.spi -v inputs/design.lvs.v -o design_lvs.spice

netgen -batch lvs "inputs/design_extracted.spice GcdUnit" "design_lvs.spice GcdUnit" adk/netgen.tcl | tee outputs/lvs_results.log  


