#################### SCRIPT FIXPBC.TCL ####################
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

#fix pbc
package require pbctools
pbc wrap -center origin
# para formar o "poro" eh so eliminar o "-center origin" que ele faz por default o "-center unitcell"


#select output group
set all [atomselect top all]

#write output file
$all writepdb step3.pdb
