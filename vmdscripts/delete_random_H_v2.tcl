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

set all     [atomselect top all]
set hydro   [atomselect top "element H or name H"]
set ndel 100
set oldlist [$hydro list]
clear
puts "Building hydrogen list (SLOW for big systems)"
set newlist [shuffle $oldlist]
clear
for {set i 0} {$i <$ndel} {incr i} {
set deletethis [atomselect top "index [lindex $newlist $i]"]
puts "[$deletethis list]"
$deletethis set beta 9.0
}

# create output selection, excluding atoms labeled with beta 9
set output [atomselect top "not beta 9"] 

#writing output
$output writepsf h.psf
$output writepdb h.pdb
