program eta

implicit none
real x0,y0,xx,yy
integer x,y,p

open(10,file="pontos_grade_eta40.prn")
x0=-83.00
y0=-50.20
p=0
do x=0,143
  do y=0,156
     xx=x0+(x*0.40)
     yy=y0+(y*0.40)
	 p=p+1
	 write(10,*) xx,',',yy
  enddo
enddo


end program