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