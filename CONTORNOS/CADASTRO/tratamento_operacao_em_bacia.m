shapes ={ 'jacui.shp'
    'contorno_paranaiba.shp'
'contorno_tiete.shp'
'contorno_iguacu.shp'
'contorno_parana.shp'
'contorno_paraiba_sul2.shp'
'contorno_sfrancisco.shp'
'contorno_jequitinhonha.shp'
'contorno_Grande.shp'
'contorno_paranapanema.shp'
'contorno_tocantins.shp'
'contorno_uruguai.shp' 
'itaipu.shp'
'itaipu_e.shp'
'itaipu_d.shp'};

bacias ={ 'jacui.bln'
'contorno_paranaiba.bln'
'contorno_tiete.bln'
'contorno_iguacu.bln'
'contorno_parana.bln'
'contorno_paraiba_sul2.bln'
'contorno_sfrancisco.bln'
'contorno_jequitinhonha.bln'
'contorno_Grande.bln'
'contorno_paranapanema.bln'
'contorno_tocantins.bln'
'contorno_uruguai.bln'
'itaipu.bln'
'itaipu_e.bln'
'itaipu_d.bln'};


output = { 'jacui'
    'paranaiba'
    'tiete'
    'iguacu'
    'parana'
    'paraibadosul'
    'saofrancisco'
    'jequitinhonha'
    'grande'
    'paranapanema'
    'tocantins'
    'uruguai'
    'itaipu'
    'itaipu_e'
    'itaipu_d'};

cadastro= {
'grande.bacia GRANDE'
'iguacu.bacia IGUACU'
'jacui.bacia JACUI'
'jequitinhonha.bacia JEQUITINHONHA'
'paraibadosul.bacia PARAIBADOSUL'
'parana.bacia PARANA'
'paranaiba.bacia PARANAIBA'
'paranapanema.bacia PARANAPANEMA'
'saofrancisco.bacia SAOFRANCISCO'
'tiete.bacia TIETE'
'tocantins.bacia TOCANTINS'
'uruguai.bacia URUGUAI'
'itaipu.bacia ITAIPU'
'itaipu_d.bacia ITAIPU_D'
'itaipu_e.bacia ITAIPU_E' };

[ numB, ~]=size(bacias);

pid=fopen('../CADASTRADAS/limites_das_bacias.dat','w');
for i=1:numB

m1=dlmread(char(bacias(i,1)),',',2);
%n1=dlmread('pontos_grade_eta40.prn',',');
n1=dlmread('pontos_de_grade_25km.prn',' ');




in1=verifica_se_ta_dentro(n1,m1);

x0=max(m1(:,1));
x1=min(m1(:,1));
y0=max(m1(:,2));
y1=min(m1(:,2));
  fprintf(pid,'%s %s %10.4f %10.4f %10.4f %10.4f\n',char(output(i,1)),char(shapes(i,1)),x0,x1,y0,y1);

[ii ,jj]=size(in1);
fid=fopen(strcat('../CADASTRADAS/',char(output(i,1)),'.bacia'),'w');


for  j=1:ii
     if (in1(j) == 1)
     fprintf(fid,'%10.4f %10.4f %d\n',n1(j,1),n1(j,2),in1(j));
   
     end 
end

end

pid2=fopen('../../bacias','w');
for i=1:length(cadastro)
fprintf(pid2,'%s\n',cadastro{i});
end


fclose('all');
