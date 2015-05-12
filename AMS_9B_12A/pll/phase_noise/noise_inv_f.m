function hout=noise_inv_f(L);
% L= filter length/2
% Create a filter kernel (FIR coefficients) that approximates a 1/f frequency response.
% Dick Benson  September 2004
% Copywrite 2004-2010 The MathWorks, Inc.
if nargin==0
   L     = 128;             % filter kernel length/2
end;
f     =(0:(L-1))/L;     % frequency vector normalized to Fs/2
shape = (1./(f+0.1/L)).^0.5;  % desired shape of spectrum (note +0.1/L to limit infinity ) , 
                              % added .^0.5 to make POWER drop as 1/f
shape = shape/shape(1); % normalize DC gain to 1 (0dB)
ph    = pi*(0:L-1);     % phase shift to center impulse response in time window

% Need to create a complex spectral description 
% which, when transformed with the ifft,
% creates a REAL impulse response.

mag=[shape,0, fliplr(shape(2:end))]; % construct magnitude
phase=[-ph,0,fliplr(ph(2:end))];     % and phase 
H=mag.*exp(j*phase);  % complex representation
h=ifft(H);            % impulse reponse 

%  sanity checks .... 
subplot(2,1,1)
plot((h)); title('1/f filter impulse response (no window)');
xlabel('samples')

% If the filter is used as is, there will be ripples in the frequency reponse, 
% due to the abrupt transistions at the impulse response endpoints.
% To mitigate this, apply a Hanning window and then compare final response with
% desired. 

hout=h.*hann(2*L)';
H2=fft(hout);            % take fft of windowed filter kernel
% hf=figure;
subplot(2,1,2)
semilogx(f/2,20*log10(abs(H2(1:L))),f/2,20*log10(shape),'x'); 
legend('attained','desired')
title('overlayed freq responses of desired and attained 1/f shape');
xlabel('Normalized to Fs'); ylabel('dB')
% Finally, scale the filter so that 1 Watt of (broad band) input noise 
% produces 1 Watt of output noise. 
df   = f(2)-f(1);
Pout_T = sum(hout.^2);       % power out for 1 W input
hout = hout/sqrt(Pout_T);    % use filter_check.mdl to confirm power level and shape
f_inv = hout;
save f_inv f_inv;            % save for use by other examples.
set(gcf,'HandleVisibility','off');
