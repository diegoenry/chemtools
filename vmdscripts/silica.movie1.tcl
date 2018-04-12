#resize display
display resize 800 600

#load viewport tool
source /afs/msrc.pnl.gov/files/home/dgomes/vmdscripts/dgomes_view_change_render.tcl

#load saved viewports at current dir
#source ./viewports.tcl

#load take_picture tool
source /afs/msrc.pnl.gov/files/home/dgomes/vmdscripts/aglianico.take_picture.tcl

#copying file because MacOSX is little messed up with spaces
#exec cp  /Applications/VMD\ 1.8.7.app/Contents/vmd/tachyon_MACOSXX86 /tmp/

take_picture method Tachyon
take_picture format plot.dat
take_picture exec "aews"

#First scene transition, moving from viewport 1 to 2 in 25 frames  (start end first_frame_num dirName filePrefixName morph_frames )
#take_picture format "./scene1.%04d.tga"
#move_vp_render 1 2 0 ./ scene1 50 smooth

#proc make_trajectory_movie {} {
	set nframe [molinfo top get numframes]
#take_picture format "./scene2.%04d.tga"
#    set nframe 50
	for {set i 0} {$i < $nframe} {incr i} {
		# go to the given frame
        set i [expr {$i + 10}]
        puts $i
		animate goto $i
        # force display update
        #display update 
		# take the picture
		take_picture
	}
#	return
#}
