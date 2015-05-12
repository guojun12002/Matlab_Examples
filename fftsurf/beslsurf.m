function z=beslsurf(x,y,doplot)
% z=beslsurf(x,y,doplot)
% This function describes a portion of the
% surface defined by Besselj(x,y)
% x,y    - vectors defining a plot grid
% doplot - optional parameter to make a surface
%          plot when nargin equals 3
if nargin<3, doplot=0; end
if nargin==0,x=linspace(0,1,81); y=x; end
[x,y]=meshgrid(x,y); z=zeros(size(x));
z=besselj(10*x,30*y).'; d=0.1;
z=z.*(x>d).*(x<1-d).*(y>d).*(y<1-d);
if doplot==0, return; end
close, surf(x,y,z); colormap([1 1 0]), shg