subroutine WritePSF(output) !(output,WriteAtoms,WriteBonds,WriteAngles,WriteDihedrals)
use module_quick_pdb
use module_atom_type
integer     :: output
!integer     :: WriteAtoms
!integer     :: WriteBonds
!integer     :: WriteAngles
!integer     :: WriteDihedrals

! Nao armazenei os ATOMS, veja-os no ReadPDB, e no ReadPSF

write(output,*)
write(output,"(i8,a)") nbonds," !NBOND: bonds"
if(nbonds/=0) write(output,"(8i8)"), bonds(1:nbonds*2)

write(output,*)
write(output,"(i8,a)")nangles," !NTHETA: angles"
if(nangles/=0) write(output,"(9i8)"), angles(1:nangles*3)

write(output,*)
write(output,"(i8,a)") ndihedrals," !NPHI: dihedrals"
if(ndihedrals/=0) write(output,"(8i8)"), dihedrals(1:ndihedrals*4)

write(output,*)
write(output,"(a)")"       0 !NIMPHI: impropers"

write(output,*)
write(output,"(a)")"       0 !NDON: donors"

write(output,*)
write(output,"(a)")"       0 !NACC: acceptors"

write(output,*)
write(output,"(a)")"       0 !NNB"
write(output,"(8i8)") (0,j=1,natm)

end

subroutine psf_header(output,natm)
integer     :: output
write(output,"(a)")"PSF"
write(output,"(a)")
write(output,"(a)")"       1 !NTITLE"
write(output,"(a)")" REMARKS VMD generated structure x-plor psf file"
write(output,"(a)")
write(output,"(i8,a)") natm," !NATOM"
end

subroutine psf_final(output,natm)
integer     :: output
!write rest of the PSF file
write(output,"(a)")"       0 !NIMPHI: impropers"
write(output,*)
write(output,"(a)")"       0 !NDON: donors"
write(output,*)
write(output,"(a)")"       0 !NACC: acceptors"
write(output,*)
write(output,"(a)")"       0 !NNB"
write(output,"(8i8)") (0,j=1,natm)
end