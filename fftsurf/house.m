function z=house(x,y,px,py,h,doplot)
% z=house(x,y,px,py,h,doplot)
% This function creates a surface resembling a house
% with a slanted roof. 
% x,y   - vectors with 0<=x(i)<=px and 0<=y(i)<=py
% px,py - side dimension lengths
if nargin<6, doplot=0; end
if nargin<5, h=1; end, if nargin<4, px=1; py=1; end
if nargin==0
  x=linspace(0,px,88); y=linspace(0,py,88);
end 
[u,v]=meshgrid(x,y); z=zeros(size(u));
d=.05*px; t=px/1e12;
k1=find(u>2*px/3 & u<=px-d); 
z(k1)=interp1([0,d-t,d,py/2,py-d,py-d+t,py],...
              [0,0,h/2,h,h/2,0,0],v(k1));
k2=find(u>=d & u<=(2*px/3) & v>=(py/2) & v<=(py-d));
z(k2)=interp1([d,px/3,2*px/3],[0,h/2,h/2],u(k2));
if doplot==0, return, end
surf(u,v,z),colormap([1,1,0]); shg