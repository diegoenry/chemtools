!######################################################################
subroutine quick_read_pdb
!######################################################################
use module_quick_pdb
use module_atom_type

    ALLOCATE(pos(3,natm))
    ALLOCATE(ttype(natm))
    ALLOCATE(tempFactor(natm))
write(*,*) "Writing PSF atoms :"
do  i=1,natm    !read every atom  ! STORING POS()
read(1,1000,err=20,end=20)                                  &
                RecordName,serial,name,altloc,resName,      &
                chainID,resSeq,iCode,pos(:,i),occupancy,    &
                tempFactor(i)
!                tempFactor !using as vector today :)

!put your function here /start
    CALL atom_type(i,name)
!mac    write(*,"(i8,a,$)") serial,"\r"
    WRITE(4,2000) serial," U0",resSeq,resName,psf_name,psf_type,charge,mass
!put your IF here /end
enddo

20  print*  
    print*, " :) Thank you for using quick_pdb :) "

1000    format(a6,i5,1x,a4,a1,a3,1x,a1,i4,a1,3x,3f8.3,2f6.2)    !pdb format
2000    format(i8,a3,2x,i4,2x,a3,2x,a3,2x,a3,2x,f10.6,6x,f8.4)  !psf format
end
