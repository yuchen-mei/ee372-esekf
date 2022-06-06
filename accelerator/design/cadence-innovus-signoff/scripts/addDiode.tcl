# This script attaches diodes to the pins with violations in $antennaFile.

# The antenna violation report can be generated using verifyProcessAntenna. 
# 

proc addDiode {antennaFile antennaCell} {

    unlogCommand dbGet 
    if [catch {open $antennaFile r} fileId] { 
        puts stderr "Cannot open $antennaFile: $fileId" 
    } else { 
        foreach line [split [read $fileId] \n] { 
            # Search for lines matching "instName (cellName) pinName" that have violations 
            if {[regexp {^ (\S+) (\S+) (\S+)} $line] == 1} { 
                # Remove extra white space 
                regsub -all -- {[[:space:]]+} $line " " line 
                set line [string trimlef $line] 
                # Store instance and pin name to insert diodes on 
                set instName [lindex [split $line] 0] 
                # Modify instance name if it contains escaped characters:
                set escapedInstName "" 
                foreach hier [split $instName /] {
                    if {[regexp {\[|\]|\.} $hier] == 1} {
                        set hier "\\$hier "
                    } 
                    set escapedInstName "$escapedInstName$hier/" 
                    set instName $escapedInstName
                } 
                regsub {/$} $instName {} instName 
                set pinName [lindex [split $line] 2] 
                set instPtr [dbGet -p top.insts.name $instName] 
                set instLoc [lindex [dbGet $instPtr.pt] 0]
                if {$instName != ""} {
                    # Attach diode and place at location of instance 
                    attachDiode -diodeCell $antennaCell -pin $instName $pinName -loc $instLoc
                }
            }
        }
    } 
    close $fileId 
    # Legalize placement of diodes and run ecoRoute to route them 
    refinePlace -preserveRouting true 
    ecoRoute 
    logCommand dbGet
}