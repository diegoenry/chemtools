!######################################################################
subroutine init_pdb(input)
!######################################################################
!use module_quick_pdb,only    : natm,RecordName,box_size,box_inv
!natm=0
! write(*,*) "Counting atoms"
use module_quick_pdb,only    : RecordName,box_size,box_inv
integer                     ::  input

do  !count atoms
    read(input,"(a6)",end=10,err=10) RecordName
    if (RecordName=="CRYST1") then
        backspace(input)
        read(input,"(6x,3f9.3)") box_size
    endif
    if (RecordName=="ATOM  ".or.RecordName=="HETATM") then
!    natm=natm+1
    endif
enddo

10  rewind(input)

print*

do i=1,3 !box dimensions
    if(box_size(i)/=0.0) box_inv(i)=1/box_size(i)
    if(box_size(i)==0.0) box_inv(i)=0
enddo

do  !find first "ATOM" record
    read(input,"(a6)") RecordName
    if (RecordName=="ATOM  ".or.RecordName=="HETATM") then
        backspace(input)
        exit
    endif
enddo
end

