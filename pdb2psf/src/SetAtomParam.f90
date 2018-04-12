! This routine must be replaced by a parser to read CHARMM .top files

subroutine SetAtomParam(i)  !psf_name has only character(len=3
use module_atom_type

    psf_type="   "
    mass=0.0
    ttype(i)=1
    charge=0.000

if ( psf_name(1:1)=="C" )   then
    psf_type="C   "
    mass=12.0110
    ttype(i)=6
    charge=0.000
endif

!oxygen
if ( psf_name(1:1)=="O" )   then
    psf_type="O   "
    mass=15.9994
    ttype(i)=8
    charge=-0.500
endif

if ( psf_name(1:2)=="Os" )   then 
    psf_type="Os  "
    mass=15.9994
    ttype(i)=801  !silanol oxygen
    charge=-0.660
endif

if ( psf_name(1:2)=="Ob" )   then
    psf_type="Ob  "
    mass=15.9994
    ttype(i)=802  !bulk oxygen
    charge=-0.450
endif

!hydrogen
if ( psf_name(1:2)=="H " )   then
    psf_type="H   "
    mass= 1.0080
    ttype(i)=1 !default
!    charge=0.000 ! default
endif

if ( psf_name(1:2)=="Hs" )   then
    psf_type="Hs  "
    mass= 1.0079
    ttype(i)=101 !silanol hydrogen
    charge=0.430
endif

if ( psf_name(1:2)=="Si".or.psf_name(1:2)=="SI") then
    psf_type="SI  "
    mass=28.0855
    ttype(i)=14
    charge=0.900
endif

if ( psf_name(1:2)=="S ") then
    psf_type="S   "
    mass=32.0600
    ttype(i)=16
    charge=1.000
endif

! functional group atoms
if ( psf_name(1:3)=="CT2" )   then
    psf_type="CT2 "
    mass=12.0110
    ttype(i)=601
endif

if ( psf_name(1:3)=="CD" )   then
    psf_type="CD  "
    mass=12.0110
    ttype(i)=603
endif

if ( psf_name(1:2)=="HA" )   then
    psf_type="HA  "
    mass=1.0080
!    ttype(i)=104
    ttype(i)=1
endif

if ( psf_name(1:2)=="OB" )   then
    psf_type="OB  "
    mass=15.9994
    ttype(i)=811
endif

if ( psf_name(1:3)=="OH1" )   then
    psf_type="OH1 "
    mass=15.9994
    ttype(i)=812
endif

if (psf_name(1:3)=="NH3") then
    psf_type="NH3"
    mass=14.007000
    ttype(i)=901
endif

if ( psf_name(1:2)=="HC" )   then
    psf_type="HC  "
    mass= 1.0079
    ttype(i)=1
    charge=0.430
endif

end

