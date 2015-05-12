function z=cylincut(x,y,r,doplot) 
% z=cylincut(x,y,r,doplot) 
% This function defines a circular cylinder
% of radius r cut by an inclined plane
if nargin<4, doplot=0; end
if nargin<3, r=.375; end
if nargin==0, m=81; x=linspace(0,1,m); y=x; end 
s=.25/r; m=length(x); [u,v]=meshgrid(x,y);
rr=sqrt((u-.5).^2+(v-.5).^2);z=zeros(m,m);
k=find(rr<=r); z(k)=.5+s*(v(k)-.5+r);
if doplot==0, return; end
close, surf(x,y,z),colormap([1,1,0]),shg