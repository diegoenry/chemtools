subroutine  error(n)
use colors
    write(*,*) "Program executed with the following ERROR:"
    if (n.eq.10) write(*,*) green,"ERROR: No arguments.",normal 
    if (n.eq.11) write(*,*) green,"ERROR: No input file",normal
    if (n.eq.12) write(*,*) green,"ERROR: No output file",normal
!program specific error messages
!    if (n.eq.13) write(*,*) green,"ERROR: Cutoff was not specified",normal
    if (n.eq.14) write(*,*) green,"ERROR: No PSF input file",normal
    if (n.eq.15) write(*,*) green,"ERROR: No GMX .top output file",normal
    write(*,*)
    write(*,*) "Type",red," pdb2psf -h ",normal,"to review all usage options"
    write(*,*)
STOP
end