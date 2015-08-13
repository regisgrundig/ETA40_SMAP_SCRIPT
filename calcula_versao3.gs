*------------------------------------------------------------------------
*
*
*  SCRIPT CALCULAR CHUVA NA BACIA 
*  CALCULAR CHUVA ACUMULADA POR BACIA DO SIN 
*
*  VERSAO 2.0 
*
*
*  bY regis  reginaldo.venturadesa@gmail.com 
*  uso:
*      calcula.gs (exige grads)   [00/12]   
*------------------------------------------------------------------------- 
*
*
'reinit'
'open modelo_all.ctl'
'q time'
data=subwrd(result,3)
*ga-> q files
*File 1 : 29help Days of Sample Model Output
*  Descriptor: modelo.ctl
*  Binary: pp20150109_0252.bin
'q files'
ans=sublin(result,3)
var=subwrd(ans,2)
*
* data da rodada
*
data1=substr(var,1,10)



*
*  leio arquivo bacia e processo 
* para cada item dentro desse arquivo
*

while ( 0=0 )       
*
* abre o arquivo bacias
*
id=read("../../bacias")
*
* se status=0 tudo ok. se não ...
*
status=sublin(id,1)   

if (status>0) 
'quit'
endif



var=sublin(id,2)
bacia=subwrd(var,1)
label=subwrd(var,2)
xxx=write("todomundo.prn",label' 'bacia,append)
yyy=write("comremocao.prn",label' 'bacia,append)
say "calculando para  bacia:"bacia
status2=status
chuva=0
conta=0
p=0 
_pchuva.1=0



t=1
while (t<=10)
'set t ' t
'q time'
dataprev=subwrd(result,3)



*
* tendo o nome da bacia lido no arquivo "bacia"
* vou pegar os pontos d egrade que estao
* dentro da bacia
*

fd=close("../../CONTORNOS/CADASTRADAS/"bacia)
status2=0

*
* execuo esse esse bloco ate  a leitura
* de todos os pontos de grade que estao na bacia
*

while (!status2)
fd=read("../../CONTORNOS/CADASTRADAS/"bacia)
status2=sublin(fd,1)
if (status2 = 0) 
*
* ajusto set lat e set lon com as coordenadas lidas
* no arquivo que contem os pontos de grade
*
coord=sublin(fd,2)
xlon=subwrd(coord,1)
xlat=subwrd(coord,2)
'set lat 'xlat
'set lon 'xlon
*
* pego a chuva do ponto de grade
*
'd prec'
valor=subwrd(result,4) 
chuva=chuva+valor
conta=conta+1




endif
endwhile
media=chuva/(conta+(0.00001))
rc1 = math_format("%7.2f",chuva)
rc2 = math_format("%7.0f",conta)
rc3 = math_format("%5.2f",media)
p=p+1
_pchuva.p=media
fim=write(bacia,data1' 'dataprev' 'rc3,append)
xxx=write("todomundo.prn",data1' 'dataprev' 'rc3,append)
t=t+1
endwhile
say "=================================="p
ih=removiessum(label,data1) 

************  da linha 36
endwhile     
'quit'




function removiessum(label,data1)
*
* verifica o mes
*
mes=substr(data1,5,2)
*if (mes >= 04 & mes <=9)
*return
*endif 


*---------------------------------------------------------------------------------------------------------------
*
*  BACIA DO GRANDE  ADICIONADO EM (12/6/2015)
*
*
* REMOCAO DE VIES PARA DEZEMBRO E JANEIRO
*

if  ( label = "GRANDE"  & ( mes =1  | mes =7 )) 
a=0.0036
b=0.9572
ptoteta10=(_pchuva.1+_pchuva.2+_pchuva.3+_pchuva.4+_pchuva.5+_pchuva.6+_pchuva.7+_pchuva.8+_pchuva.9+_pchuva.10)
ptotpre10=(a*(ptoteta10*ptoteta10))+b*(ptoteta10)
pp=1
while (pp<=10)
'set t ' pp
'q time'
dataprev=subwrd(result,3)
ppre.pp=_pchuva.pp*(ptotpre10/ptoteta10)
rc3 = math_format("%5.2f",ppre.pp)
yyy=write("comremocao.prn",data1' 'dataprev' 'rc3,append)
pp=pp+1
endwhile
endif 
*
* REMOCAO DE VIES PARA FEVEREIRO E MARÇO
*
if  ( label = "GRANDE"  & ( mes =2  | mes =3 )) 
a=0.0036
b=0.9572
ptoteta10=(_pchuva.1+_pchuva.2+_pchuva.3+_pchuva.4+_pchuva.5+_pchuva.6+_pchuva.7+_pchuva.8+_pchuva.9+_pchuva.10)
ptotpre10=(a*(ptoteta10*ptoteta10))+b*(ptoteta10)
pp=1
while (pp<=10)
'set t ' pp
'q time'
dataprev=subwrd(result,3)
ppre.pp=_pchuva.pp*(ptotpre10/ptoteta10)
rc3 = math_format("%5.2f",ppre.pp)
yyy=write("comremocao.prn",data1' 'dataprev' 'rc3,append)
pp=pp+1
endwhile
endif 
*
* REMOCAO DE VIES PARA NOVEMBRO E OUTUBRO
*
if  ( label = "GRANDE"  & ( mes =10  | mes =11 )) 
a=0.0036
b=0.9572
ptoteta10=(_pchuva.1+_pchuva.2+_pchuva.3+_pchuva.4+_pchuva.5+_pchuva.6+_pchuva.7+_pchuva.8+_pchuva.9+_pchuva.10)
ptotpre10=(a*(ptoteta10*ptoteta10))+b*(ptoteta10)
pp=1
while (pp<=10)
'set t ' pp
'q time'
dataprev=subwrd(result,3)
ppre.pp=_pchuva.pp*(ptotpre10/ptoteta10)
rc3 = math_format("%5.2f",ppre.pp)
yyy=write("comremocao.prn",data1' 'dataprev' 'rc3,append)
pp=pp+1
endwhile
endif 




*--------------------------------------------------------------------------------------------------
*  BACIA DO ITAIPU  ADICIONADO EM (12/6/2015)
*
*
*
* REMOCAO DE VIES PARA DEZEMBRO E JANEIRO
*
if  ( label = "ITAIPU"  & ( mes =1  | mes =7 )) 
a=0.0036
b=0.9572
ptoteta10=(_pchuva.1+_pchuva.2+_pchuva.3+_pchuva.4+_pchuva.5+_pchuva.6+_pchuva.7+_pchuva.8+_pchuva.9+_pchuva.10)
ptotpre10=(a*(ptoteta10*ptoteta10))+b*(ptoteta10)
pp=1
while (pp<=10)
'set t ' pp
'q time'
dataprev=subwrd(result,3)
ppre.pp=_pchuva.pp*(ptotpre10/ptoteta10)
rc3 = math_format("%5.2f",ppre.pp)
yyy=write("comremocao.prn",data1' 'dataprev' 'rc3,append)
pp=pp+1
endwhile
endif 
*
* REMOCAO DE VIES PARA FEVEREIRO E MARÇO
*
if  ( label = "ITAIPU" & ( mes =2  | mes =3 )) 
a=0.0036
b=0.9572
ptoteta10=(_pchuva.1+_pchuva.2+_pchuva.3+_pchuva.4+_pchuva.5+_pchuva.6+_pchuva.7+_pchuva.8+_pchuva.9+_pchuva.10)
ptotpre10=(a*(ptoteta10*ptoteta10))+b*(ptoteta10)
pp=1
while (pp<=10)
'set t ' pp
'q time'
dataprev=subwrd(result,3)
ppre.pp=_pchuva.pp*(ptotpre10/ptoteta10)
rc3 = math_format("%5.2f",ppre.pp)
yyy=write("comremocao.prn",data1' 'dataprev' 'rc3,append)
pp=pp+1
endwhile
endif 
*
* REMOCAO DE VIES PARA NOVEMBRO E OUTUBRO
*
if  ( label = "ITAIPU" & ( mes =10  | mes =11 )) 
a=0.0036
b=0.9572
ptoteta10=(_pchuva.1+_pchuva.2+_pchuva.3+_pchuva.4+_pchuva.5+_pchuva.6+_pchuva.7+_pchuva.8+_pchuva.9+_pchuva.10)
ptotpre10=(a*(ptoteta10*ptoteta10))+b*(ptoteta10)
pp=1
while (pp<=10)
'set t ' pp
'q time'
dataprev=subwrd(result,3)
ppre.pp=_pchuva.pp*(ptotpre10/ptoteta10)
rc3 = math_format("%5.2f",ppre.pp)
yyy=write("comremocao.prn",data1' 'dataprev' 'rc3,append)
pp=pp+1
endwhile
endif 







return ptoteta10




