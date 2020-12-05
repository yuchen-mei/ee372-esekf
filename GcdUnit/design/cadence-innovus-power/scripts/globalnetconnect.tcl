#=========================================================================
# globalnetconnect.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : January 13, 2020

#-------------------------------------------------------------------------
# Global net connections for PG pins
#-------------------------------------------------------------------------

globalNetConnect VDD    -type pgpin -pin VPWR    -inst * -verbose
globalNetConnect VSS    -type pgpin -pin VGND    -inst * -verbose

# Connect VNW / VPW if any cells have these pins

if { [ lindex [dbGet top.insts.cell.pgterms.name VNW] 0 ] != 0x0 } {
  globalNetConnect VDD    -type pgpin -pin VNW    -inst * -verbose
  globalNetConnect VSS    -type pgpin -pin VPW    -inst * -verbose
}


