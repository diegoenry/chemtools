!######################################################################
subroutine psf_header(natm)
!######################################################################
write(4,"(a)")"PSF"
write(4,"(a)")
write(4,"(a)")"       1 !NTITLE"
write(4,"(a)")" REMARKS VMD generated structure x-plor psf file"
write(4,"(a)")
write(4,"(i8,a)") natm," !NATOM"
end

!######################################################################
subroutine psf_final(natm)
!######################################################################
!write rest of the PSF file
write(4,"(a)")"       0 !NTHETA: angles"
write(4,*)
write(4,"(a)")"       0 !NPHI: dihedrals"
write(4,*)
write(4,"(a)")"       0 !NIMPHI: impropers"
write(4,*)
write(4,"(a)")"       0 !NDON: donors"
write(4,*)
write(4,"(a)")"       0 !NACC: acceptors"
write(4,*)
write(4,"(a)")"       0 !NNB"
write(4,"(8i8)") (0,j=1,natm)
end

!######################################################################
subroutine  readpsf_bonds
!######################################################################
use module_atom_type
use module_user_interface
integer         ::  input=3
character       ::  line*72
!bonds
do while (line(11:15)/="NBOND") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) nbonds
if(nbonds/=0) then
    allocate( bonds(nbonds*2))
    read(input,*) bonds
endif
close(input)
end
