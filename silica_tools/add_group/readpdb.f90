module module_pdb
integer                 ::  periodic=1
real,dimension(3)       ::  box_size
real,dimension(3)       ::  box_inv
real,allocatable        ::  pos(:,:)
real,allocatable        ::  tempFactor(:)
end module module_pdb


subroutine readpdb
use module_user_interface
use module_atom_type, only    : natm
use module_pdb
character(len=30)               :: line
real                            :: box_abc(3)  ! dgomes Wed Mar  3 15:20:03 BRT 2010
real                            :: occupancy
allocate( tempFactor(natm)  )
allocate( pos(3,natm) )

open(1,file=in)
open(3,file=out)

read(1,"(6x,3f9.3,3f7.2)") box_size, box_abc
write(3,"(a6,3f9.3,3f7.2)") "CRYST1",box_size, box_abc
box_inv = 1/box_size

do i=1,natm
    read(1,1000)  line,pos(:,i),occupancy,tempFactor(i)
    write(3,1000) line,pos(:,i),occupancy,tempFactor(i)
enddo
close(1)
1000    format(a30,3f8.3,f6.2,f6.2)

end
