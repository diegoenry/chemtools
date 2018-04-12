!######################################################################
subroutine atom_type(i,name)
!######################################################################
use module_atom_type
character(len=4)    ::  name
    charge=0.0
    name=trim(adjustl(name))
    psf_name=name(1:3)

if ( name(1:1)=="C" )   then
    psf_type="C  "
    mass=12.0110
    ttype(i)=6
endif
    
if ( name(1:1)=="O" )   then
    psf_type="O  "
    mass=15.9994
    ttype(i)=8
!    charge=-0.500
endif

if ( name(1:1)=="H" )   then
    psf_type="H  "
    mass= 1.0079
    ttype(i)=1
endif
    
if ( name(1:2)=="Si".or.name(1:2)=="SI") then
    psf_type="SI "
    mass=28.0855
    ttype(i)=14
!    charge=1.000
endif

end
