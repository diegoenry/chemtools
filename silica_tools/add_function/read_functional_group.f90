!######################################################################
subroutine read_functional_group
!######################################################################
use module_fgroup
use module_user_interface,only  : fgroup_in
character(len=6)    ::  RecordName
integer             ::  natm
real                ::  d
real,dimension(3)   ::  move
real,dimension(3)   ::  origin !vector
real,dimension(3)   ::  unit   !vector
real,dimension(3)   ::  v1,v2
real                ::  rotate,prevrot
real,dimension(3)   :: previous,current
real                :: dx,dy

character(len=4)    :: namei,namej ! metodo burro, veja o loop find bonds

origin = (/0.0,0.0,0.0/)
unit   = (/0.0,0.0,1.0/)

natm=0
nbonds_fgroup=1

open(66,file=fgroup_in)
do  !count atoms
    read(66,"(a6)",end=10,err=10) RecordName
    if (RecordName=="ATOM  ".or.RecordName=="HETATM") then
    natm=natm+1
    endif
enddo
10  rewind(66)

natm_fgroup=natm    !assign correct name

RecordName="      " !just to reset
do while (RecordName/="ATOM  ".and.RecordName/="HETATM") 
read(66,"(a6)") RecordName 
write(*,*) RecordName
enddo
backspace(66)

allocate( pos_fgroup(3,natm)   )
allocate( name_fgroup(natm)    )
allocate( bonds_fgroup(natm*4) ) !good enough
allocate( charges_fgroup(natm) )
allocate( mass_fgroup(natm) )

do i=1,natm_fgroup !read coordinates
    read(66,1000) name_fgroup(i),pos_fgroup(:,i),charges_fgroup(i),mass_fgroup(i)
    write(*,*) name_fgroup(i),pos_fgroup(:,i),charges_fgroup(i),mass_fgroup(i)
enddo


do i=1,natm_fgroup !find bonds
    do j=i+1,natm_fgroup
        d=sqrt( atom_dist(pos_fgroup(:,i),pos_fgroup(:,j)) )
        if(d<1.7) then
        namei=trim(adjustl(name_fgroup(i)))
        namej=trim(adjustl(name_fgroup(j)))
            if(namei(1:1)=="H".and.namej(1:1)=="H") cycle
            print*, "found bond", i,j,d,name_fgroup(i)(1:1),name_fgroup(j)(1:1)
            bonds_fgroup(nbonds_fgroup)  =i
            bonds_fgroup(nbonds_fgroup+1)=j
            nbonds_fgroup=nbonds_fgroup + 2
        endif
    enddo
enddo
nbonds_fgroup=(nbonds_fgroup-1)/2

!1) move addgroup to origin
move = origin - pos_fgroup(:,1)
do j=1,natm_fgroup
     pos_fgroup(:,j) = pos_fgroup(:,j) + move
enddo 


!qtos graus rodar ?
write(*,*) pos_fgroup(:,2)

! ISSO FUNCIONA, NAO APAGAR.
!zerar o Z
!rotate = rad2ang( vector_angle( pos_fgroup(:,2),(/1.0,0.0,0.0/) ) )
!call roty(rotate, pos_fgroup(:,2))                                  
!write(*,*)
!write(*,*) pos_fgroup(:,2)
!!zerar o X, jogando tudo para o Y
!rotate = rad2ang( vector_angle( pos_fgroup(:,2),(/0.0,1.0,0.0/) ) )
!call rotz(rotate, pos_fgroup(:,2))                                  
!write(*,*)
!write(*,*) pos_fgroup(:,2)
!!transferir para o Z
!rotate = rad2ang( vector_angle( pos_fgroup(:,2),(/0.0,0.0,1.0/) ) )
!call rotx(rotate, pos_fgroup(:,2))                                  
!write(*,*)
!write(*,*) pos_fgroup(:,2)


!zerar o Z
DO I=1,NATM_FGROUP
    rotate = rad2ang( vector_angle( pos_fgroup(:,2),(/1.0,0.0,0.0/) ) )
    DO J = 1, NATM_FGROUP
        call roty(rotate, pos_fgroup(:,J))
    ENDDO
!zerar o X, jogando tudo para o Y
    rotate = rad2ang( vector_angle( pos_fgroup(:,2),(/0.0,1.0,0.0/) ) )
    DO J = 1, NATM_FGROUP
        call rotz(rotate, pos_fgroup(:,J))
    ENDDO
!transferir para o Z
    rotate = rad2ang( vector_angle( pos_fgroup(:,2),(/0.0,0.0,1.0/) ) )
    DO J = 1, NATM_FGROUP
        call rotx(rotate, pos_fgroup(:,J))                                  
    ENDDO
ENDDO


close(66)
!1000    format(a6,i5,1x,a4,a1,a3,1x,a1,i4,a1,3x,3f8.3,2f6.2)
1000    format(12x,a4,14x,3f8.3,2f8.3)
end

