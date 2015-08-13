function [ tadentro ] = verifica_se_ta_dentro( contorno, dados )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

x=contorno(:,1);
y=contorno(:,2);
xx=dados(:,1);
yy=dados(:,2);

tadentro=inpolygon(x,y,xx,yy);


end

