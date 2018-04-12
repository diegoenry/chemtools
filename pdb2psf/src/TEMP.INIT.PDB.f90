subroutine init_pdb
use module_quick_pdb,only    : natm,RecordName,box_size,box_inv
natm=0
write(*,*) "Counting atoms"
do  !count atoms
    read(1,"(a6)",end=10,err=10) RecordName
    if (RecordName=="CRYST1") then
        backspace(1)
        read(1,"(6x,3f9.3)") box_size
    endif
    if (RecordName=="ATOM  ".or.RecordName=="HETATM") then
    natm=natm+1
!mac    write(*,"(i8,a,$)") natm,"\r"
    endif
enddo
10  rewind(1)
print*

do i=1,3 !box dimensions
    if(box_size(i)/=0.0) box_inv(i)=1/box_size(i)
    if(box_size(i)==0.0) box_inv(i)=0
enddo

do  !find first "ATOM" record
    read(1,"(a6)") RecordName
    if (RecordName=="ATOM  ".or.RecordName=="HETATM") then
        backspace(1)
        exit
    endif
enddo
end
