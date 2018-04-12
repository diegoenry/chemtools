! prototipo para substituir a rotina readpsf_bonds
! para ser independente dos modulos.
subroutine  readpsf_bonds (psf_in,nbonds,bonds)
integer, allocatable    ::  bonds
integer                 ::  nbonds
integer                 ::  input=66
character               ::  line*72

open(UNIT=input,file=psf_in)

!bonds
do while (line(11:15)/="NBOND") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) nbonds
if(nbonds/=0) then
    allocate( bonds(nbonds*2))
    read(input,*) bonds
endif
close(input)

return
end

