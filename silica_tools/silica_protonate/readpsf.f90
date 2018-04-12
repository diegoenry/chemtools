module module_atom_type
character(len=3)    ::  psf_name
character(len=3)    ::  psf_type
real                ::  charge
real                ::  mass
integer,allocatable ::  ttype(:)
integer,allocatable ::  bonds(:)
integer             ::  nbonds
integer,allocatable ::  abonds(:)  ! ******* added to module_atom_type
integer             ::  natm       ! ******* added to module_atom_type
!integer,allocatable ::  angles(:)
!integer             ::  nangles
!integer,allocatable ::  dihedrals(:)
!integer             ::  ndihedrals
end

subroutine  readpsf
use module_user_interface
use module_atom_type
character(len=72)       ::      line

open(1,file=psf_in)

!atoms
do while (line(11:15)/="NATOM") ; read(1,"(a72)") line ; enddo
backspace(1)
read(1,*) natm 

allocate ( ttype(natm) ) ; ttype=0

  if(natm/=0) then
     do i=1,natm
      read(1,"(a72)") line
        if(line(30:30)=="H" ) ttype(i)=1
        if(line(30:30)=="O" ) ttype(i)=8
        if(line(30:31)=="SI") ttype(i)=14
     enddo
  endif

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!bonds
 do while (line(11:15)/="NBOND") ; read(1,"(a72)") line ; enddo
 backspace(1)
 read(1,*) nbonds
! 
 if(nbonds/=0) then
     allocate( bonds(nbonds*2))
     read(1,*) bonds
 endif
 
!write tmpbonds
write(66,"(2i8)") bonds

close(1)

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!count nbonds per atom
allocate( abonds(natm)) ; abonds=0
 
do i=1,natm
  do j=1,nbonds*2
    if(i==bonds(j)) abonds(i)=abonds(i)+1
  enddo
enddo

end