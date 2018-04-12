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
source /msrc/home/dgomes/vmdscripts/set_unitcell.tcl
#set_unitcell 171.920  171.920   58.173  top 89.90  90.00  90.10
set_unitcell 57.307   57.307   58.173  top 89.90  90.00  90.10

#create selections 
    set all       [atomselect top all]
    set oxygen    [atomselect top "name O or type O or element O or name O1 O2 O3 O4 O5 O6 O7 O8 "]
    set silicon   [atomselect top "name SI or name Si or type SI or type Si or element Si or name SI1 SI2 SI3 SI4"]
    set hydrogen  [atomselect top "name H or type H or element H or name H H1 "]
    set num_oxygen  [$oxygen num]
    set num_silicon [$silicon num]
#correcting name
    $all        set segname U0
    $oxygen     set type    O
    $silicon    set type    SI
    $hydrogen   set type    H
    $oxygen     set element O
    $silicon    set element Si
    $hydrogen   set element H

#setting charge for the BKS force field
    $oxygen     set charge -0.5
    $silicon    set charge  1.0
    $hydrogen   set charge  0.0
#correcting mass
    $oxygen     set mass    15.9994
    $silicon    set mass    28.0855
    $hydrogen   set mass     1.0079
#find shell atoms
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
#writing output
    set output $all
    $output writepsf aews.psf
    $output writepdb aews.pdb
    $output writepdb aews_fixed.pdb
