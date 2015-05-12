 function z=besmode(x,y,doplot)
% z=besmode(x,y,doplot)
% This function defines a particular natural
% vibration mode of a circular membrane with
% a radius equal to 0.4
% x,y    - vectors with 0<x(i)<1, and 0,y(i)<1
% dopolt - optional parameter to make a surface
%          plot when nargin equals 3
if nargin<3, doplot=0; end
n=2; k=2; nr=41; nt=81;
if nargin==0, x=linspace(0,1,81)'; y=x'; end 
r0=.4; rt=8.41724414039987;  
[u,v]=meshgrid(x,y); 
r=sqrt((u-.5).^2+(v-.5).^2); th=atan2(u-.5,v-.5); 
z=besselj(n,rt/r0*r).*sin(n*th).*(r<=r0); 
if doplot==0, return; end
close, surf(u,v,z),colormap([1 1 0]), shg