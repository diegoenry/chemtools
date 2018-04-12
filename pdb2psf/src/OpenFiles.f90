subroutine OpenFiles
use module_user_interface
!open files
open(1,file=pdb_in)
open(2,file=psf_out)
if(psf_in/=" ")  open(3,file=psf_in)
if(gmx_out/=" ") open(4,file=gmx_out)
end