module module_fgroup
integer                         ::  natm_fgroup
integer                         ::  resid_fgroup
character(len=4),allocatable    ::  name_fgroup(:)
real,allocatable                ::  pos_fgroup(:,:)
integer                         ::  nbonds_fgroup
integer,allocatable             ::  bonds_fgroup(:)
real,allocatable                ::  charges_fgroup(:)
real,allocatable                ::  mass_fgroup(:)
end

module module_quick_pdb
real,dimension(3)   ::  box_size
real,dimension(3)   ::  box_inv
!atom section
character(len=6)    ::  RecordName
integer             ::  serial
character(len=4)    ::  name
character(len=1)    ::  altloc
character(len=3)    ::  resName
character(len=1)    ::  chainID
integer             ::  resSeq
character(len=1)    ::  iCode
!real,dimension(3)   ::  pos !replaces x,y,z
real,allocatable    ::  pos(:,:)
real                ::  occupancy
!real                ::  tempFactor
real,allocatable    ::  tempFactor(:)
integer             ::  natm
integer             ::  lastatm
integer,allocatable ::  final_bonds(:)
integer             ::  lastbond
end

module module_atom_type
character(len=3)    ::  psf_name
character(len=3)    ::  psf_type
real                ::  charge
real                ::  mass
integer,allocatable ::  ttype(:)
integer,allocatable ::  bonds(:)
integer             ::  nbonds
integer,allocatable ::  angles(:)
integer             ::  nangles
integer,allocatable ::  dihedrals(:)
integer             ::  ndihedrals
end

program add_function
use module_user_interface
use module_fgroup
use module_atom_type
use module_quick_pdb
integer,allocatable     ::  abonds(:) !I'll need the number of bonds/atom
integer     ::  opt=0  ! 0 = H and OH, 1 = functional group
integer     ::  rot=1
integer             :: input,output
character(len=72)   :: line

!user interface
call user_interface

open(1,file=in)
open(2,file=out)
open(3,file=psf_in)
open(4,file=psf_out)

!Read .psf 
!count atoms
input=3
output=4
do while (line(11:15)/="NATOM")
    read(input,"(a72)") line 
!    write(output,"(a72)") line  ! I will write this latter because I need the final number of atoms
enddo
backspace(input)
read(input,*) natm

!allocate propertires atom vectors
allocate(ttype(natm))
allocate(pos(3,natm))
allocate(tempFactor(natm))

!read atoms from .psf
do i=1,natm
    read(input,3000) serial,resSeq,resName,psf_name,psf_type,charge,mass
        !(re)assign atom type
!    write(output,2000) serial," U0",resSeq,resName,psf_name,psf_type,charge,mass
        call atom_type_from_psf(i) !Reordered so it will not mess up with the PSF ! 
enddo

!read bonds from .psf
rewind(input)
line(11:15)="     "
do while (line(11:15)/="NBOND") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) nbonds
if(nbonds/=0) then
    allocate( bonds(nbonds*2))
    read(input,*) bonds
endif
!close(input)



!read positions from .pdb
input=1
output=2
call init_pdb(input)
do i=1,natm  !read and write as is
read(input,1000,err=20,end=20)                              &
                RecordName,serial,name,altloc,resName,      &
                chainID,resSeq,iCode,pos(:,i),occupancy,    &
                tempFactor(i)
write(output,1000)                                          &
                RecordName,serial,name,altloc,resName,      &
                chainID,resSeq,iCode,pos(:,i),occupancy,    &
                tempFactor(i)
enddo
20 continue


!stuff for group
resid_fgroup=resSeq+1
resid_fgroup=1
lastatm=natm

! count natms prone to receive group
! we need this to allocate memory to store
! final bonds no matter which group we intend add
allocate(abonds(natm))
abonds=0
do i=1,natm
    if(ttype(i)==801) then                      !notice atomtype 801 is the one to receive the group
        do j=1,nbonds*2
            if(bonds(j)==i) abonds(i)=abonds(i)+1
        enddo
    endif
enddo


!count number of bonds to (n)
n=0
do i=1,natm
    if (abonds(i)==1) n=n+1
!    if (abonds(i)==2) n=n+1     ! ********************* ABONDS=1 IS WHAT WE WANT, THIS IS JUST A TEST
enddo
if(n==0) then
write(*,*) "Could not find any atom to bind groups, did you remove the Hydrogens ?"
STOP
endif

! now let’s see which functional group you have in mind
call read_functional_group
natmfinal = natm + ( natm_fgroup * n )

! Now I can write the PSF output file
call psf_header(natmfinal)
input=3
output=4
rewind(input)
line(11:15)="     "
do while (line(11:15)/="NATOM"); read(input,"(a72)") line ; enddo
do i=1,natm
    read(input,3000) serial,resSeq,resName,psf_name,psf_type,charge,mass
    write(output,2000) serial," U0",resSeq,resName,psf_name,psf_type,charge,mass
enddo


!assign the current bonds to final bonds.
lastbond=nbonds*2
!allocating memory baby
allocate(final_bonds( (lastbond) + ( (nbonds_fgroup+1) *2*n) ))
final_bonds=0
final_bonds(1:nbonds*2)=bonds  ! download previous bonds.

write(*,*) "******************************"
!Finally add functional group
    do i=1,natm
        if(ttype(i)==801.and.abonds(i)==1) then
!        if(ttype(i)==801.and.abonds(i)==2) then     ! ********************* ABONDS=1 IS WHAT WE WANT, THIS IS JUST A TEST
            if(pos(3,i)>=1.20) call rotate_mol(i,0.0)
            if(pos(3,i)<-1.20) call rotate_mol(i,180.0)
            if(pos(3,i)>-1.0.and.pos(3,i)<1.0) then
            write(*,*) "This silica surface is too small, open source code to bypass this routine"
            endif
           ! if(rot==1) call rotate_mol(i,120.0)
        endif
    enddo


write(4,"(i8,a)") lastbond/2," !NBOND: bonds"
write(4,"(8i8)") final_bonds

    CALL psf_final(natm)




1000    format(a6,i5,1x,a4,a1,a3,1x,a1,i4,a1,3x,3f8.3,2f6.2)    !pdb format
2000    format(i8,a3,2x,i5,1x,a3,2x,a3,2x,a3,2x,f10.6,6x,f8.4)  !psf write format
3000    format(i8,3x,2x,i5,1x,a3,2x,a3,2x,a3,2x,f10.6,6x,f8.4)  !psf read format

END
