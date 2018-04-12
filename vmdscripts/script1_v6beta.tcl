#################### SCRIPT STEP1.TCL ####################
# Universidade Federal do Rio de Janeiro    - UFRJ
# Pacific Northwest National Laboratory     - PNNL 
# by:
# Diego E. B. Gomes | UFRJ / PNNL 
# Roberto D. Lins   | PNNL
# Pedro G. Pascutti | UFRJ
# Chenghong Lei     | PNNL
# Thereza A. Soares | PNNL | tasoares@pnl.gov
# 

#just in case 
source /home/dgomes/vmdscripts/set_unitcell.tcl
#surface
set_unitcell 57.307   57.307   58.173  top 89.90  90.00  90.10
#pore
#set_unitcell 171.920  171.920   58.173  top 89.90  90.00  90.10

#create selections 
    set all       [atomselect top all]
    set oxygen    [atomselect top "name O or type O or element O"]
    set silicon   [atomselect top "name SI or name Si or type SI or type Si or element Si"]
    set num_oxygen  [$oxygen num]
    set num_silicon [$silicon num]
#correcting name
    $oxygen     set type    O
    $silicon    set type    SI
#setting charge for the BKS force field
    $oxygen     set charge -1.2
    $silicon    set charge  2.4
#correcting mass
    $oxygen     set mass    15.9994
    $silicon    set mass    28.0855
#find shell atoms
    set gridsz  1                       ; # grid spacing
    set radius  6                       ; # sphere radius 
    set dist    6                       ; # distance from surface
    set shellatoms      [measure surface $all $gridsz $radius $dist] 
    set shell           [atomselect top [concat "index" $shellatoms]]
    set interior        [atomselect top [concat "not index" $shellatoms]]
    set num_shell       [$shell num]
    set num_interior    [$interior num]
#create the shell and interior selections
    puts "Found $num_shell shell atoms"
    puts "Found $num_interior interior atoms" 
#fixing selection !keep this order !
    set fix  $interior
    set free $shell
    $fix  set beta 1
    $free set beta 0

#create list of the dangling atoms on the surface
    set dsi [atomselect top "numbonds < 3 and beta 0 and (name SI or name Si or type SI or type Si or element Si)"]
    set dox [atomselect top "numbonds < 2 and beta 0 and (name O or type O or element O)"]

#check electroneutrality
    set evenodd [expr $num_oxygen %2 ]
    if { $evenodd == 1 } { set num_oxygen [expr $num_oxygen -1 ] }
    set difference [ expr $num_silicon - ($num_oxygen/2) ] ; # TCL rounds up the difference

#adds set selections to exclude from output file.
    if { $difference > 0} { 
        puts "Delete $difference Si"
        set list_to_delete [$dsi get index]
            for {set i 0} {$i < $difference} {incr i} {
                set random [expr int(rand()*[$dsi num])] ; # generate random number within number of dangling silicon atoms 
                set deletethis [atomselect top "index [lindex $list_to_delete $random]"] ; # get the index number of the atom to be deleted 
                puts "Deleting atom index [$deletethis list]"
                $deletethis set beta 9  ;# we assign "9" to bfactor, so latter we won't write this kind of atom to output file.                
            }
            if { $evenodd == 1 } { 
                set list_to_delete [$dox get index]   ; #list of dox
                set random [expr int(rand()*[$dox num])] ; #random number within number of dangling silicon atoms
                set deletethis [atomselect top "index [lindex $list_to_delete $random]"] ; # get the index number of the atom to be deleted 
                puts "Deleting atom index [$deletethis list] (one extra Oxygen to make it even)"
                $deletethis set beta 9  ;# we assign "9" to bfactor, so latter we won't write this kind of atom to output file.                
            }
    }

    if { $difference < 0} { 
        puts "Delete [expr (-1)*($difference)*2] O"
        set difference [expr ((-1)*($difference)*2 )] ; #remove double the of atoms just for oxygen
        set list_to_delete [$dox get index]   ; #list of dox
            for {set i 0} {$i < $difference} {incr i} {
                set random [expr int(rand()*[$dox num])] ; #random number within number of dangling silicon atoms
                set deletethis [atomselect top "index [lindex $list_to_delete $random]"] ; # get the index number of the atom to be deleted 
                puts "Deleting atom index [$deletethis list]"
                $deletethis set beta 9  ;# we assign "9" to bfactor, so latter we won't write this kind of atom to output file.                

            }
            if { $evenodd == 1 } {
                set list_to_delete [$dox get index]   ; #list of dox
                set random [expr int(rand()*[$dox num])] ; #random number within number of dangling silicon atoms
                set deletethis [atomselect top "index [lindex $list_to_delete $random]"] ; # get the index number of the atom to be deleted 
                puts "Deleting atom index [$deletethis list] (one extra Oxygen to make it even)"
                $deletethis set beta 9  ;# we assign "9" to bfactor, so latter we won't write this kind of atom to output file.                
            }
    }

    if { $difference == 0} {
    puts "Great cut ! Your molecule is neutral"
    }

# create output selection, excluding atoms labeled with beta 9
    set output [atomselect top "not beta 9"] 

#writing output
    $output writepsf step1.psf
    $output writepdb step1.pdb
    $output writepdb step1_fixed.pdb
#################### SCRIPT STEP1.TCL ####################
