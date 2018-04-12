module module_add
real,dimension(3)       ::  center
real,dimension(3)       ::  unit
real,dimension(3)       ::  v1
real,dimension(3)       ::  v2
real                    ::  ang
integer                 ::  anum
integer                 ::  resn
end module module_add


subroutine add
use module_user_interface
use module_atom_type
use module_pdb
use module_add

!replaced by pdb2psf    open(4,file=psf_out)

 center  =   (/0.0,0.0,0.0/)
 unit    =   (/1.0,0.0,0.0/)
 resn=natm+1
 anum=natm+1

do i=1,natm
  if(tempFactor(i)<1.00.and.ttype(i)==14.and.abonds(i)<4) then
    unit(3)=pos(3,i)
    center(3)=unit(3)
    v1=center-unit 
    v2=center-pos(:,i)
      if(pos(2,i)>=0.0)  ang=        angle(v1,v2)+ang2rad(90.0)  !quadrante 1
      if(pos(2,i)<0.0)   ang= (-1) * angle(v1,v2)+ang2rad(90.0)  !quadrante 2
    call add_oh(i,ang,pos(:,i),resn,anum,0)
    resn=resn+1
    anum=anum+2
  endif

  if(tempFactor(i)<1.00.and.ttype(i)==8.and.abonds(i)<2) then
    unit(3)=pos(3,i)
    center(3)=unit(3)
    v1=center-unit 
    v2=center-pos(:,i)
      if(pos(2,i)>=0.0)  ang=        angle(v1,v2)+ang2rad(90.0)  !quadrante 1
      if(pos(2,i)<0.0)   ang= (-1) * angle(v1,v2)+ang2rad(90.0)  !quadrante 2
    call add_h(i,ang,pos(:,i),resn,anum,0)
    resn=resn+1
    anum=anum+1
  endif

enddo

end

subroutine add_oh(atm,angle,ref,resn,anum,opt)
use module_user_interface
use module_atom_type
integer                 ::  atm
integer                 ::  anum
integer                 ::  resn
integer                 ::  opt
real, dimension(3,6)    ::  coor
real, dimension(3)      ::  ref
real                    ::  x,y,z
real                    ::  angle


!replaced by pdb2psf    write(4,2003) anum,resn     !write atoms
!replaced by pdb2psf    write(4,2004) anum+1,resn   !write atoms

if(opt==0) then  !assume it's a surface
 coor(:,1)=(/0.000,0.000,1.650/) !ycoord + 1.200
 coor(:,2)=(/0.000,0.000,2.650/) !ycoord + 1.200
else
 coor(:,1)=(/0.000,1.650,0.000/) !ycoord + 1.200
 coor(:,2)=(/0.000,2.650,0.000/) !ycoord + 1.200
endif

do i=1,2 !this group has only 2 atoms
    if(opt==1) then  !Pore, apply Z axis rotation to point to the center
        x=coor(1,i)*cos(angle) - coor(2,i)*sin(angle)
        y=coor(1,i)*sin(angle) + coor(2,i)*cos(angle)
        z=coor(3,i)
    else
        x=coor(1,i)
        y=coor(2,i)
        z=coor(3,i)
        if(opt==0.and.ref(3)<0.0) z=(-1)*z
    endif

    coor(1,i)=x+ref(1)
    coor(2,i)=y+ref(2)
    coor(3,i)=z+ref(3)

!writing output
    if(i==1) write(3,1000) anum,resn,(coor(j,i),j=1,3)
    if(i==2) write(3,1001) anum+1,resn,(coor(j,i),j=1,3)

!writing bonds to tmpbonds
    if(i==1)    write(66,"(2i8)") atm,     anum
    if(i==2)     write(66,"(2i8)") anum,  anum+1
    
enddo

1000    format("ATOM  ",i5,"  O   SIO U",i4,4x,3f8.3,"  1.00  0.00      U0   O")
1001    format("ATOM  ",i5,"  H   SIO U",i4,4x,3f8.3,"  1.00  0.00      U0   H")
2003    format(i8," U1",i6,2x,"SIO  O    O      0.000000       15.9994           0")
2004    format(i8," U1",i6,2x,"SIO  H    H      0.000000        1.0081           0")

end


subroutine add_h(atm,angle,ref,resn,anum,opt)
integer                 ::  atm
integer                 ::  anum
integer                 ::  resn
integer                 ::  opt
real, dimension(3,6)    ::  coor
real, dimension(3)      ::  ref
real                    ::  x,y,z
real                    ::  angle

!replaced by pdb2psf  write(4,2004) anum,resn     !write atoms

if(opt==0) then  !assume it's a surface
 coor(:,1)=(/0.000,0.000,1.000/) 
else
 coor(:,1)=(/0.000,1.000,0.000/) 
endif

do i=1,1 !this group has only 1 atom
    if(opt==1) then  !Pore, apply Z axis rotation to point to the center
        x=coor(1,i)*cos(angle) - coor(2,i)*sin(angle)
        y=coor(1,i)*sin(angle) + coor(2,i)*cos(angle)
        z=coor(3,i)
    else
        x=coor(1,i)
        y=coor(2,i)
        z=coor(3,i)
        if(opt==0.and.ref(3)<0.0) z=(-1)*z
    endif

    coor(1,i)=x+ref(1)
    coor(2,i)=y+ref(2)
    coor(3,i)=z+ref(3)

!writing output
    write(3,1001) anum,resn,(coor(j,i),j=1,3)
!writing bonds
    write(66,"(2i8)") atm,     anum
enddo
1001    format("ATOM  ",i5,"  H   SIO U",i4,4x,3f8.3,"  1.00  0.00      U0   H")
2004    format(i8," U1",i6,2x,"SIO  H    H      0.000000        1.0081           0")

end
