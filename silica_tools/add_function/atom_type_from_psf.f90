subroutine atom_type_from_psf(j)  !psf_name has only character(len=3)
use module_atom_type
integer     :: j

charge=0.0

if ( psf_type(1:1)=="C" )   then
    psf_type="C  "
    mass=12.0110
    ttype(j)=6
endif

!oxygen    
if ( psf_type(1:1)=="O" )   then
    mass=15.9994
    ttype(j)=8
    charge=-0.500
endif

if ( psf_type(1:2)=="Os" )   then 
    mass=15.9994
    ttype(j)=801  !silanol oxygen
    charge=-0.660
endif

if ( psf_type(1:2)=="Ob" )   then
    mass=15.9994
    ttype(j)=802  !bulk oxygen
    charge=-0.450
endif

!hydrogen
if ( psf_type(1:1)=="H" )   then
    mass= 1.0079
    ttype(j)=1 !default
    charge=0.000 ! default
endif
    
if ( psf_type(1:2)=="Hs" )   then
    mass= 1.0079
    ttype(j)=101 !silanol hydrogen
    charge=0.430
endif

if ( psf_type(1:2)=="Si".or.psf_type(1:2)=="SI") then
    mass=28.0855
    ttype(j)=14
    charge=0.900
endif

if ( psf_type(1:2)=="S ") then
    mass=32.0600
    ttype(j)=16
    charge=1.000
endif

return
end