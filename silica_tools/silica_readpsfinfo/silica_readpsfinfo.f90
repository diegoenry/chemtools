!# readpsfinfo
!# reads two .psf files
!# gets ONLY atomtype from first and changes on second.
!# this version is designed to read a FIST.psf without water
!# and MERGE with a newly generated .pdb WITH water
!# THE SECOND .PSF must NOT have the bonds from FIRST .psf
!
! PLEASE NOTICE WHAT I DID FOR merge_psfdihedrals.
!

module module_atom_type
!character(len=3)    ::  seqid
character(len=4)    ::  seqid
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
real                ::  tempFactor
integer             ::  natm
end

program mergepsf
character(len=72)       :: line
character(len=72)       :: file1,file2,file3

! user interface
call system('ls |grep "\.psf"')
write(*,*) "Type name of first file"
read(*,"(a)") file1
write(*,*) "Type name of second file"
read(*,"(a)") file2

open(1,file=file1)
open(2,file=file2)
open(3,file="mergedstructure.psf")


!what to do.
merge_bonds     =1
merge_angles    =1
merge_dihedrals =1

call merge_psfatoms(1,2,3,natm) !total number of atoms will come from second file.

if(merge_bonds/=0) then
        call merge_psfbonds(1,2,3)
        else
        write(3,"(i8,a)") 0," !NBOND: bonds"
endif


 if(merge_angles/=0) then
         call merge_psfangles(1,2,3)
         else
         write(3,"(i8,a)") 0," !NTHETA: angles"
 endif

 if(merge_dihedrals/=0) then
         call merge_psfdihedrals(1,2,3)
         else
         write(3,"(i8,a)") 0," !NPHI: dihedrals"
 endif

call psf_final(natm,3)

write(*,*) "Merged structure written to 'mergedstructure.psf'"
END

subroutine merge_psfatoms(input1,input2,output,natm_2) !total number of atoms will come from second file.
use module_atom_type
use module_quick_pdb
integer                 :: input1,input2,output,natm_1,natm_2
character(len=72)       :: line
character(len=3)        :: NOT_psf_type
real                    :: NOT_charge,NOT_mass

input=input1
rewind(input)
line(11:15) ="     "
do while (line(11:15)/="NATOM") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) natm_1

input=input2
rewind(input)
line(11:15) ="     "
do while (line(11:15)/="NATOM") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) natm_2

call psf_header(natm_2,3)

do i=1,natm_1
!notice that I'll be replacing some info on the output file, on variables with a big "NOT_"
read(input1,3000)  not_serial,not_seqid,not_resSeq,not_resName,not_psf_name,psf_type,charge,mass
read(input2,3000)  serial,seqid,resSeq,resName,psf_name,NOT_psf_type,NOT_charge,NOT_mass
write(output,3000) serial,seqid,resSeq,resName,psf_name,psf_type,charge,mass
enddo

do i=natm_1+1,natm_2
read(input2,3000)  serial,seqid,resSeq,resName,psf_name,psf_type,charge,mass
write(output,3000) serial,seqid,resSeq,resName,psf_name,psf_type,charge,mass
enddo

!3000    format(i8,a3,2x,i4,2x,a3,2x,a3,2x,a3,2x,f10.6,6x,f8.4)  !psf format
!3000    format(i8,a3,i7,1x,a3,2x,a3,2x,a3,2x,f10.6,6x,f8.4)  !psf format mudado
3000    format(i8,a4,i6,1x,a3,2x,a3,2x,a3,2x,f10.6,6x,f8.4)  !psf format mudado

return !will return natm to main program
end

subroutine merge_psfbonds(input1,input2,output)
integer                 :: input1,input2,output
integer,allocatable     :: bonds_1(:)
integer,allocatable     :: bonds_2(:)
integer,allocatable     :: all_bonds(:)
integer                 :: nbonds_1,nbonds_2
character(len=72)       :: line

!read from input 1
input=input1
rewind(input)
line(11:15)="     "
do while (line(11:15)/="NBOND") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) nbonds_1
if(nbonds_1/=0) then
    allocate( bonds_1(nbonds_1*2))
    read(input,*) bonds_1
endif

!read from input 2
input=input2
rewind(input)
line(11:15)="     "
do while (line(11:15)/="NBOND") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) nbonds_2
if(nbonds_2/=0) then
    allocate( bonds_2(nbonds_2*2))
    read(input,*) bonds_2
endif

!merge bonds to a new psf
ntotalbonds=nbonds_1+nbonds_2 
allocate( all_bonds( ntotalbonds*2 ) )
all_bonds(1:nbonds_1*2) = bonds_1
all_bonds(nbonds_1*2+1:ntotalbonds) = bonds_2

write(output,"(i8,a)") ntotalbonds," !NBOND: bonds"
write(output,"(8i8)") all_bonds

deallocate(bonds_1)
deallocate(bonds_2)
deallocate(all_bonds)

end


subroutine merge_psfangles(input1,input2,output)
integer                 :: input1,input2,output
integer,allocatable     :: angles_1(:)
integer,allocatable     :: angles_2(:)
integer,allocatable     :: all_angles(:)
integer                 :: nangles_1,nangles_2
character(len=72)       :: line

!read from input 1
input=input1
rewind(input)
line(11:15)="     "
do while (line(11:15)/="NTHET") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) nangles_1
if(nangles_1/=0) then
    allocate( angles_1(nangles_1*3))
    read(input,*) angles_1
endif

!read from input 2
input=input2
rewind(input)
line(11:15)="     "
do while (line(11:15)/="NTHET") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) nangles_2
if(nangles_2/=0) then
    allocate( angles_2(nangles_2*3))
    read(input,*) angles_2
endif

!merge angles to a new psf
ntotalangles=nangles_1+nangles_2 
allocate( all_angles( ntotalangles*3 ) )
all_angles(1:nangles_1*3) = angles_1
all_angles(nangles_1*3+1:ntotalangles) = angles_2

write(output,"(i8,a)") ntotalangles," !NTHETA: angles"
!write(output,"(8i8)") all_angles
write(output,"(9i8)") all_angles

if(nagles_1/=0) deallocate(angles_1)
if(nagles_2/=0) deallocate(angles_2)
deallocate(all_angles)

end



subroutine merge_psfdihedrals(input1,input2,output)
integer                 :: input1,input2,output
integer,allocatable     :: dihedrals_1(:)
integer,allocatable     :: dihedrals_2(:)
integer,allocatable     :: all_dihedrals(:)
integer                 :: ndihedrals_1,ndihedrals_2
character(len=72)       :: line

!read from input 1
input=input1
rewind(input)
line(11:15)="     "
do while (line(11:14)/="NPHI") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) ndihedrals_1
if(ndihedrals_1/=0) then
    allocate( dihedrals_1(ndihedrals_1*4))
    read(input,*) dihedrals_1
endif

!read from input 2
input=input2
rewind(input)
line(11:15)="     "
do while (line(11:14)/="NPHI") ; read(input,"(a72)") line ; enddo
backspace(input)
read(input,*) ndihedrals_2
if(ndihedrals_2/=0) then
    allocate( dihedrals_2(ndihedrals_2*4))
    read(input,*) dihedrals_2
endif


!merge dihedrals to a new psf
ntotaldihedrals=ndihedrals_1+ndihedrals_2

if(ntotaldihedrals/=0) then !this should cover the errors, I must fix this for bonds and angles.
        allocate( all_dihedrals( ntotaldihedrals*4 ) )
        if (ndihedrals_1/=0) then
                all_dihedrals(1:ndihedrals_1*4) = dihedrals_1
        endif
        if (ndihedrals_2/=0) then
                all_dihedrals(ndihedrals_1*4+1:ntotaldihedrals) = dihedrals_2
        endif
endif

write(output,"(i8,a)") ntotaldihedrals," !NPHI: dihedrals"
write(output,"(8i8)") all_dihedrals

if(ndihedrals_1/=0)    deallocate(dihedrals_1)
if(ndihedrals_2/=0)    deallocate(dihedrals_2)
if(ntotaldihedrals/=0) deallocate(all_dihedrals)

end




subroutine psf_header(natm,output)
integer         :: natm,output
write(output,"(a)")"PSF"
write(output,"(a)")
write(output,"(a)")"       1 !NTITLE"
write(output,"(a)")" REMARKS VMD generated structure x-plor psf file"
write(output,"(a)")
write(output,"(i8,a)") natm," !NATOM"
end

subroutine psf_final(natm,output)
integer         :: natm,output
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
