!######################################################################
subroutine rotate_mol(i,rotation_angle)
!######################################################################
!default rotation angle is 120degrees
use module_fgroup
use module_quick_pdb
real,dimension(3)               ::  a,b
real,dimension(3)               ::  v1,v2
real,dimension(3)               ::  move !vector
real,dimension(3)               ::  origin !vector
real,dimension(3)               ::  unit !vector
real,dimension(3,natm_fgroup)   ::  new_pos_fgroup
real                            ::  rotation_angle
integer                         ::  first_bonded
!real                            ::  rotate


a=pos(:, first_bonded(i) )
b=pos(:,i)
origin = (/0.0,0.0,b(3)/) !follows the Z axis
unit   = (/0.0,0.0,b(3)+1.0/) !follows the Z axis


!write the bonds
final_bonds(lastbond+1)   =i
final_bonds(lastbond+2) =lastatm+1
do j=1,nbonds_fgroup*2,2
    final_bonds(lastbond+j+2)=bonds_fgroup(j)+lastatm
    final_bonds(lastbond+j+3)=bonds_fgroup(j+1)+lastatm
enddo
lastbond = lastbond + 2 + nbonds_fgroup*2

!move molecule to new origin
do j=1,natm_fgroup
    new_pos_fgroup(:,j)=pos_fgroup(:,j)
enddo

serial=lastatm

! O angle to origin, and store position where to move molecule
move(1) = b(1) + ( 1.54* ( cos( ang2rad(180.0) + atan2( b(2),b(1) ))))
move(2) = b(2) + ( 1.54* ( sin( ang2rad(180.0) + atan2( b(2),b(1) ))))
move(3) = b(3)


!do j=1,natm_fgroup
!write(*,*) new_pos_fgroup(:,j)
!call rotx(rotation_angle,new_pos_fgroup(:,j))
!enddo

!do j=1,natm_fgroup
!write(*,*) new_pos_fgroup(:,j)
!enddo


do j=1,natm_fgroup
!call rotz(rotate,new_pos_fgroup(:,j))
call rotx(rotation_angle,new_pos_fgroup(:,j))
    new_pos_fgroup(:,j)=new_pos_fgroup(:,j) + move
!    write(2,1000) serial+j,name_fgroup(j), resid_fgroup,new_pos_fgroup(:,j),0.0,0.0
    write(2,1000) serial+j,name_fgroup(j), resid_fgroup,new_pos_fgroup(:,j),0.0,0.0,"      U9   "
    write(4,2000) serial+j," U9",resid_fgroup,"FMS",adjustl(name_fgroup(j)),adjustl(name_fgroup(j)),charges_fgroup(j),mass_fgroup(j)
    !write(output,2000) serial," U0",resSeq,resName,psf_name,psf_type,charge,mass

enddo



lastatm=lastatm+natm_fgroup
resid_fgroup=resid_fgroup+1
!1000    format(a6,i5,1x,a4,a1,a3,1x,a1,i4,a1,3x,3f8.3,2f6.2)
!1000    format("ATOM  ",i5,1x,a4," ","GRP",1x,"X",i4," ",3x,3f8.3,2f6.2,a,a)
1000    format("ATOM  ",i5,1x,a4," ","FMS",1x,"X",i4," ",3x,3f8.3,2f6.2,a11)
2000    format(i8,a3,2x,i4,2x,a3,2x,a3,2x,a3,2x,f10.6,6x,f8.4)  !psf write format

end

