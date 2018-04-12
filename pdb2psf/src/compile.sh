export compiler=gfortran
export FLAGS="-ffree-form -fno-backslash -ffree-line-length-none -fbackslash"
#otimizacao minima
#export OPT_FLAGS="-O3 -static"
export OPT_FLAGS="-O3  -march=native -mtune=native"
#otimizacao boa
#export OPT_FLAGS="-O3 -march=native -mtune=native -finline-functions -funroll-all-loops -ffast-math"
#otimizacao jumento
export OPT_FLAGS="-O3 -march=native -mtune=native -msse -msse2 -msse3 -mssse3 -msse4 -msse4.1 -msse4.2 -funroll-loops -fprefetch-loop-arrays -fvariable-expansion-in-unroller -ffast-math -mfpmath=sse"

#Programa basico
$compiler $FLAGS $OPT_FLAGS -c pdb2psf.f90
$compiler $FLAGS $OPT_FLAGS -c modules.f90
$compiler $FLAGS $OPT_FLAGS -c credits.f90
$compiler $FLAGS $OPT_FLAGS -c help.f90
$compiler $FLAGS $OPT_FLAGS -c error.f90
#Rotinas
$compiler $FLAGS $OPT_FLAGS -c ReadCommandLine.f90
$compiler $FLAGS $OPT_FLAGS -c OpenFiles.f90
$compiler $FLAGS $OPT_FLAGS -c ReadPDB.f90
$compiler $FLAGS $OPT_FLAGS -c SetAtomParam.f90
#$compiler $FLAGS $OPT_FLAGS -c PSF_stuff.f90
$compiler $FLAGS $OPT_FLAGS -c GenerateTopology.f90
$compiler $FLAGS $OPT_FLAGS -c gen_bonds.f90
$compiler $FLAGS $OPT_FLAGS -c gen_bonds_SIO.f90
$compiler $FLAGS $OPT_FLAGS -c gen_bonds_nopbc.f90
$compiler $FLAGS $OPT_FLAGS -c gen_angles.f90
$compiler $FLAGS $OPT_FLAGS -c gen_angles_SIO.f90
$compiler $FLAGS $OPT_FLAGS -c ReadPSF.f90
$compiler $FLAGS $OPT_FLAGS -c WritePSF.f90

gfortran *.o -o ../bin/pdb2psf
rm -rf *.mod
rm -rf *.o
