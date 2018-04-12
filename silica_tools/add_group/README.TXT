
add_group_v4 ; Wed Mar  3 15:17:13 BRT 2010
adicionado a linha para escrever sempre a informacao da caixa

real                            :: box_abc(3)  ! dgomes Wed Mar  3 15:20:03 BRT 2010
read(1,"(6x,3f9.3,3f7.2)") box_size, box_abc
write(3,"(a6,3f9.3,3f7.2)") "CRYST1",box_size, box_abc


--
Fri Dec  4 20:00:44 BRST 2009
Problem writing residue number on very big systems.






Wed Dec  2 17:46:07 BRST 2009
 ################################################
 # Program:  fix_sio_surface                    #
 # Diego E.B. Gomes(1,2), Roberto D. Lins(2,3), #
 # Pedro G. Pascutti(1), Thereza A. Soares(2,3) #
 # 1) Universidade Federal do Rio de Janeiro    #
 # 2) Universidade Federal de Pernambuco        # 
 # 3) Pacific Northwest National Laboratory     #
 # mailto: diego@biof.ufrj.br                   #
 ################################################
