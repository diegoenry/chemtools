set density 0.046   ; # density of dangling oxigen atoms on a silicon dioxide hydrated surface

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
    $oxygen     set charge  -0.5
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
# One from this file, the other we're gonna add later to the dangling silicons
    set oxygens_needed [expr int($area * $density ) ]
    set do [atomselect top "beta 0 and type O and numbonds < 2 "]
    set num_do [$do num]
    set dsi [atomselect top "beta 0 and type SI and numbonds < 4"]
    set num_dsi [$dsi num]
    set nbonds_to_delete [expr ( $oxygens_needed - $num_do - $num_dsi) / 2 ]

    puts  "Atoms within $dist from vacuum are considered as part of surface."
    puts  "For then, the surface area is: $area"
    puts  " "
    puts  "To match your desired density of $density"
    puts  "You need to delete $nbonds_to_delete bonds"
    puts  " "
    puts  "Please run the 'label_atoms_on_the_very_surface.tcl' before breaking bonds"