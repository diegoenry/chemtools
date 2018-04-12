!######################################################################
function first_bonded(i)
!######################################################################
use module_atom_type, only : bonds
integer     ::  first_bonded

do j=1,nbonds*2,2
    if(bonds(j)==i) then
        first_bonded=bonds(j+1)
        return
    endif
    if(bonds(j+1)==i) then
        first_bonded=bonds(j)
        return
    endif
    enddo
end


!######################################################################
subroutine rotx(ang,p)
!######################################################################
real,dimension(3)   ::  p
real                ::  x,y,z
real                ::  ang
real                ::  rangle
    rangle=ang2rad(ang)
    x=p(1)
    y=p(2)*cos(rangle) - p(3)*sin(rangle)
    z=p(2)*sin(rangle) + p(3)*cos(rangle)
    p(1)=x
    p(2)=y
    p(3)=z
return    
end

!######################################################################
subroutine roty(ang,p)
!######################################################################
real,dimension(3)   ::  p
real                ::  x,y,z
real                ::  ang
real                ::  rangle
    rangle=ang2rad(ang)
    x=p(3)*sin(rangle) + p(1)*cos(rangle)
    y=p(2)
    z=p(3)*cos(rangle) - p(1)*sin(rangle)
    p(1)=x
    p(2)=y
    p(3)=z
return
end


!######################################################################
subroutine rotz(ang,p)
!######################################################################
real,dimension(3)   ::  p
real                ::  x,y,z
real                ::  ang
real                ::  rangle
    rangle=ang2rad(ang)
    x=p(1)*cos(rangle) - p(2)*sin(rangle)
    y=p(1)*sin(rangle) + p(2)*cos(rangle)
    z=p(3)
    p(1)=x
    p(2)=y
    p(3)=z
return    
end

!######################################################################
function atom_dist(i,j)
!######################################################################
    real,dimension(3) :: i,j,vd
    vd = i - j
    atom_dist = dot_product(vd,vd)
end

!######################################################################
function vector_angle(v1,v2)
!######################################################################
real, dimension(3)  :: v1,v2
real                :: vector_angle
vector_angle=acos(dot_product(v1,v2)/(sqrt(dot_product(v1,v1))*sqrt(dot_product(v2,v2))))
end

!######################################################################
function atom_angle(a1,a2,a3)
!######################################################################
real, dimension(3)  :: a1,a2,a3,v1,v2
real                :: atom_angle
v1=a2-a1
v2=a2-a3
atom_angle=acos(dot_product(v1,v2)/(sqrt(dot_product(v1,v1))*sqrt(dot_product(v2,v2))))
end

!######################################################################
function ang2rad(a)
!######################################################################
real :: a, ang2rad
real    ::  pi
pi=4.0*atan(1.0)
ang2rad=a*(pi/180.0)
end

!######################################################################
function rad2ang(a)
!######################################################################
real :: a, rad2ang
real    ::  pi
pi=4.0*atan(1.0)
rad2ang=a*(180.0/pi)
end
