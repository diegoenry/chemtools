subroutine gen_bonds_SIO(cutoff)
use module_quick_pdb,only   :   box_size,box_inv,pos,natm
use module_atom_type,only   :   ttype,bonds,nbonds
integer                     ::  bindex
real                        ::  rij
real                        ::  cutoff
real                        ::  cutoff2
real,dimension(3)           ::  iatm    !optimization
real,dimension(3)           ::  vd      !optimization
 cutoff2=cutoff*cutoff    !so we don't need to sqrt(dist)
allocate(bonds(natm*4)) !good, about oxygen only make 2bonds max 
bonds=0
nbonds=0
bindex=1
write(*,"(a)") "Computing only O-SI bonds (failsafe silicon dioxide code):"

do i=1,natm
    if(ttype(i)==14) cycle
    write(*,"(i8,A,$)") i,"\r"
    iatm=pos(:,i)        !optimization
    do j=1,natm
!        if(ttype(j)==8) cycle ! covers all Oxygen types
        if(ttype(j)==8.or.ttype(j)==801.or.ttype(j)==802) cycle ! covers all Oxygen types Wed Mar  3 18:06:05 BRT 2010
!     d=dist(pos(:,i),pos(:,j),box_inv,box_size) !calling functions is slow
        vd= iatm - pos(:,j)
!bug    if(vd(1)>cutoff2.or.vd(2)>cutoff2.or.vd(3)>cutoff2) cycle ! bug 001 Tue Sep 29 11:11:00 PDT  
        vd = vd - anint(vd * box_inv) * box_size
!optimization for large systems
        if(vd(1)>cutoff2.or.vd(2)>cutoff2.or.vd(3)>cutoff2) cycle !bugfix by dgomes Tue Sep 29 11:11:00 PDT
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
