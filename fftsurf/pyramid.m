function z=pyramid(x,y,b,h,px,py,doplot)
% z=pyramid(x,y,b,h,px,py)
% This function defines a pyramid resting on
% a base of unit side length
if nargin<7, doplot=0; end
if nargin<6, px=1; py=1; end
if nargin<4, b=.7; h=1; end 
if nargin==0
  x=linspace(0,px,81); y=linspace(0,py,81);
end
[u,v]=meshgrid(abs(x-px/2),abs(y-py/2));
[x,y]=meshgrid(x,y); z=zeros(size(x));
kx=find(u>=v); ky=find(v>u); 
big=1000*max(px,py);
z(kx)=interp1([0,b/2,big],[h,0,0],u(kx));
z(ky)=interp1([0,b/2,big],[h,0,0],v(ky));
if doplot==0, return; end
close, surf(x,y,z), colormap([1 1 0]), shg