function fft2surf 
% Program FFT2SURF plots double Fourier series representations 
% for several different surfaces. The figures show effects of
% the number of series terms and use of Lanczos sigma factors
% to smooth Gibbs oscillations. The Fourier series of a doubly
% periodic function with periods px and py has the approximate
% form:
%
% f(x,y) = sum( exp(2i*pi/px*k*x)*c(k,m)*exp(2i*pi/py*m*y),...
%              k=-n:n, m=-n:n)
%
% If the function has discontinuities, a better approximation
% can sometimes be produced by using a smoothed function fa(x,y)
% obtained by local averaging of f(x,y) as follows:
%
% fa(x,y) = integral(f(x+u,y+v)*du*dv, -s<u<+s, -s<v<+s )/(4*s^2)
%
% where s is a small fraction of min(px,py). Wherever f(x,y) is
% smooth, f and fa will agree closely, but sharp edges of f(x,y)
% get rounded off in the averaged function fa(x,y). The Fourier
% coefficients ca(k,m) for the averaged function are simply 
% ca(k,m)  = c(k,m)*sig(k,m) where the sigma factors sig(k,m) are
% sig(k,m) = sin(sin(2*pi*s*k/px)*sin(2*pi*s*m/py)/...
%                ((2*pi*s*k/px)*(2*pi*s*m/py)) 
% ( SEE Chapter 4 of 'Applied Analysis' by Cornelius Lanczos ) 

%       written by Howard Wilson, July, 2009

disp(' ')
disp('     DOUBLE FOURIER SERIES REPRESENTATION OF')
disp('            EIGHT DIFFERENT SURFACES')
disp(' ')
help fft2surf

disp('  PRESS ENTER TO SEE THE PLOTS. THEN PRESS ENTER AFTER VIEWING')
disp('  EACH PLOT. ESPECIALLY NOTE THE EFFECTS OF PARAMETERS N AND S.')
disp(' '), pause

% Choose various parameters for plotting
x=linspace(0,1,101); y=x; nft=512; px=1; py=1;

% Define the grid used by FFT2
xf=linspace(0,px*(nft-1)/nft,nft);
yf=linspace(0,py*(nft-1)/nft,nft); 
x=linspace(0,px,101); y=linspace(0,py,101); close all

ti='Sliced Hemisphere';
c=getftcof(@sphrchop,px,py,nft); 
n1=8;  sig1=0; f1=sumseries(c,x,y,px,py,n1,sig1);
n2=50; sig2=0; f2=sumseries(c,x,y,px,py,n2,sig2); 
makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2), pause, close all

ti='Conical Frustum';
c=getftcof(@frustum,px,py,nft); 
n1=8;  sig1=0; f1=sumseries(c,x,y,px,py,n1,sig1);
n2=50; sig2=0; f2=sumseries(c,x,y,px,py,n2,sig2);
makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2), pause, close all

ti='Pyramid';
c=getftcof(@pyramid,px,py,nft); 
n1=8;  sig1=0; f1=sumseries(c,x,y,px,py,n1,sig1);
n2=50; sig2=0; f2=sumseries(c,x,y,px,py,n2,sig2);
makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2), pause, close all 

ti='Cut Cylinder';
c=getftcof(@cylincut,px,py,nft); 
n1=20;  sig1=0;     f1=sumseries(c,x,y,px,py,n1,sig1);
n2=200; sig2=0.005; f2=sumseries(c,x,y,px,py,n2,sig2);
makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2), pause, close all

ti='Split Cylinder';
c=getftcof(@splitcyl,px,py,nft); 
n1=100;  sig1=0;    f1=sumseries(c,x,y,px,py,n1,sig1);
n2=200; sig2=0.005; f2=sumseries(c,x,y,px,py,n2,sig2);
makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2), pause, close all

ti='Membrane Modal Surface';
c=getftcof(@besmode,px,py,nft); 
n1=8;  sig1=0;     f1=sumseries(c,x,y,px,py,n1,sig1);
n2=50; sig2=0.005; f2=sumseries(c,x,y,px,py,n2,sig2);
makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2), pause, close all

ti='Bessel Function';
c=getftcof(@beslsurf,px,py,nft); 
n1=10;  sig1=0;     f1=sumseries(c,x,y,px,py,n1,sig1);
n2=200; sig2=0.005; f2=sumseries(c,x,y,px,py,n2,sig2);
makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2), pause, close all

ti='House';
c=getftcof(@house,px,py,nft); 
n1=20;  sig1=0;     f1=sumseries(c,x,y,px,py,n1,sig1);
n2=200; sig2=0.005; f2=sumseries(c,x,y,px,py,n2,sig2); 
makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2), pause

disp('  All Done'), close all, disp(' ')

%================================================

function c=getftcof(fun,px,py,nft)
% c=getftcof(fun,px,py,nft)
% This function generates the complex Fourier
% coefficients.

% Define the grid used by FFT2
xf=linspace(0,px*(nft-1)/nft,nft);
yf=linspace(0,py*(nft-1)/nft,nft);

% Evaluate the Fourier coefficients
ft=feval(fun,xf,yf); c=fft2(ft)/nft^2;

%================================================

function f=sumseries(c,x,y,px,py,n,sig)
% f=sumseries(c,x,y,px,py,n,sig)
% This function evaluates partial sums of the double
% Fourier series using coefficients computed by fft2. 
% c       matrix of complex Fourier coefficients
% x,y     matrices having the x and y coordinate
%         values stored as columns
% px,py   periods in the x and y directions
% n     - The series is summed over limits -n:n 
%         in each summation direction
% sig   - Lanczos sigma factor which is normally a  
%         small fraction of the period in each 
%         direction. sig=.005 is a typical value.

% Keep only the desired coefficients
if nargin<7, sig=0; end
nft=size(c,1); n=min(n,fix(nft/2)-1);
k=[(nft+1-n):nft,1:n+1]; c=c(k,k); 

% Smooth the series coefficients if desired
if sig>0
  w=sin(2*pi*sig*(1:n))./(2*pi*sig*(1:n)); 
  w=[w(end:-1:1),1,w]; c=(w'*w).*c; 
end

% Sum the series
m=-n:n;
f=real(exp(2i*pi/px*x(:)*m)*c*exp(2i*pi/py*m'*y(:)'));

%================================================

function makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2)
% makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2)
% This function plots two surfaces juxtaposed 
% in fullscreen mode
titl=@(ti,n,sig) [ti,' for n = ',num2str(n),...
               '  &  s = ',num2str(sig)];
close; range=getaxis(x,y,f1,f2);  
subplot(1,2,1), surf(x,y,f1), title(titl(ti,n1,sig1))
xlabel('x axis'),ylabel('y axis'), zlabel('z axis')
axis equal, axis(range), subplot(1,2,2)
surf(x,y,f2), title(titl(ti,n2,sig2))
xlabel('x axis'),ylabel('y axis'), zlabel('z axis')
axis equal, axis(range),colormap([1 1 0])
u=get(gcf,'units');
set(gcf,'units','normalized','outerposition',[0,0,1,1]);
set(gcf,'units',u),shg   

%================================================

function range=getaxis(x,y,f1,f2)
% range=getaxis(x,y,f1,f2)
xmin=min(x(:)); xmax=max(x(:)); 
ymin=min(y(:)); ymax=max(y(:));
fmin=min([f1(:);f2(:)]); fmax=max([f1(:);f2(:)]);
range=[xmin,xmax,ymin,ymax,fmin,fmax];

%===============================================

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

%================================================

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

%================================================

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

%================================================

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

%================================================

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
 
 %===============================================
 
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

%================================================

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

%================================================

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