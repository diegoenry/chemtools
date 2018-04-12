program mergepsf
integer,allocatable  :: bonds_1(:)
integer,allocatable  :: bonds_2(:)
integer,allocatable  :: all_bonds(:)
integer             :: nbonds_1,nbonds_2
character(len=72)       :: line


!read from input 1
open(1,file="fms.sio.psf")
input=1
do while (line(11:15)/="NBOND") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) nbonds_1
if(nbonds_1/=0) then
    allocate( bonds_1(nbonds_1*2))
    read(input,*) bonds_1
endif
close(input)

!reset search term
line(11:15)="12345"

!read from input 2
open(1,file="solvate.psf")
input=1
do while (line(11:15)/="NBOND") ; read(input,"(a72)") line ; enddo
backspace(input)
write(*,*) line
read(input,"(i9)") nbonds_2
if(nbonds_2/=0) then
    allocate( bonds_2(nbonds_2*2))
    read(input,*) bonds_2
endif
close(input)

!merge
ntotalbonds=nbonds_1*2+nbonds_2*2 
allocate( all_bonds( ntotalbonds ) )
all_bonds(1:nbonds_1*2) = bonds_1
all_bonds(nbonds_1*2+1:ntotalbonds) = bonds_2

write(*,"(8i8)") all_bonds
END