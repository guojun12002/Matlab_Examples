function f=sumseries(c,x,px,n,sig)
% f=sumseries(c,x,px,n,sig)
% This function evaluates partial sums of 1D
% Fourier series using coefficients computed by fft. 
% c       vector of complex Fourier coefficients
% x       vector having the x coordinate
%         values stored as columns
% px      period in the x direction
% n     - The series is summed over limits -n:n 
%         in each summation direction
% sig   - Lanczos sigma factor which is normally a  
%         "small fraction of the period" in each 
%         direction. sig=.005 is a typical value.

% Keep only the desired coefficients
%  if nargin<5, sig=0; end
nft=size(c,2); n=min(n,fix(nft/2)-1);
k=[(nft+1-n):nft,1:n+1]; c=c(k); 

% Smooth the series coefficients if desired
if sig>0
  w=(sin(2*pi*sig*(1:n))./(2*pi*sig*(1:n)));
  w=[w(end:-1:1),1,w];
  c =w.*c; 
end

% Sum the series
m=-n:n;
%f=real(exp(2i*pi/px*x(:)*m)*c*exp(2i*pi/py*m'*y(:)'));
g = exp(2i*pi/px*x(:)*m);
h = g*c';
f = real(h);