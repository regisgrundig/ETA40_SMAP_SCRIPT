

 [y,x]=ndgrid(-40:0.25:9.75,-80:0.25:-30.25);
 
 pid=fopen('pontos_de_grade_25km.prn','w');
 
 for i=1:200
     for j=1:200
          fprintf(pid,'%f %f\n',x(i,j),y(i,j))
     end
     
     
 end
 