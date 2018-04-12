subroutine  help
use colors
    write(*,*) "Example of usage:"
    write(*,*) "pdb2psf",red," -i",normal,"file.pdb",green," -o",normal,"file.psf",&
                red," -d",normal,"1.8",green," -all"
    write(*,*) normal
    write(*,*) green," -h        ",normal," = Display this help"
    write(*,*)   red," -i        ",normal," = PDB Input file"
    write(*,*)  blue," -p        ",normal," = PSF Input file (Optional)"
    write(*,*) green," -o        ",normal," = PSF Output file"
    write(*,*)   red," -d        ",normal," = Maximum distance for a bond"
    write(*,*)  blue," -psftype  ",normal," = preserve .psf atom types"
    write(*,*) green," -gmx      ",normal," = GMX .top Output file"
    write(*,*)   red," -nosio    ",normal," = Turn off failsafe code for Silicon dioxide"
    write(*,*)  blue," -nopbc    ",normal," = Turn off Periodic Boundary Conditions"
    write(*,*) green," -npz      ",normal," = Non-Periodic in Z"
    write(*,*)   red," -bonds    ",normal," = generate bonds" 
    write(*,*)  blue," -angles   ",normal," = generate bonds & angles"
    write(*,*) green," -dihedrals",normal," = generate bonds, angles & proper dihedrals"
    write(*,*)   red," -all      ",normal," = generate bonds, angles & proper dihedrals"
    write(*,*)
STOP
end