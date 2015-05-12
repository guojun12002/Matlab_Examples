function readme, help readme
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
%
%======================================================
%
% The workspace contains the following functions
% fft2surf  - main driver program together with all functions
% getftcof  - computes the double Fourier series coefficients
% sumseries - sums the double Fourier series
% makesurf  - plots two surfaces shown side by side
% getaxis   - computes scale factor to show two figure together  
% sphrchop  - a hemisphere with a slice cut off
% frustum   - a conical frustum
% pyramid   - a pyramid with a square base
% cylincut  - a circular cylinder cut by an inclined plane
% splitcyl  - a circular cylinder split longitudinally
% besmode   - a vibration mode of a circular membrane
% beslsurf  - a surface showing z = besselj(x,y)
% house     - a surface shape resembling a house
% readme    - describes the program and related functions