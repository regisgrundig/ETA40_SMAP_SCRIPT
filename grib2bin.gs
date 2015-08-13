'reinit'
'open temp.ctl'
'q time'
file=subwrd(result,3)
'set lon 286 330'
'set lat -34 5'
'set fwrite -ap saida.bin'
'set gxout fwrite'
'd pratesfc*3600*6'
'disable fwrite'
pid=write("log.prn",file,append)
'quit'
