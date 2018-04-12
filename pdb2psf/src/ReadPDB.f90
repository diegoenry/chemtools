subroutine ReadPDB
use module_user_interface
use module_quick_pdb
use module_atom_type

 natm=0
 mass=0.0
 charge=0.0
RecordName="      "

do  !count atoms
    read(1,"(a6)",end=10,err=10) RecordName
    if (RecordName=="CRYST1") then
        backspace(1)
        read(1,"(6x,3f9.3)") box_size
    endif
    if (RecordName=="ATOM  ".or.RecordName=="HETATM") natm=natm+1
enddo
10  rewind(1)

do i=1,3 !box dimensions
    if(box_size(i)/=0.0) box_inv(i)=1/box_size(i)
    if(box_size(i)==0.0) box_inv(i)=0
enddo

allocate(pos(3,natm))
allocate(ttype(natm))

!write psf_header
call psf_header(2,natm)

!goto first ATOM record
RecordName="      "
do  ! weird, the do while is not working with two conditions.
   read(1,"(a6)",end=20) RecordName 
    if (RecordName=="ATOM  ".or.RecordName=="HETATM") exit
end do

20 continue
backspace(1)


do  i=1,natm    !read every atom  ! STORING POS()
!read(1,1000,err=20,end=20)                                  &
read(1,1000)                                                &
                RecordName,serial,name,altloc,resName,      &
                chainID,resSeq,iCode,pos(:,i),occupancy,    &
                tempFactor

    if(PreservePSFtype==0) then
        psf_name=adjustl(trim(name)) !len=3
        call SetAtomParam(i)
        !seqid=adjustr(trim(chainID)) !len=3
        write(2,2000) serial," U0",resSeq,resName,psf_name,psf_type,charge,mass
            if(gmx_out/=" ") write(4,3001) serial,trim(adjustr(psf_type)),serial, &
            resName,trim(adjustr(name)),serial,charge,mass  !write gromacs top format
    endif

enddo

1000    format(a6,i5,1x,a4,a1,a3,1x,a1,i4,a1,3x,3f8.3,2f6.2)    !pdb format
2000    format(i8,a3,2x,i4,2x,a3,2x,a3,2x,a3,2x,f10.6,6x,f8.4)  !psf format
3000    format(i8,a3,i7,1x,a3,2x,a3,2x,a4,1x,f10.6,6x,f8.4)  !psf format mudado
3001    format(i6,7x,a4,2x,i5,4x,a3,3x,a4,2x,i5,3x,f8.3,2x,f9.4) !write gromacs top format

end