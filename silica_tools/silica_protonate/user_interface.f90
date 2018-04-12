module module_user_interface
character       ::  in*20
character       ::  out*20
character       ::  psf_in*20
character       ::  argv*20
!program specific variables
character       ::  psf_out*20
contains
    subroutine init_variables
        in=" "
        out=" "
        psf_in=" "
        psf_out=" "
    end subroutine
end module

module colors
implicit none
character       ::  red*5
character       ::  green*5
character       ::  blue*5
character       ::  normal*5
character       ::  underline*4

contains
    subroutine setcolors
        red=char(27)//"[31m" 
        green=char(27)//"[32m"
        blue=char(27)//"[34m"
        normal=char(27)//"[0m" 
        underline=char(27)//"[4m"
    end subroutine
end module colors


subroutine user_interface
!program user_interface
use colors
use module_user_interface
    call credits
    call readcmdline
end


! help ##########################################
subroutine credits
use colors
call setcolors
write(*,*) red
write(*,*) "################################################"
write(*,*) "# Program:  silica_protonate                   #"
write(*,*) "# Diego E.B. Gomes(1,3), Roberto D. Lins(2,3), #"
write(*,*) "# Pedro G. Pascutti(1), Thereza A. Soares(2,3) #"
write(*,*) "# 1) Universidade Federal do Rio de Janeiro    #"
write(*,*) "# 2) Universidade Federal de Pernambuco        #"
write(*,*) "# 3) Pacific Northwest National Laboratory     #"
write(*,*) "# mailto: diego@biof.ufrj.br                   #"
write(*,*) "################################################"
write(*,*) normal
end

subroutine readcmdline
use module_user_interface
integer         ::  n
integer         ::  iargc
call init_variables

n = iargc() ;  if(n.eq.0) call error(10)
    do i = 1, n
!common arguments
        call getarg( i, argv )
        if(argv(1:2).eq."-h") call help()
        if(argv(1:2).eq."-i") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") call error(11)
            in=argv
        endif

        if(argv(1:3).eq."-o ") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") call error(12)
            out=argv
        endif

!program specific options
        if(argv(1:2).eq."-p") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") call error(13)
            psf_in=argv
        endif
        
        if(argv(1:3).eq."-op") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") call error(14)
            psf_out=argv
        endif
               
    end do

!sanity test
if(in.eq." ") call error(11)
if(out.eq." ") call error(12)
if(psf_in.eq." ") call error(13)
if(psf_out.eq." ") call error(14)
end


! help ##########################################
subroutine  help
use colors
    write(*,*) "Example of usage:"
    write(*,*) "silica_protonate",red," -i",normal,"file.pdb",blue," -p",normal,"file.psf",&
    green," -o",normal,"out.pdb",red," -po",normal,"out.psf"
    write(*,*) normal
    write(*,*) green," -h        ",normal," = Display this help"
    write(*,*)   red," -i        ",normal," = PDB Input file"
    write(*,*)  blue," -p        ",normal," = PSF Input file"
    write(*,*) green," -o        ",normal," = PDB Output file"
    write(*,*) green," -op       ",normal," = PSF Output file"
    write(*,*)
STOP
end


! error handling ################################
subroutine  error(n)
use colors
    write(*,*) "Program executed with the following ERROR:"
    if (n.eq.10) write(*,*) green,"ERROR: No arguments.",normal 
    if (n.eq.11) write(*,*) green,"ERROR: No PDB input file provided",normal
    if (n.eq.12) write(*,*) green,"ERROR: No PSF output file provided",normal
!program specific error messages
    if (n.eq.13) write(*,*) green,"ERROR: No PSF input file provided",normal
    if (n.eq.14) write(*,*) green,"ERROR: No PDB Output file provided",normal
    write(*,*)
    write(*,*) "Type",red," silica_protonate -h ",normal,"to review all usage options"
    write(*,*)
STOP
end
