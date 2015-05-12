function [z,x,y]=frustum(x,y,ro,ri,doplot)
% [z,x,y]=frustum(x,y,ro,ri,doplot)
% This function describes a conical frustum surface.
% The top of the frustum is a circular disk of 
% radius r1 and unit height. The base radius is ro.
% The frustum rests on a rectangle of unit side length. 
% 
% x,y    - coordinate vectors defining a plotting grid.
% r0,ri  - The top and bottom radii. Use r1<=1, ro<=ri.
% doplot - optional parameter to make a plot when
%          nargin equals 5
% z,x,y   Coordinate matrices of points on the frustum.
%         On output, the x,y vectors become arrays.
if nargin<5, doplot=0; end
if nargin<4, ri=.2; end; if nargin<3, ro=.4; end
if nargin==0; y=linspace(0,1,81); x=y'; end 
[x,y]=meshgrid(x,y); r=sqrt((x-.5).^2+(y-.5).^2);
ki=find(r<ri); z=zeros(size(x));
if ~isempty(ki), z(ki)=1; end
ko=find((r<ro) & (r>=ri)); 
if ~isempty(ko), z(ko)=(ro-r(ko))/(ro-ri); end
if doplot==0, return; end
close, surf(x,y,z),colormap([1 1 0]), shg