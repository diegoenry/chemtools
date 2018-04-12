subroutine GenerateTopology
use module_user_interface
use module_atom_type
use module_quick_pdb
character(len=72)       :: line
nbonds=0
nangles=0
ndihedrals=0

if(psf_in/=" ".and.calc_bonds==0) then
    print*, "Reading bonds from PSF file"
    call ReadPSF(3,2,0,1,0,0) ! (input,output,ReadAtoms,ReadBonds,ReadAngles,ReadDihedrals)
endif

if(calc_bonds==1)   then
    print*, "Computing bonds from distance search "
    if(periodic==0) call gen_bonds_nopbc(distance_cutoff)
    if(periodic==1.and.sio==0) call gen_bonds(distance_cutoff)
    if(periodic==1.and.sio==1) call gen_bonds_SIO(distance_cutoff)
endif

if(calc_angles==1) then
    if(nbonds==0) then 
	print*, "Couldn't find any bonds, stopping program"
	stop
    endif
    if(sio==0) call gen_angles
    if(sio==1) call gen_angles_SIO
endif

end