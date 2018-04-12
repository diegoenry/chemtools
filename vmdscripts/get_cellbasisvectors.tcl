# Periodic Boundary Conditions
#
# you get the info to make the following from:
 set sel [atomselect top all]
# cell basis vectors:
 set m [measure minmax $sel]
 foreach {j1 j2} $m {}
 foreach {x2 y2 z2} $j2 {}
 foreach {x1 y1 z1} $j1 {}
set x [expr $x2 - $x1]
set y [expr $y2 - $y1]
set z [expr $z2 - $z1]
# cellOrigin:
echo [measure center $sel]
echo $x $y $z

