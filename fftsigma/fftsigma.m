function fftsigma
% Program FFTSIGMA plots 1D Fourier series representations 
% The figures show effects of the number of series terms and use of 
% Lanczos sigma factors to smooth Gibbs oscillations. The Fourier series 
% of a periodic function with period px has the approximate
% form:
%
% f(x) = sum( exp(2i*pi/px*k*x)*c(k),...
%              k=-n:n)
%
% If the function has discontinuities, a better approximation
% can sometimes be produced by using a smoothed function fa(x)
% obtained by local averaging of f(x) as follows:
%
% fa(x) = integral(f(x+u)*du, -s<u<+s )/(2*s)
%
% where s is a small fraction of px. Wherever f(x) is
% smooth, f and fa will agree closely, but sharp edges of f(x)
% get rounded off in the averaged function fa(x). The Fourier
% coefficients ca(k) for the averaged function are simply 
% ca(k)  = c(k)*sig(k) where the sigma factors sig(k) are
% sig(k) = sin(sin(2*pi*s*k/px)/(2*pi*s*k/px))
% ( SEE Chapter 4 of 'Applied Analysis' by Cornelius Lanczos ) 

%       written by Howard Wilson, July, 2009
%       modified by Abhishek Ballaney, Dec, 2010

help fftsigma

fs = 250000;             % Original sample freq: 250 kHz
n = 0:10000;             % 10000 samples
f = 500;                 % Input frequency
x  = square(2*pi*f/fs*n); % Original signal--sinusoid at 500 Hz.

nft=512; 
c = fft(x)/nft;

n1=50;  sig1=0.005; f1=sumseries(c,x,f,n1,sig1);
n2=150; sig2=0.005;  f2=sumseries(c,x,f,n2,sig2); 
plot(n, x, n, f1, n, f2);
legend('Input','50 terms','150 terms');