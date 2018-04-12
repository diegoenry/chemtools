set all [atomselect top all]
source ../programas/vmdscripts/set_unitcell.tcl
set_unitcell 57.307   57.307   58.173  top 89.90  90.00  90.10

#commented lines are not working
#package require pbctools
#pbc readxst step13.xst -alignx
#set cell [pbc get -now]

$all writepdb step14.pdb
