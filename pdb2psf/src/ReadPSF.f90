subroutine ReadPSF(input,output,ReadAtoms,ReadBonds,ReadAngles,ReadDihedrals)
use module_user_interface
use module_quick_pdb
use module_atom_type
integer     :: input
integer     :: output
integer     :: ReadAtoms
integer     :: ReadBonds
integer     :: ReadAngles
integer     :: ReadDihedrals
character(len=72)   :: line

if (ReadAtoms==1) then
    rewind(input)
    line(11:15)="     "
    do while (line(11:15)/="NATOM") ; read(input,"(a72)") line ; enddo ; backspace(input)

    read(input,*) natm

        allocate(ttype(natm))! droga preciso disso
        call psf_header(output,natm)

    do i=1,natm

    read(input,3000) serial,seqid,resSeq,resName,psf_name,psf_type,charge,mass
    write(output,3000) serial,seqid,resSeq,resName,psf_name,psf_type,charge,mass
    if(gmx_out/=" ") write(4,3001) serial,trim(adjustr(psf_type)),serial, &
                     resName,trim(adjustr(name)),serial,charge,mass  !write gromacs top format

    call SetAtomParamFromPSF(i)! droga preciso disso

    enddo
endif

if (ReadBonds==1) then
    rewind(input)
    write(*,"(a)") "Reading bonds from PSF file"
    line(11:15)="     " ;
    do while (line(11:15)/="NBOND") ; read(input,"(a72)") line ; enddo ; backspace(input)
    read(input,*) nbonds
    if(nbonds/=0) then
        allocate( bonds(nbonds*2))
        read(input,*) bonds
    endif
endif

if (ReadAngles==1) then
    rewind(input)
    write(*,"(a)") "Reading angles from PSF file"
    line(11:15)="     " ;
    do while (line(11:15)/="NTHET") ; read(input,"(a72)") line ; enddo ; backspace(input)
    read(input,*) nangles
    if(nangles/=0) then
        allocate( angles(nangles*3))
        read(input,*) angles
    endif
endif

if (ReadDihedrals==1) then
    rewind(input)
    write(*,"(a)") "Reading angles from PSF file"
    line(11:15)="     " ;
    do while (line(11:15)/="NPHI ") ; read(input,"(a72)") line ; enddo ; backspace(input)
    read(input,*) ndihedrals
    if(ndihedrals/=0) then
        allocate( dihedrals(ndihedrals*4))
        read(input,*) dihedrals
    endif
endif

3000    format(i8,a3,i7,1x,a3,2x,a3,2x,a4,1x,f10.6,6x,f8.4)  !psf format mudado
3001    format(i6,7x,a4,2x,i5,4x,a3,3x,a4,2x,i5,3x,f8.3,2x,f9.4) !write gromacs top format

end