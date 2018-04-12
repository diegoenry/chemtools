! VMD is still 10x faster
! but this is 10x faster than my first kernel \o\
subroutine gen_bonds_nopbc(cutoff)
use module_quick_pdb,only   :   pos,natm
use module_atom_type,only   :   ttype,bonds,nbonds
integer                     ::  bindex
real                        ::  rij
real                        ::  cutoff
real                        ::  cutoff2
real,dimension(3)           ::  iatm
real,dimension(3)           ::  vd
 cutoff2=cutoff*cutoff    !so we don't need to sqrt(dist)
allocate(bonds(natm*4)) !good, about 2bonds/atom 
bonds=0
nbonds=0
bindex=1

write(*,*) "Computing bonds for atom:"
do i=1,natm
iatm=pos(:,i)
write(*,"(i8,A,$)") i,"\r" 
    do j=i+1,natm
    vd=iatm-pos(:,j)
    if(vd(1)>cutoff2.or.vd(2)>cutoff2.or.vd(3)>cutoff2) cycle
    d=dot_product(vd,vd)
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