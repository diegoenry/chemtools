subroutine gen_bonds(cutoff)
use module_quick_pdb,only   :   box_size,box_inv,pos,natm
use module_atom_type,only   :   ttype,bonds,nbonds
integer                     ::  bindex
real                        ::  rij
real                        ::  cutoff
real                        ::  cutoff2
real,dimension(3)           ::  iatm    !optimization
real,dimension(3)           ::  vd      !optimization

 cutoff2=cutoff*cutoff    !so we don't need to sqrt(dist)
allocate(bonds(natm*4)) !good, about 2bonds/atom 
bonds=0
nbonds=0
bindex=1
write(*,"(a)") "Computing bonds for atom:"
do i=1,natm
    iatm=pos(:,i)        !optimization
write(*,"(i8,A,$)") i,"\r"
    do j=i+1,natm
!must substitute this by the "ELEMENT" concept
      if(ttype(i)==1.and.ttype(i)==1) cycle    ! hydrogens can get really close
      if(ttype(i)==1.and.ttype(i)==101) cycle
      if(ttype(i)==101.and.ttype(i)==1) cycle
      vd= iatm - pos(:,j)
!optimization for large systems
      vd = vd - anint(vd * box_inv) * box_size
      if(vd(1)>cutoff2.or.vd(2)>cutoff2.or.vd(3)>cutoff2) cycle 
      d = dot_product(vd,vd)
      if (d < cutoff2) then
            bonds(bindex)=i
            bonds(bindex+1)=j
            bindex=bindex+2
        endif
    enddo
enddo
write(*,*)
nbonds=(bindex-1)/2
end
