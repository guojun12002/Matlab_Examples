%% xtal_meas_6p188
% 1K ohm needed to be placed across GR 1606A bridge terminals to find || resonance 
% This xtal does not have any significant spurious modes near 
% primary resonance.
% Copywrite 2006-2010 The Mathworks, Inc.
% Dick Benson
clear all
clc
%        f in MHz  X      R
meas = [6.184647 -5000    10.6
        6.185548 -4000    12.4
        6.186322 -3000    14.1
        6.187017 -2000    16
        6.187597 -1000    17.8
        6.188134   0      20
        6.188607  1000    22
        6.189033  2000    24
        6.189417  3000    26
        6.189765  4000    28
        6.190075  5000    30.5 
        
        6.202298  0       1/(1/977-1/980)  % parallel resonance point, 
                                           % freq is accurate, R is not 
        ] ; 
    
% scale reactance by freq and then freq to MHz
    meas(:,2)=meas(:,2)./meas(:,1);  % GR 1606-A RF Bridge
    meas(:,1)=meas(:,1)*1e6;         % Hz
    freq = meas(:,1);
    data = meas;  
    R = data(:,3);
    X = data(:,2);
%%  separate series and parallel resonances
    series_mode = data(1:11,:);
    f_series    = meas(6,1)
    x_series    = series_mode(:,2);
    r_series    = series_mode(:,3);
    df=(series_mode(:,1)-f_series);
    grid on
    plot(df,x_series,df,r_series);
    title('Series Mode')
    legend('Reactance','Resistance'); ylabel('Ohms'), xlabel('delta f from series resonance in Hz')
   
%% parallel
    par_mode   = data(12,:);
    f_par    = meas(12,1)
    x_par    = par_mode(:,2); 
    r_par    = par_mode(:,3);
    
%% Model 
DF = f_series-f_par
w  = 2*pi*freq;
Ro = 20             % resistance at point of zero reactance  
Lo = 0.027          % tune this parameter for best match 
                    % between measurements and circuit model
Rp = 6e5;           % guestimate of loss in bridge

Co  = 1/(((2*pi*f_series)^2)*Lo)     % follows from series resonant freq
Cp  = 1/((((2*pi*f_par)^2)*Lo)-1/Co) % follows from parallel resonant freq

freq2 = [freq(1):10:(freq(end)+10000)];
w2=freq2*2*pi;

[Z1,Z2] = xtal(Lo,Co,Ro,Cp,Rp,w2); % two methods to calc xtal Z
Z=Z2;                              % but thankfully the same result
 
% plot reactance
 figure
 plot(freq2,imag(Z),freq,X,'o');
 title('Reactance')
 ylabel('Ohms'), xlabel('f in Hz')
 
%% change scale to examine series resonance
 axis([freq(1)-10,freq(11)+10,-800,800])
 % axis([freq(16)-10,freq(end)+10,-5000,5000])   

%% plot resistance
figure
plot(freq2,real(Z),freq,R,'o');
title('Resistance')
ylabel('Ohms'), xlabel('f in Hz')

%% change scale
 axis([freq(1)-10,freq(11)+10,0,35])


 
 
 
 
 
 
    
   
 