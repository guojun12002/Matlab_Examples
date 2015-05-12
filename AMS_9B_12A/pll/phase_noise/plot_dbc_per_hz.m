% Plot simulation results with log x axis. 
% Plot only + freq terms.
% Per common practice, do not show carrier term.
% Use this script with vco_phase_noise.mdl. 

index_start = 3;   % move out from carrier (assume baseband, therefore at dc)
dF = 1/(Ts);       % from to workspace block
Frame_Length = length(Normalized_Spectrum); % from toworkspace block
Fvec = dF*((index_start-1):Frame_Length/2);
figure
One_over_f_power_spectrum_dB = 10*log10(Normalized_Spectrum(index_start)*Fvec(1)./Fvec); % create a refwerence spectrum line
semilogx(Fvec/1e6,10*log10(Normalized_Spectrum(index_start:(Frame_Length/2+1))),Fvec/1e6,One_over_f_power_spectrum_dB);
xlabel('MHz from Carrier'); ylabel('dBc/Hz'); grid on;
set(gca,'ylim',[-130,-90]); 
text(0.1, -98,'Ideal 1/f  and measured VCO noise')