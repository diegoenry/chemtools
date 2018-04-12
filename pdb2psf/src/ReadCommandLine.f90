subroutine ReadCommandLine
use module_user_interface
integer         ::  n
integer         ::  iargc

call init_variables

n = iargc() ;  if(n.eq.0) call error(10)
    do i = 1, n
!common arguments
        call getarg( i, argv )
        if(argv(1:2).eq."-h") call help
        if(argv(1:2).eq."-i") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") call error(11)
            pdb_in=argv
        endif

        if(argv(1:2).eq."-o") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") call error(12)
            psf_out=argv
        endif

!program specific options
        if(argv(1:2).eq."-p".and.argv(1:3)/="-ps") then ; call getarg(i+1,argv)  !patch
            if(argv.eq." ".or.argv(1:1).eq."-") call error(14)
            psf_in=argv
        endif

!
        if(argv(1:4).eq."-gmx") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") call error(15)
            gmx_out=argv
        endif


        if(argv(1:6).eq."-bonds")   calc_bonds=1

        if(argv(1:7).eq."-angles")  then
!            calc_bonds=1
            calc_angles=1
        endif

        if(argv(1:10).eq."-dihedrals")  then
!            calc_bonds=1
            calc_angles=1 ; calc_dihedrals=1
        endif

        if(argv(1:4).eq."-all")  then
            calc_bonds=1 ; calc_angles=1 ; calc_dihedrals=1
        endif

        if(argv(1:4).eq."-npz")     periodic_z=1
        if(argv(1:6).eq."-nosio")   sio=0
        if(argv(1:6).eq."-nopbc")   periodic=0

        if(argv(1:3).eq."-d ") then ; call getarg(i+1,argv)
            if(argv(1:1).eq."-".or.argv(1:1).eq." ") then
               print*, "Cutoff not specified, using 1.8 Angstrons"
            else
                read(argv,*) distance_cutoff !string to number
          endif
        endif

        if(argv(1:8).eq."-psftype") KeepPSFtype=1

    end do


!sanity test
if(pdb_in.eq." ") call error(11)
if(psf_out.eq." ") call error(12)
if(distance_cutoff==0.0) distance_cutoff=1.80
end