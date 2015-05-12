function [z,x,y]=splitcyl(x,y,doplot) 
% [z,x,y]=splitcyl(x,y,doplot) 
% This function defines half of a circular cylinder of
% radius 0.5. The cylinder is split longitudinally and
% rests on a rectangular base of unit side length. 
%
% x,y    - On input these vectors define a coordinate grid.
%          On  output, the vectors a converted to arrays.
% doplot - an optional parameter to make a plot when
%          nargin equals 3
% z      - Points on the surface.
if nargin<3, doplot=0; end
if nargin==0, m=81; x=linspace(0,1,m)'; y=x'; end
m=length(x); [x,y]=meshgrid(x,y);
r=sqrt((x-.5).^2+(y-.5).^2); z=zeros(m,m);
k=find(r<=.25); z(k)=1; z=z.*(x+y>=1);
if doplot==0, return; end
close, surf(x,y,z),colormap([1,1,0]), shg