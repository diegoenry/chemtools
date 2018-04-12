# Breakbonds
# Breaks random bonds between O-Si
#############################################
# Diego E. B. Gomes(1,2) Roberto D. Lins(2) #
# Pedro G. Pascutti(1), Chenghong Lei(2)    #
# Thereza A. Soares | tasoares@pnl.gov      #
# 1) Universidade Federal do Rio de Janeiro #
# 2) Pacific Northwest National Laboratory  #
#############################################
 proc shuffle {data} {
     set length [llength $data]
     for {} {$length > 1} {incr length -1} {
     set idx_1 [expr {$length - 1}]
     set idx_2 [expr {int($length * rand())}]
     set temp [lindex $data $idx_1]
     lset data $idx_1 [lindex $data $idx_2]
     lset data $idx_2 $temp
     }
     return $data
 }

set density 4.6   ; # density of dangling oxigen atoms on a silicon dioxide hydrated surface

#just in case 
source /msrc/home/dgomes/vmdscripts/set_unitcell.tcl
set_unitcell 171.920  171.920   58.173  top 89.90  90.00  90.10

#create selections 
    set all       [atomselect top all]
    set oxygen    [atomselect top "name O or type O or element O"]
    set silicon   [atomselect top "name SI or name Si or type SI or type Si or element Si or name SI1 SI2 SI3 SI4 SI5"]
    set num_oxygen  [$oxygen num]
    set num_silicon [$silicon num]
#correcting name
    $oxygen     set type    O
    $silicon    set type    SI
#setting charge for the BKS force field
    $oxygen     set charge  0.5
    $silicon    set charge  1.0
#correcting mass
    $oxygen     set mass    15.9994
    $silicon    set mass    28.0855

#find shell atoms on the VERY surface
    set gridsz  1                       ; # grid spacing
    set radius  6                       ; # sphere radius 
    set dist    4                       ; # distance from surface
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

# Calculation of the surface area:
    set area [measure sasa 1.4 $all -restrict $shell]
# How many bonds do we need to delete to get 4.6nm^2 ?
# Every bond we delete exposes TWO oxygens
# One from this file, the other we're gonna add later

    set oxygens_needed [expr int($area * 0.046 ) ]
    set do [atomselect top "beta 0 and type O"]
    set ndo [$do num]
    set dsi [atomselect top "beta 0 and type SI"]
    set ndsi [$dsi num]
    set nbonds_to_delete [expr ( $oxygens_needed - $do - $dsi) / 2 ]
    puts  "We need to delete $nbonds_to_delete bonds"


# How many


#create list of the NON dangling SILICON atoms on the surface (beta 0)
    set ndsi [atomselect top "type SI and beta 0 and numbonds 4"]
    set ndsi_bonds [$ndsi getbonds]
    set ndsi_index [$ndsi get index]

    for {set i 0} {$i < $nbonds_to_delete} {incr i} {
# generate random number within the range of the selection  
        set random [expr int(rand()*[$ndsi num])] 
        set list_to_delete [ lindex $ndsi_bonds $random 1 ] 
        puts "Deleting [ lindex $ndsi_index $random ] $list_to_delete"
        topo delbond [ lindex $ndsi_index $random ] $list_to_delete
    }

    $all writepsf delbond.psf
    $all writepdb delbond.pdb