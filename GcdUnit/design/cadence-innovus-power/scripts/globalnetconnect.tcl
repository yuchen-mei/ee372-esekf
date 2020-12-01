#=========================================================================
# globalnetconnect.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : January 13, 2020

#-------------------------------------------------------------------------
# Global net connections for PG pins
#-------------------------------------------------------------------------
if { [ lindex [dbGet top.insts.cell.pgterms.name VDD] 0 ] != 0x0 } {
  globalNetConnect VDD    -type pgpin -pin VDD    -inst * -verbose
  globalNetConnect VSS    -type pgpin -pin VSS    -inst * -verbose
}

# Connect VNW / VPW if any cells have these pins

if { [ lindex [dbGet top.insts.cell.pgterms.name VNW] 0 ] != 0x0 } {
  globalNetConnect VDD    -type pgpin -pin VNW    -inst * -verbose
  globalNetConnect VSS    -type pgpin -pin VPW    -inst * -verbose
}

if { [ lindex [dbGet top.insts.cell.pgterms.name VPWR] 0 ] != 0x0 } {
  globalNetConnect VDD    -type pgpin -pin VPWR    -inst * -verbose
}

if { [ lindex [dbGet top.insts.cell.pgterms.name VGND] 0 ] != 0x0 } {
  globalNetConnect VSS    -type pgpin -pin VGND    -inst * -verbose
}


