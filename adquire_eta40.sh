#/bin/bash 
#------------------------------------------------------------------------
#
#
#  SCRIPT PARA ADQUIRIR PREVISOES DO ETA 10 DIAS DO CPTEC E 
#  CALCULAR CHUVA ACUMULADA POR BACIA DO SIN 
#
#  VERSAO 2.0 
#
#
#  bY regis  reginaldo.venturadesa@gmail.com 
#  uso:
#      adquire  [00/12]
#    
# ----------------------------------------------------------------------
# Necessita de um arquivo contendo informaçoes sonre as bacias. 
#  (ver como documentar isso aqui)
#
#
#
#------------------------------------------------------------------------- 
#  TODO
#   falta o script pegar dados anteriores a data de hoje
#   ver uma forma das imagens por bacia ficarem no mesmo padrão.
#   colocar o nome da bacia na figura
#
#--------------------------------------------------------------------------

#
# Pega data do dia (relogio do micro)
# DATA0 = data de hoje
# DATA1 = data de amanha (para os produtos)
# DATA2 = data de 7 dias a frente 
# 
data=`date +"%Y%m%d"`
DATA0=`date +"%d/%m/%Y"`
DATA1=`date +"%d/%m/%Y" -d "7 days"`
DATA2=`date +"%d/%m/%Y" -d "1 days"`

#
# Existem duas rodadas do modelo ao dia. Uma as 00Z e outra as 12Z
# se nada for informada na linha de comando assume-se 00z
#
#
if [ "$1" = "" ];then 
hora="00"
else
hora=$1
fi 
#
# cria diretorio dos produtos do dia
#
cd SAIDAS
mkdir $data$hora
cd $data$hora
#
# Adquire os dados no site do CPTEC. 
# Atençao:  
# Verifique pois o CPTEC altera os caminhos sem avisar!!!
#
wget -nc ftp://ftp1.cptec.inpe.br/modelos/io/tempo/regional/Eta40km_ENS/prec24/$data$hora/*


#
# existem 10 arquivos .bin
# separados fica dificil de trabalhar com os arquivos
# por isso vou juntar todos os .bin num único do arquivo
#

rm $data$hora".bin"
rm *.ctl
for file in `ls -1 *.bin`
do
cat $file >>  $data$hora".bin"
rm $file
done
file=`echo $data$hora".bin"`
#
# caso ele não exista , algo muito errado aconteceu
#
if [ ! -s $file ]
then
 exit
fi 

#
#  crio o arquivo descriptor(CTL) de acordo com a data de hoje
#  YYYMMDDHH.BIN foi criado antes (todos os bin num unico bin)
#  modelo_all.ctl é o nome para acessar YYYMMDDHH.BIN
#
echo "DSET ^"$data$hora".bin" >modelo_all.ctl
echo "UNDEF -9999." >>modelo_all.ctl 
echo "TITLE eta 10 dias" >>modelo_all.ctl
echo "XDEF  144 LINEAR  -83.00   0.40" >>modelo_all.ctl
echo "YDEF  157 LINEAR  -50.20   0.40" >>modelo_all.ctl
echo "ZDEF   1 LEVELS 1000" >>modelo_all.ctl
echo "TDEF   10 LINEAR 12Z"`date +"%d%b%Y"`" 24hr" >>modelo_all.ctl
echo "VARS  1" >>modelo_all.ctl
echo "PREC  0  99  Total  24h Precip.        (m)" >>modelo_all.ctl
echo "ENDVARS" >>modelo_all.ctl

#
#  cria o script para a criacao de figuras de data corrida 
#
echo "'open modelo_all.ctl'"                                  >figura.gs
echo "'set mpdset hires'"                                    >>figura.gs
echo "'../../cores.gs'"                                         >>figura.gs
echo "'set gxout shaded'"                                    >>figura.gs
echo "'d sum(prec,t=2,t=8)'"                                 >>figura.gs
echo "'draw string 0.5 8.3 PRECIPITACAO ACUMULADA 7 DIAS '"  >>figura.gs
echo "'draw string 0.5 8.1 RODADA :"$DATA0" - "$hora"Z'"     >>figura.gs
echo "'draw string 0.5 7.9 Periodo:"$DATA2" a "$DATA1"'"     >>figura.gs
echo "'cbarn.gs'"                                            >>figura.gs
echo "'../../plota.gs'"                                         >>figura.gs
echo "'printim prec07dias_"$data"_"$hora"Z.png white'"       >>figura.gs
echo "'quit'"                                                >>figura.gs
#
#  cria o script para data operativa
#
echo "'open modelo_all.ctl'"            >figura2.gs
echo "'set mpdset hires'"               >>figura2.gs
echo "'set gxout shaded'"               >>figura2.gs
echo "t0=10"                            >>figura2.gs  
echo "'set t 2 last'"                   >>figura2.gs
echo "'q time'"                         >>figura2.gs
echo "var3=subwrd(result,5)"            >>figura2.gs
echo "tt=1"                             >>figura2.gs
echo "while (tt<=10)"                   >>figura2.gs
echo "'set t ' tt"                      >>figura2.gs
echo "'q time'"                         >>figura2.gs
echo "var=subwrd(result,6)"             >>figura2.gs
echo 'if (var = "Sat" )'                >>figura2.gs
echo "t0=tt"                            >>figura2.gs
echo "endif"                            >>figura2.gs
echo "tt=tt+1"                          >>figura2.gs
echo "endwhile"                         >>figura2.gs
echo "say t0"                           >>figura2.gs
echo "'set t 2 't0"                     >>figura2.gs
echo "'q time'"                         >>figura2.gs
echo "var1=subwrd(result,3)"            >>figura2.gs
echo "var2=subwrd(result,5)"            >>figura2.gs
echo "say result"                       >>figura2.gs
echo "'set t 1'"                        >>figura2.gs
echo "'../../cores.gs'"                    >>figura2.gs
echo "'d sum(prec,t=2,t='t0')'"         >>figura2.gs
echo "'cbarn.gs'"                       >>figura2.gs
echo "'draw string 0.5 8.3 PRECIPITACAO ACUMULADA SEMANA OPERATIVA 1'"  >>figura2.gs
echo "'draw string 0.5 8.1 RODADA:"$DATA0" - "$hora"Z'"                >>figura2.gs
echo "'draw string 0.5 7.9 PERIODO:'var1' a 'var2"                     >>figura2.gs
echo "'../../plota.gs'"                                                   >>figura2.gs
echo "'printim semanaoperativa_1_"$data".png white'"                       >>figura2.gs
echo "'c'"                                                             >>figura2.gs
echo "'../../cores.gs'"                    >>figura2.gs
echo "'d sum(prec,t='t0',t=10)'"         >>figura2.gs
echo "'cbarn.gs'"                       >>figura2.gs
echo "'draw string 0.5 8.3 PRECIPITACAO ACUMULADA SEMANA OPERATIVA 2 '"  >>figura2.gs
echo "'draw string 0.5 8.1 RODADA:"$DATA0" - "$hora"Z'"                >>figura2.gs
echo "'draw string 0.5 7.9 PERIODO:'var2' a 'var3"                     >>figura2.gs
echo "'../../plota.gs'"                                                   >>figura2.gs
echo "'printim semanaoperativa_2_"$data".png white'"                       >>figura2.gs
echo "say t0"                           >>figura2.gs
echo "'quit'"                          >>figura2.gs


#
#  cria o script para data operativa
#
echo "'open modelo_all.ctl'"            >figura3.gs
echo "'set mpdset hires'"               >>figura3.gs
echo "'set gxout shaded'"               >>figura3.gs
echo "t0=10"                            >>figura3.gs  
echo "'set t 2 last'"                   >>figura3.gs
echo "'q time'"                         >>figura3.gs
echo "var3=subwrd(result,5)"            >>figura3.gs
echo "tt=1"                             >>figura3.gs
echo "while (tt<=10)"                   >>figura3.gs
echo "'set t ' tt"                      >>figura3.gs
echo "'q time'"                         >>figura3.gs
echo "var=subwrd(result,6)"             >>figura3.gs
echo 'if (var = "Sat" )'                >>figura3.gs
echo "t0=tt"                            >>figura3.gs
echo "endif"                            >>figura3.gs
echo "tt=tt+1"                          >>figura3.gs
echo "endwhile"                         >>figura3.gs
echo "say t0"                           >>figura3.gs
echo "'set t 2 't0"                     >>figura3.gs
echo "'q time'"                         >>figura3.gs
echo "var1=subwrd(result,3)"            >>figura3.gs
echo "var2=subwrd(result,5)"            >>figura3.gs
echo "say result"                       >>figura3.gs
echo "status2=0"                       >>figura3.gs
echo "while(!status2)" >>figura3.gs
echo 'fd=read("../../CONTORNOS/CADASTRADAS/limites_das_bacias.dat")' >>figura3.gs
echo "status2=sublin(fd,1) "    >>figura3.gs
echo "if (status2 = 0) "        >>figura3.gs
echo "linha=sublin(fd,2)"       >>figura3.gs
echo "bacia=subwrd(linha,1)"     >>figura3.gs
echo "shape=subwrd(linha,2)"     >>figura3.gs
echo "x0=subwrd(linha,3)"       >>figura3.gs
echo "x1=subwrd(linha,4)"       >>figura3.gs
echo "y0=subwrd(linha,5)"       >>figura3.gs
echo "y1=subwrd(linha,6)"       >>figura3.gs
echo "'set lon 'x1' 'x0 "       >>figura3.gs
echo "'set lat 'y1' 'y0 "       >>figura3.gs
echo "'c'"                        >>figura3.gs
echo "'set t 1'"                        >>figura3.gs
echo "'../../cores.gs'"                    >>figura3.gs
echo "'d sum(prec,t=2,t='t0')'"         >>figura3.gs
echo "'cbarn.gs'"                       >>figura3.gs
echo "'draw string 0.5 8.3 PRECIPITACAO ACUMULADA SEMANA OPERATIVA 1'"  >>figura3.gs
echo "'draw string 0.5 8.1 RODADA:"$DATA0" - "$hora"Z'"                >>figura3.gs
echo "'draw string 0.5 7.9 PERIODO:'var1' a 'var2"                     >>figura3.gs
echo "'draw shp ../../CONTORNOS/SHAPES/'shape"                                                  >>figura3.gs
echo "say shape" >>figura3.gs
echo "'printim 'bacia'_semanaoperativa_1_"$data".png white'"                       >>figura3.gs
echo "'c'"                                                             >>figura3.gs
echo "'../../cores.gs'"                                                >>figura3.gs
echo "'d sum(prec,t='t0',t=10)'"                                       >>figura3.gs
echo "'cbarn.gs'"                                                      >>figura3.gs
echo "'draw string 0.5 8.3 PRECIPITACAO ACUMULADA SEMANA OPERATIVA 2 '">>figura3.gs
echo "'draw string 0.5 8.1 RODADA:"$DATA0" - "$hora"Z'"                >>figura3.gs
echo "'draw string 0.5 7.9 PERIODO:'var2' a 'var3"                     >>figura3.gs
echo "'draw shp ../../CONTORNOS/SHAPES/'shape"                                                        >>figura3.gs
echo "'printim 'bacia'_semanaoperativa_2_"$data".png white'"                       >>figura3.gs

echo "'c'"   >>figura3.gs
echo "'set mpdset hires'"                                    >>figura3.gs
echo "'../../cores.gs'"                                         >>figura3.gs
echo "'set gxout shaded'"                                    >>figura3.gs
echo "'d sum(prec,t=2,t=8)'"                                 >>figura3.gs
echo "'draw string 0.5 8.3 PRECIPITACAO ACUMULADA 7 DIAS '"  >>figura3.gs
echo "'draw string 0.5 8.1 RODADA :"$DATA0" - "$hora"Z'"     >>figura3.gs
echo "'draw string 0.5 7.9 Periodo:"$DATA2" a "$DATA1"'"     >>figura3.gs
echo "'cbarn.gs'"                                            >>figura3.gs
echo "'../../plota.gs'"                                         >>figura3.gs
echo "'printim 'bacia'_prec07dias_"$data"_"$hora"Z.png white'"       >>figura3.gs





echo "say t0"                           >>figura3.gs
echo "endif"                            >>figura3.gs 
echo "endwhile"                            >>figura3.gs 
echo "'quit'"                          >>figura3.gs








#
# Geracao de produtos
#
#cp ../../calcula_versao2.gs .
cp ../../calcula_versao3.gs .


grads -lbc "figura.gs"
grads -lbc "figura2.gs"
grads -lbc "figura3.gs"
grads -lbc "calcula_versao3.gs"


mkdir imagens_semanaoperativa_1
mkdir imagens_semanaoperativa_2
mkdir imagens_7dias
mv *semanaoperativa_1*  imagens_semanaoperativa_1
mv *semanaoperativa_2*  imagens_semanaoperativa_2
mv *prec07dias* imagens_7dias
cd ..



