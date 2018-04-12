module colors
implicit none
character       ::  red*5
character       ::  green*5
character       ::  blue*5
character       ::  normal*5
character       ::  underline*4
contains
    subroutine setcolors
        red=char(27)//"[31m" 
        green=char(27)//"[32m"
        blue=char(27)//"[34m"
        normal=char(27)//"[0m" 
        underline=char(27)//"[4m"
    end subroutine
end module colors

module module_user_interface
character       ::  pdb_in*30
character       ::  psf_out*30
character       ::  psf_in*30
character       ::  argv*30
character       ::  gmx_out*30
!program specific variables
integer         ::  calc_bonds      ! integer
integer         ::  calc_angles     ! integer
integer         ::  calc_dihedrals  ! integer
integer         ::  periodic_z      ! integer
real            ::  distance_cutoff ! real number
integer         ::  periodic
integer         ::  sio
integer         ::  KeepPSFtype         ! keep psf names
contains
    subroutine init_variables
        pdb_in=" "
        psf_out=" "
        psf_in=" "
        gmx_out=" "
        calc_bonds=0
        calc_angles=0
        calc_dihedrals=0
        distance_cutoff=1.8
        periodic=1
        sio=1
        KeepPSFtype=0
    end subroutine
end module

module module_quick_pdb
real,dimension(3)   ::  box_size
real,dimension(3)   ::  box_inv
!atom section
character(len=6)    ::  RecordName
integer                  ::  serial
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

module module_atom_type
character(len=3)    ::  psf_name
!character(len=3)    ::  psf_type
character(len=4)    ::  psf_type
character(len=3)    ::  seqid
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
