program pdb2psf
use module_user_interface
use colors
call setcolors
    call Credits

    call ReadCommandLine

    call OpenFiles

    if(KeepPSFtype==0) call ReadPDB ! input=1, output=2

    if(KeepPSFtype==1) call ReadPSF(3,2,1,0,0,0)

    call GenerateTopology

    call WritePSF(2) ! output=2

end

! ##### FUNCTIONS ##### FUNCTIONS ##### FUNCTIONS
function dist_nopbc(i,j)
    real,dimension(3) :: i,j,vd
    vd = i - j
    dist_nopbc = dot_product(vd,vd)
end

function dist(i,j,box_inv,box_size)
    real,dimension(3) :: i,j,vd,box_inv,box_size
    vd = i - j
    vd = vd - anint(vd * box_inv) * box_size
    dist = dot_product(vd,vd)
end
! ##### FUNCTIONS ##### FUNCTIONS ##### FUNCTIONS
