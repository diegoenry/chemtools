subroutine gen_angles
use module_atom_type,only   :   nbonds,bonds
use module_atom_type,only   :   nangles,angles
use module_atom_type,only   :   ndihedrals,dihedrals
use module_quick_pdb,only   :   natm
use module_user_interface,only: calc_dihedrals
integer                 ::  iatm1,iatm2,iatm3,iatm4,iatm5,iatm6
integer                 ::  sort_bonds=0        ! default
integer                 ::  sort_angles=0       !
integer                 ::  first_bonded
integer                 ::  batm(5)

! SORT BONDS IS MANDATORY IF CALCULATION DIHEDRALS !
!reorder the bond list will make everything easyier
if(sort_bonds==1.or.calc_dihedrals==1) then
write(*,*) "Resorting Bonds Part 1"
do i=1,nbonds*2,2 !step 1 swap values
!mac write(*,"(i8,A,$)") i,"\r" 
    iatm1=bonds(i)
    iatm2=bonds(i+1)
    if(iatm1>iatm2) then
        bonds(i)=iatm2
        bonds(i+1)=iatm1
    endif
enddo
write(*,*) 
write(*,*) "Resorting Bonds Part 2"
! adapted from Fortran 90/95 for scientists and engineers By Stephen J. Chapman
outer:  do i=1,nbonds*2-2,2 !step 1 swap values !wrong
!mac write(*,"(i8,A,$)") i,"\r"
        iptr=i
inner:  do j=i+2,nbonds*2,2
    minval: if(bonds(j)<bonds(iptr)) then
            iptr=j
            endif minval
        enddo inner
swap:   if( i /= iptr ) then
        itemp           =   bonds(i)
        itemp2          =   bonds(i+1)
        bonds(i)        =   bonds(iptr)
        bonds(i+1)      =   bonds(iptr+1)
        bonds(iptr)     =   itemp
        bonds(iptr+1)   =   itemp2
        endif swap
enddo outer
write(*,*)
endif

write(*,*) "Computing Angles"
allocate(angles(nbonds*10))
nangles=0
! do i = 1, nbonds*2,2 !new 
! write(*,"(i8,A,$)") i,"\r"
! iatm1=bonds(i)
! iatm2=bonds(i+1)
!     do j= i+2,nbonds*2,2
!         if(bonds(j)==iatm2) then
!             angles(nangles+1:nangles+3) = (/iatm1,iatm2,bonds(j+1)/) !notice the order
!             nangles=nangles+3
!         endif
!         if(bonds(j+1)==iatm2) then
!             angles(nangles+1:nangles+3) = (/iatm1,iatm2,bonds(j)/) !notice the order
!             nangles=nangles+3
!         endif
!     enddo
! enddo

!beta loop to compute angles, it is not necessary to resort bonds
do i=1,natm
!write(*,"(i8,A,$)") i,"\r"
iatm1=i
nbonded=0
        do j=1,nbonds*2,2 !get the first bonded atom to i
            if(bonds(j)==i) then
                nbonded=nbonded+1
                batm(nbonded)=bonds(j+1)
            endif
            if(bonds(j+1)==i) then
                nbonded=nbonded+1
                batm(nbonded)=bonds(j)
            endif
        enddo

        if(nbonded==0) then
            write(*,*) "Atom ",i,"has zero bonds"
        endif
        if(nbonded==1) cycle
        if(nbonded==2) then
            angles(nangles+1:nangles+3)= (/batm(1),iatm1,batm(2)/)
!gmx            write(34,*) batm(1),iatm1,batm(2)
            nangles=nangles+3
        endif
        if(nbonded==3) then
            angles(nangles+1:nangles+3)= (/batm(1),iatm1,batm(2)/)
            angles(nangles+4:nangles+6)= (/batm(1),iatm1,batm(3)/)
            angles(nangles+7:nangles+9)= (/batm(2),iatm1,batm(3)/)
            nangles=nangles+9
        endif
        if(nbonded==4) then
            angles(nangles+1:nangles+3)=   (/batm(1),iatm1,batm(2)/)
            angles(nangles+4:nangles+6)=   (/batm(1),iatm1,batm(3)/)
            angles(nangles+7:nangles+9)=   (/batm(1),iatm1,batm(4)/)
            angles(nangles+10:nangles+12)= (/batm(2),iatm1,batm(3)/)
            angles(nangles+13:nangles+15)= (/batm(2),iatm1,batm(4)/)
            angles(nangles+16:nangles+18)= (/batm(3),iatm1,batm(4)/)
            nangles=nangles+18
        endif
        if(nbonded==5) then
            write(*,*) "Atom ",i,"has five bonds"
            angles(nangles+1:nangles+3)=   (/batm(1),iatm1,batm(2)/)
            angles(nangles+4:nangles+6)=   (/batm(1),iatm1,batm(3)/)
            angles(nangles+7:nangles+9)=   (/batm(1),iatm1,batm(4)/)
            angles(nangles+10:nangles+12)= (/batm(1),iatm1,batm(5)/)
            angles(nangles+13:nangles+15)= (/batm(2),iatm1,batm(3)/)
            angles(nangles+16:nangles+18)= (/batm(2),iatm1,batm(4)/)
            angles(nangles+19:nangles+21)= (/batm(2),iatm1,batm(5)/)
            angles(nangles+22:nangles+24)= (/batm(3),iatm1,batm(4)/)
            angles(nangles+25:nangles+27)= (/batm(3),iatm1,batm(5)/)
            angles(nangles+28:nangles+30)= (/batm(4),iatm1,batm(5)/)
        nangles=nangles+30
        endif
enddo

write(*,*)
nangles=nangles/3


! THIS LOOP IS OPTIONAL (enabled by default)
if(sort_angles==1) then
write(*,*) "Resorting Angles"
    do i=1,nangles*3,3 !step 1 swap values
!write(*,"(i8,A,$)") i,"\r"
    iatm1=angles(i)
    iatm2=angles(i+1)
    iatm3=angles(i+2)
        do j = i+3,nangles*3,3
        iatm4=angles(j)
        iatm5=angles(j+1)
        iatm6=angles(j+2)
            if(iatm2==iatm5) then
                if(iatm3>iatm6) then
                    angles(i)  =iatm4
                    angles(i+1)=iatm5
                    angles(i+2)=iatm6
                    angles(j)  =iatm1
                    angles(j+1)=iatm2
                    angles(j+2)=iatm3
                endif
            endif
        enddo
    enddo
write(*,*)
endif ! sort angles


!dihedrals
ndihedrals=0
if(calc_dihedrals==1) then
write(*,*) "Computing Dihedrals"
allocate(dihedrals(nbonds*10))
do i = 1, nangles*3,3
!write(*,"(i8,A,$)") i,"\r"
iatm1=angles(i)
iatm2=angles(i+1)
iatm3=angles(i+2)
    do j=1,nbonds*2,2
        if(bonds(j)==iatm3) then
            if(bonds(j+1)/=iatm2) then
                if(bonds(j+1)>iatm1) then
! write(*,*) iatm1,iatm2,iatm3,bonds(j+1)
dihedrals(ndihedrals+1:ndihedrals+4) = (/iatm1,iatm2,iatm3,bonds(j+1)/)
                ndihedrals=ndihedrals+4
                endif
            endif
        endif
        if(bonds(j+1)==iatm3) then
             if(bonds(j)/=iatm2) then
                if(bonds(j)>iatm1) then
! write(*,*) iatm1,iatm2,iatm3,bonds(j)
dihedrals(ndihedrals+1:ndihedrals+4) = (/iatm1,iatm2,iatm3,bonds(j)/)
                ndihedrals=ndihedrals+4
                endif
             endif
        endif
    enddo
enddo
endif
ndihedrals=ndihedrals/4
write(*,*)
end
! 
! 
! function first_bonded(i)
! use module_psf
! use module_pdb
! integer     ::  first_bonded
! do j=1,nbonds*2,2
!     if(bonds(j)==i) then
!         first_bonded=bonds(j+1)
!         return
!     endif
!     if(bonds(j+1)==i) then
!         first_bonded=bonds(j)
!         return
!     endif
!     enddo
! end
! 
