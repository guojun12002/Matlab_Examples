function z=sphrchop(x,y,r,doplot)
% z=sphrchop(x,y,r) plots a hemisphere of radius r
% with a slice cut off by an inclined plane. The surface
% rests on a base which is a unit square.
% x,y    - input coordinate vectors defining a plot grid.
% r      - sphere radius with 0<= r <=1. 
% doplot - optional parameter to make a surface plot when
%          nargin equals 4
% z   - array of height coordinates on the surface

if nargin<4, doplot=0; else doplot=1; end
if nargin<3, r=.4; end
if nargin==0, x=linspace(0,1,81); y=x; end
[u,v]=meshgrid(x,y);
d=(u-.5).^2+(v-.5).^2; z=real(sqrt(r^2-d));
z1=v-.5+r; k=find((z>=z1) & (d<=r^2)); z(k)=z1(k);
if doplot==0, return, end
close, surf(x,y,z), axis equal; colormap([1 1 0]); shg