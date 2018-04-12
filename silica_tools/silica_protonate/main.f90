program silicaprotonate
use module_user_interface

call user_interface

open(66,file="tmpbonds.dat")
call readpsf
call readpdb
call add
close(66)
call writepsfbonds

end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Functions
function ang2rad(a)
real :: a, ang2rad
ang2rad=a*(3.14159265/180.0)
end

function rad2ang(a)
real :: a, rad2ang
rad2ang=a*(180.0/3.14159265)
end

function angle(v1,v2)
real, dimension(3) :: v1,v2
real                            :: angle
angle=acos(dot_product(v1,v2)/(sqrt(dot_product(v1,v1))*sqrt(dot_product(v2,v2))))
end

!program bonsgmx2charmm
subroutine writepsfbonds
use module_user_interface
    integer,allocatable      :: bonds(:)
    integer                  :: n
    integer                  :: i
    call system("rm tmp")
    call system("wc -l tmpbonds.dat>tmp")
    open(1,file="tmp")
    read(1,*) n
    open(2,file="tmpbonds.dat")
    open(3,file=psf_out)
    n=n*2
    allocate (bonds(n))

    do i=1,n,2
    read(2,*) bonds(i),bonds(i+1)
    enddo
    write(3,"(i8,a)") (n/2), " !NBOND: bonds"
    write(3,"(8i8)") bonds
end