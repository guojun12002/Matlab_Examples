function c=getftcof(fun,px,py,nft)
% c=getftcof(fun,px,py,nft)
% This function generates the complex Fourier
% coefficients.

% Define the grid used by FFT2
xf=linspace(0,px*(nft-1)/nft,nft);
yf=linspace(0,py*(nft-1)/nft,nft);

% Evaluate the Fourier coefficients
ft=feval(fun,xf,yf); c=fft2(ft)/nft^2;