#just in case 
source set_unitcell.tcl
#set_unitcell 57.307   57.307   58.173  top 89.90  90.00  90.10
set_unitcell 114.613  114.613   58.173 top 90.00  90.00  90.00

package require solvate
package require pbctools

mol load psf tudo.psf pdb merged.pdb

set all [atomselect top all]
pbc wrap -center origin
measure minmax $all
set sio [atomselect top "resname SIO"]
measure minmax $sio
solvate tudo.psf merged.pdb -minmax [measure minmax $sio] -s WT -x 0 -y 0 -z 15 +x 0 +y 0 +z 65 -b 3.0

grep CRYST solvate.pdb > tmp1
grep -v END merged.pdb > tmp2
grep WT solvate.pdb > tmp3

cat tmp1 tmp2 tmp3 > tmp.pdb
rm -rf tmp1 tmp2 tmp3
cp solvate.psf tmp.psf

mol load psf tmp.psf pdb tmp.pdb
set deletelist [atomselect top "same residue as water within 3.0 of (not water)"]
$deletelist set beta 9.0
set output [ atomselect top "not beta 9"]
$output writepsf step21.psf
$output writepdb step21.pdb

quit

