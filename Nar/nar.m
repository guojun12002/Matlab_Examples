%---------NAR------------%
% Date : 20/01/2012
% Bilkent University
% Analysis of Rankine Cycle with MATLAB
% Authors: Ceren Yýldýz & Gökberk Kabacaoglu
% Advisor : Asst. Prof. Dr. Barbaros Cetin
% Symbols of Elements
% C = Condenser
% P = Pump
% B = Boiler
% T = Turbine
% 
% Pressure in kpa , Temperature in o^C, Quality = 1 if saturated vapor; 
%                                       Quality = 0 if saturated liquid
% If you experience any problem, you shall look at ReadMe.txt
clear all; clc;


% GETTING INPUT
% Read Data from .txt
fid = fopen('inputReheat.txt');
% read column headers
C_text = textscan(fid, '%s',7);
% read numeric data
C_data0 = textscan(fid, '%f %f %f %f %f %f %f','treatAsEmpty', {'Condenser', 'Turbine1','Turbine2','Boiler','Pump','Reheat','-','C', 'T','B','P'},'EmptyValue', -1);
control1 = C_data0{1};
control2 = C_data0{6};
fclose(fid);
%------------------Program Starts-----------------------------------------
if ( length(control1) == 4) % 4 Components in Cycle
    if( control2(1) > 0 && control2(1) < 1 )
 %--------------------Irreversible Rankine Cycle---------------------------
 % Read Data from .txt
fid = fopen('inputIrrevers.txt');
% read column headers
C_text = textscan(fid, '%s',7);
% read numeric data
C_data0 = textscan(fid, '%f %f %f %f %f %f %f','treatAsEmpty', {'C', 'T','B','P','-'},'EmptyValue', -1);
fclose(fid);
 state    = C_data0{1};
 P        = C_data0{3};
 T        = C_data0{4};
 x        = C_data0{5};
 n        = C_data0{6}; %Isentropic Efficiencies of pump and turbine
 W_output = C_data0{7}; 
 %--------------------------------------------------------------------------
% Arrangements for Pressures; these come from the theoretical information
% of Rankine Cycle
if( P(1) == -1 )
     P(1) = P(4);
 elseif( P(4) == -1 )
     P(4) = P(1);
end
 
if( P(2) == -1 )
    P(2) = P(3);
elseif( P(3) == -1 )
    P(3) = P(2);
end

 P = P * (10^(-2)); % 1 kpa = 10^(-2) bar
%--------------------------------------------------------------------------
% DETERMINING THE TEMPERATURE;ENTROPY;ENTHALPY FOR STATES

% Arrays of h2s,s2s keep the values of Ideal Rankine Cycle
% Arrays of h,s     keep the values of Rankine Cycle with Irreversibilities

% 1) BEFORE TURBINE 
if ( x(1) == 1 )                           % Saturated Vapor
    h2s(1) = XSteam('hv_p',P(1));
    T2s(1) = XSteam('T_ph',P(1),h2s(1));
    s2s(1) = XSteam('sv_p',P(1));
    v(1)   = XSteam('vV_p',P(1));
elseif( x(1) == -1 )
    % T(1) > XSteam('Tsat_p',P(1))       % SuperHeated Vapor
    h2s(1) = XSteam('h_pT',P(1),T(1));
    T2s(1) = XSteam('T_ph',P(1),h2s(1));
    s2s(1) = XSteam('s_pT',P(1),T(1));
    v(1)   = XSteam('v_pT',P(1),T(1));
else                                     % Two - Phase Mixture
    T(1) = XSteam('Tsat_p',P(1));
    h2s(1) = XSteam('h_px',P(1),x(1));
    T2s(1) = XSteam('T_ph',P(1),h2s(1));
    s2s(1) = XSteam('s_px',P(1),x(1));
    v(1)   = XSteam('v_px',P(1),x(1));
end
h(1) = h2s(1);
T(1) = T2s(1);                                                                   
s(1) = s2s(1);

% 2) BEFORE CONDENSER
s2s(2)   = s2s(1);
x2s(2) = (s2s(2) - XSteam('sL_p',P(2)))/(XSteam('sv_p',P(2))-XSteam('sL_p',P(2))); % Liquid-Vapor Fraction
if ( x2s(2) < 1 && x2s(2) > 0) % If the working fluid is two phase mixture
    h2s(2) = XSteam('h_px',P(2),x2s(2));
    T2s(2) = XSteam('Tsat_p',P(2));
else                           % If the working fluid is superheated vapor
    h2s(2) = XSteam('h_ps',P(2),s2s(2));
    T2s(2) = XSteam('T_ps',P(2),s2s(2));
end
% Since there is irreversibility
 h(2) = h(1) - n(1) * (h(1) - h2s(2));
 s(2) = XSteam('s_ph',P(2),h(2));
 T(2) = XSteam('T_ph',P(2),h(2));
 
% 3) BEFORE PUMP
% It is assumed that the fluid coming into pump is saturated liquid
h2s(3)   = XSteam('hL_p',P(3));                                                             
h(3)     = h2s(3);
v(3)     = XSteam('vL_p',P(3));                                                             
T2s(3)   = XSteam('T_ph',P(3),h2s(3));
T(3)     = T2s(3);
s2s(3)   = XSteam('sL_T',T(3));
s(3)     = s2s(3);

% 4) BEFORE BOILER
s2s(4) = s(3);
if ( s2s(4) < XSteam('sL_p',P(4)) ) % Which means that the fluid is compressed liquid 
   h2s(4) = h2s(3)+v(3)*(P(4)-P(3))*100; % *100 because we must use kpa in equation
   T2s(4) = XSteam('T_ps',P(4),s2s(4));
elseif ( s2s(4) == XSteam('sL_p',P(4))) % Saturated Liquid
   h2s(4) = XSteam('hL_p',P(4));
   T2s(4) = XSteam('Tsat_p',P(4));
else                                    % Two Phase Mixture
   x2s(4)   = (s2s(4) - XSteam('sL_p',P(4))) / (XSteam('sv_p',P(4)) - XSteam('sL_p',P(4)));
   h2s(4)   = XSteam('h_px',P(4),x2s(4));  
   T2s(4)   = XSteam('Tsat_p',P(4)); 
end
% Since there is irreversibility
h(4)   = (h2s(4) - h(3)) / n(3) + h(3);
s(4)   = XSteam('s_ph',P(4),h(4));
T(4)   = XSteam('T_ps',P(4),s(4));

% Arrangements for plotting to be accurate 
T5 = T(1);
s5 = XSteam('sL_T',T5);

% Mass Flow Rate m_dot[kg/s] and Thermal Efficiency Calculation
m_dot_ideal    = W_output(1) / ((h2s(1) - h2s(2)) - (h2s(4) - h2s(3)));
nthermal_ideal = (h2s(1)-h2s(2)+h2s(3)-h2s(4))/(h2s(1)-h2s(4));     
m_dot          = W_output(1) / ((h(1) - h(2)) - (h(4) - h(3)));
nthermal       = (h(1)-h(2)+h(3)-h(4))/(h(1)-h(4));

% DISPLAY OF RESULTS
disp('      RESULTS       ')
disp(' ------------------ ')
% For Irreversible Rankine Cycle

Wdot_turbine = m_dot * (h(1) - h(2)) ; % [ kW ]
Wdot_pump    = m_dot * (h(4) - h(3)) ; % [ kW ]
Qdot_in      = m_dot * (h(1) - h(4)) ; % [ kW ]
Qdot_out     = m_dot * (h(2) - h(3)) ; % [ kW ]
Wdot_cylce   = Wdot_turbine - Wdot_pump ; % [ kW ]

BWR          = Wdot_pump / Wdot_turbine ;
disp(' Results for Rankine Cycle with IRREVERSIBILITIES ' )
disp('--------------------------------------------------' )
disp(['Mass Flow Rate = ',num2str(m_dot,'%3.2f'),' [kg/s] '])
disp(['Thermal Efficiency = ',num2str(nthermal,'%1.2f')])
disp('')
disp('WorkPump[kW]    WorkTurbine[kW]     Qin[kW]   Qout[kW/s]   WorkCycle[kW]  BackWorkRatio')
disp('--------------  ----------------   ---------  ----------  --------------- -------------  ')
d=sprintf('   %3.1f         %3.1f          %3.1f     %4.1f      %1.3f    %1.5f ', Wdot_pump,Wdot_turbine,Qdot_in,Qdot_out,Wdot_cylce,BWR);
disp(d)
disp(' ')
disp('STATE   P[kPa]  T[^oC]  h[kj/kg]   s[kj/K.kg]  ')
disp('-----  ------- -------  --------   ---------  ')
for i = 1 : length(state)
    d = sprintf('   %1d   %3.1f   %3.1f   %4.1f   %1.4f \n', state(i),P(i)*100,T(i),h(i),s(i));
    disp(d)
end

% For Ideal Rankine Cycle

Wdot_turbine_Ideal = m_dot_ideal * (h2s(1) - h2s(2)) ; % [ kW ]
Wdot_pump_Ideal    = m_dot_ideal * (h2s(4) - h2s(3)) ; % [ kW ]
Qdot_in_Ideal      = m_dot_ideal * (h2s(1) - h2s(4)) ; % [ kW ]
Qdot_out_Ideal     = m_dot_ideal * (h2s(2) - h2s(3)) ; % [ kW ]
Wdot_cylce_Ideal   = Wdot_turbine_Ideal - Wdot_pump_Ideal ; %  [ kW ]

BWR_Ideal          = Wdot_pump / Wdot_turbine ;
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ');
disp('Results for IDEAL Rankine Cycle')
disp('--------------------------------' )
disp(['Mass Flow Rate = ',num2str(m_dot_ideal,'%3.2f'),' [kg/s] '])
disp(['Thermal Efficiency = ',num2str(nthermal_ideal,'%1.2f')])
disp('')
disp('WorkPump[kW]    WorkTurbine[kW]     Qin[kW]   Qout[kW/s]   WorkCycle[kW]  BackWorkRatio')
disp('--------------  ----------------   ---------  ----------  --------------- -------------  ')
d=sprintf('   %3.1f           %3.1f        %3.1f     %4.1f      %1.3f     %1.5f ', Wdot_pump_Ideal,Wdot_turbine_Ideal,Qdot_in_Ideal,Qdot_out_Ideal,Wdot_cylce_Ideal,BWR_Ideal);
disp(d)
disp(' ')
disp('STATE   P[kPa]  T[^oC]  h[kj/kg]   s[kj/K.kg]  ')
disp('-----  ------- -------  --------   ---------  ')
for i = 1 : length(state)
    d = sprintf('   %1d   %3.1f   %3.1f   %4.1f   %1.4f \n', state(i),P(i)*100,T(i),h2s(i),s2s(i));
    disp(d)
end

% PLOTTING

% To get Liquid - Vapor Dome
[Tsat Ssat] = makedome;
% Couple of arrangements for plotting
[T_iso_p1,s_iso_p1,T_iso_p2,s_iso_p2] = getisobars(P,T,s);
s2s(5) = s5; s2s(6) = s2s(1); T2s(5) = T5; T2s(6) = T(1);
s(5)   = s5; s(6)   = s(1)  ; T(5)   = T5; T(6)   = T(1);

plot(Ssat,Tsat,'b','linewidth',2)
hold on
plot(s_iso_p2,T_iso_p2,'--r','linewidth',2);
plot(s_iso_p1,T_iso_p1,'--r','linewidth',2);
plot(s,T,'-cs','linewidth',2);
plot(s2s,T2s,'--co','linewidth',2);
set(gca,'fontsize',14,'fontweight','demi','fontname','calibri')

for i = 1 : 4
    if ( i == 4 )
    text(s(i)-0.25,T(i)+15,num2str(state(i)),'FontSize',14,'FontWeight','demi');
    else
    text(s(i)+0.1,T(i)-6,num2str(state(i)),'FontSize',14,'FontWeight','demi');    
    end
end
for i = 1 : 2
    if ( i == 2 )
    text(s2s(i*2)+0.3,T(i*2)+17,'4s','FontSize',14,'FontWeight','demi');
    else
    text(s2s(i*2)-0.3,T(i*2)-6,'2s','FontSize',14,'FontWeight','demi');    
    end
end

text1 = ['P(2) = ',num2str(P(2) * 100),' kPa' ];    
text(s_iso_p1(4)-0.5,T_iso_p1(4)+5,text1,'FontSize',12,'FontWeight','demi');
text2 = ['P(1) = ',num2str(P(1) * 100),' kPa' ]; 
text(s_iso_p2(5)+0.1,T_iso_p2(5)-5,text2,'FontSize',12,'FontWeight','demi');

title('Rankine Cycle with Irreversibilities');
xlabel(' Entropy ( kJ/kg.K ) ');
ylabel(' Temperature (C) ');
hold off
x_r = 0.5927 ; y_r = 41.525 ; w_r = 0.0002 ; h_r = 0.32 ;
rectangle('Position', [x_r, y_r, w_r, h_r],'EdgeColor', [0.4, 0.1, 0.4]);
x_a = 0.16; y_a = .6; w_a = 0.2; h_a = 0.3;
ax = axes('Units', 'normalized', ...
          'Position', [x_a, y_a, w_a, h_a], ...
          'Box', 'on', ...
          'Color', [0.95, 0.99, 0.95]);
hold on;
plot(Ssat,Tsat,'b','linewidth',2)
hold on
plot(s_iso_p2,T_iso_p2,'--r','linewidth',2);
plot(s_iso_p1,T_iso_p1,'--r','linewidth',2);
plot(s,T,'-cs','linewidth',2);
plot(s2s,T2s,'--co','linewidth',2);
axis([s(3)-0.0006 s(3)+0.005 T(3)-0.06 T2s(4)+0.45])
text(s(4),T(4)+0.03,num2str(state(4)),'FontSize',8,'FontWeight','demi');
text(s2s(4),T2s(4)+0.03,'4s','FontSize',8,'FontWeight','demi');
text(s(3),T(3)+0.03,num2str(state(3)),'FontSize',8,'FontWeight','demi');
set(gca,'XTick',[s(3):0.005:s(3)+0.005])
set(gca,'YTick',[T(3):T(4)-T(3):T(4)])
set(gca,'XTickLabel',[num2str(s(3),'%1.3f');num2str(s(3)+0.005,'%1.3f')])
set(gca,'YTickLabel',[num2str(T(3),'%1.2f');num2str(T(4),'%1.2f')])
figure
RankineDrawing
title(' Schematic Drawing of Rankine Cycle ','fontsize',14,'fontweight','demi','fontname','calibri');
axis off
    else
 %-------------------------Reversible Rankine Cycle------------------------
 % Read Data from .txt
fid = fopen('inputRevers.txt');
% read column headers
C_text = textscan(fid, '%s',6);
% read numeric data
C_data0 = textscan(fid, '%f %f %f %f %f %f','treatAsEmpty', {'C', 'T','B','P','-'},'EmptyValue', 0);
fclose(fid);
 % Read Data from .txt
 state = C_data0{1};
 P = C_data0{3};
 T = C_data0{4};
 x = C_data0{5};
 W_output = C_data0{6};
 P(3) = P(2); % We assume that pressures of Condenser and Turbine are taken as an input
 P(4) = P(1);
 T(3) = T(2);
 P = P * (10^(-2)); % 1 kpa = 10^(-2) bar
%  Solve the Problem

% 1) BEFORE TURBINE 
h(1) = XSteam('hv_p',P(1));       % [kj/kg]
T(1) = XSteam('T_ph',P(1),h(1));  % [o^C]
s(1) = XSteam('sv_p',P(1));       % [kj/(kgK)]
v(1) = XSteam('vV_p',P(1));       % [m^3/kg]

% 2) BEFORE CONDENSER
s(2) = s(1);
if ( x(2) == 0 )
x(2) = (s(2)-XSteam('sL_p',P(2)))/(XSteam('sv_p',P(2))-XSteam('sL_p',P(2)));
end
h(2) = XSteam('h_ps',P(2),s(2));                                                            
T(2) = XSteam('T_ph',P(2),h(2));

% 3) BEFORE PUMP
h(3) = XSteam('hL_p',P(3));                                                             
v(3) = XSteam('vL_p',P(3));                                                             
T(3) = XSteam('T_ph',P(3),h(3));
s(3) = XSteam('sL_T',T(3));

% 4) BEFORE BOILER
h(4) = h(3)+v(3)*(P(4)-P(3))*100; % *100 because we must use kPa in that equation
v(4) = XSteam('v_ph',P(4),h(4));
s(4) = s(3);
T(4) = XSteam('T_ps',P(4),s(4));

% INSIDE BOILER BEFORE TURBINE

T5 = T(1);
s5 = XSteam('sL_T',T5);

% Mass Flow Rate m_dot[kg/s]

m_dot = W_output(1) / ((h(1) - h(2)) - (h(4) - h(3)));
nthermal = (h(1)-h(2)+h(3)-h(4))/(h(1)-h(4));     
disp( ' RESULTS ' )
disp( '---------' )
disp(['Mass Flow Rate = ',num2str(m_dot,'%3.2f'),' [kg/s] '])
disp(['Thermal Efficiency = ',num2str(nthermal,'%1.2f')])



% Work_dot of Turbine, Pump ; Qdot_in, Qdot_out; BWR = back work ratio
Wdot_turbine = m_dot * (h(1) - h(2)) ; % [ kW ]
Wdot_pump    = m_dot * (h(4) - h(3)) ; % [ kW ]
Qdot_in      = m_dot * (h(1) - h(4)) ; % [ kW ]
Qdot_out     = m_dot * (h(2) - h(3)) ; % [ kW ]
Wdot_cylce   = Wdot_turbine - Wdot_pump ; % [ kW ]

BWR          = Wdot_pump / Wdot_turbine ;
disp(' ')
disp('WorkPump[kW]    WorkTurbine[kW]     Qin[kW]   Qout[kW/s]  WorkCycle[kW] BackWorkRatio')
disp('--------------  ----------------   ---------  ----------  --------------- -------------  ')
d=sprintf('   %3.1f            %3.1f       %3.1f      %4.1f       %1.3f      %1.5f ', Wdot_pump,Wdot_turbine,Qdot_in,Qdot_out,Wdot_cylce,BWR);
disp(d)
disp(' ')
disp('STATE   P[kPa]  T[^oC]  h[kj/kg]   s[kj/K.kg]  ')
disp('-----  ------- -------  --------   ---------  ')
for i = 1 : length(state)
    d = sprintf('   %1d   %3.1f   %3.1f   %4.1f   %1.4f \n', state(i),P(i)*100,T(i),h(i),s(i));
    disp(d)
end

% PLOTTING

% To get Liquid - Vapor Dome
[Tsat Ssat] = makedome;

[T_iso_p1,s_iso_p1,T_iso_p2,s_iso_p2] = getisobars(P,T,s);
s(5) = s5;s(6) = s(1); T(5) = T5; T(6) = T(1);

plot(Ssat,Tsat,'b','linewidth',2)
hold on
plot(s_iso_p2,T_iso_p2,'--r','linewidth',2);
plot(s_iso_p1,T_iso_p1,'--r','linewidth',2);
plot(s,T,'-cs','linewidth',2);
set(gca,'fontsize',14,'fontweight','demi','fontname','calibri')

text1 = ['P(2) = ',num2str(P(2) * 100),' kPa' ];    
text(s_iso_p1(4)-0.5,T_iso_p1(4)+5,text1,'FontSize',12,'FontWeight','demi');
text2 = ['P(1) = ',num2str(P(1) * 100),' kPa' ]; 
text(s_iso_p2(5)+0.1,T_iso_p2(5)-5,text2,'FontSize',12,'FontWeight','demi');

for i = 1 : 4
    if ( i == 4 )
    text(s(i)-0.1,T(i)+15,num2str(state(i)),'FontSize',14,'FontWeight','demi');
    else
    text(s(i)+0.1,T(i)-6,num2str(state(i)),'FontSize',14,'FontWeight','demi');    
    end
end

title(' Ideal Rankine Cycle');
xlabel(' Entropy ( kJ/kg.K ) ');
ylabel(' Temperature (C) ');
hold off
x_r = 0.5927 ; y_r = 41.525 ; w_r = 0.0002 ; h_r = 0.32 ;
rectangle('Position', [x_r, y_r, w_r, h_r],'EdgeColor', [0.4, 0.1, 0.4]);
x_a = 0.16; y_a = .6; w_a = 0.2; h_a = 0.3;
ax = axes('Units', 'normalized', ...
          'Position', [x_a, y_a, w_a, h_a], ...
          'Box', 'on', ...
          'Color', [0.95, 0.99, 0.95]);
hold on;
plot(Ssat,Tsat,'b','linewidth',2)
plot(s_iso_p2,T_iso_p2,'--r','linewidth',2);
plot(s_iso_p1,T_iso_p1,'--r','linewidth',2);
plot(s,T,'-cs','linewidth',2);
axis([s(3)-0.0005 s(3)+0.001 T(3)-0.1 T(4)+0.1])
text(s(4),T(4)+0.03,num2str(state(4)),'FontSize',8,'FontWeight','demi');
text(s(3),T(3)+0.03,num2str(state(3)),'FontSize',8,'FontWeight','demi');
set(gca,'XTick',[s(3):0.001:s(3)+0.001])
set(gca,'YTick',[T(3):T(4)-T(3):T(4)])
set(gca,'XTickLabel',[num2str(s(3),'%1.3f');num2str(s(3)+0.001,'%1.3f')])
set(gca,'YTickLabel',[num2str(T(3),'%1.2f');num2str(T(4),'%1.2f')])
figure
RankineDrawing
title(' Schematic Drawing of Rankine Cycle ','fontsize',14,'fontweight','demi','fontname','calibri');
axis off
    end
elseif(length(control1) == 6) % 6 Components in Cycle, Reheated Rankine Cycle
%-------------------------Reheated Rankine Cycle----------------------------
% Read Data from .txt
fid = fopen('inputReheat.txt');
% read column headers
C_text = textscan(fid, '%s',7);
% read numeric data
C_data0 = textscan(fid, '%f %f %f %f %f %f %f','treatAsEmpty', {'Condenser', 'Turbine1','Turbine2','Boiler','Pump','Reheat','-'},'EmptyValue', -1);
fclose(fid);
state    = C_data0{1}; % 
P        = C_data0{3}; % Pressure of states [kPa]
T        = C_data0{4}; % Temperature of states [^oC]
x        = C_data0{5}; % Liquid-Vapor Fraction
n        = C_data0{6}; % Isentropic Efficiencies of pump and turbine
W_output = C_data0{7}; % Work Output [kW]
%--------------------------------------------------------------------------
% Arrangements for Pressures; these come from the theoretical information
% of Rankine Cycle
if( P(2) == -1 )
     P(2) = P(3);
 elseif( P(3) == -1 )
     P(3) = P(2);
end
 
if( P(4) == -1 )
    P(4) = P(5);
elseif( P(5) == -1 )
    P(5) = P(4);
end

if ( P(1) == -1 )
    P(1) = P(6);
elseif( P(6) == -1 )
    P(6) = P(1);
end
P = P * (10^(-2)); % 1 kpa = 10^(-2) bar
%--------------------------------------------------------------------------
% DETERMINING THE TEMPERATURE;ENTROPY;ENTHALPY FOR STATES

% Arrays of h2s,s2s keep the values of Ideal Rankine Cycle
% Arrays of h,s     keep the values of Rankine Cycle with Irreversibilities

% 1) BEFORE TURBINE 1 
if ( x(1) == 1 )
    h2s(1) = XSteam('hv_p',P(1));
    T2s(1) = XSteam('T_ph',P(1),h2s(1));
    s2s(1) = XSteam('sv_p',P(1));
    v(1)   = XSteam('vV_p',P(1));
else
    h2s(1) = XSteam('h_pT',P(1),T(1));
    T2s(1) = XSteam('T_ph',P(1),h2s(1));
    s2s(1) = XSteam('s_pT',P(1),T(1));
    v(1)   = XSteam('v_pT',P(1),T(1));
end
h(1) = h2s(1);
T(1) = T2s(1);                                                                   
s(1) = s2s(1);

% 2) BEFORE REHEAT
s2s(2) = s(1);
x2s(2) = (s2s(2) - XSteam('sL_p',P(2)))/(XSteam('sv_p',P(2))-XSteam('sL_p',P(2))); % Liquid-Vapor Fraction

if ( x2s(2) < 1 && x2s(2) > 0) % If the working fluid is two phase mixture
    h2s(2) = XSteam('h_px',P(2),x2s(2));
    T2s(2) = XSteam('Tsat_p',P(2));
else                           % If the working fluid is superheated vapor
    h2s(2) = XSteam('h_ps',P(2),s2s(2));
    T2s(2) = XSteam('T_ps',P(2),s2s(2));
end

if ( n(1) == -1 )               % If there is not inefficiency of Turbine 1
    h(2) = h2s(2);
    s(2) = s2s(2);
    T(2) = T2s(2);
else                           % If there is an inefficiency of Turbine 1
    h(2) = h(1) - n(1) * (h(1) - h2s(2));
    s(2) = XSteam('s_ph',P(2),h(2));
    T(2) = XSteam('T_ph',P(2),h(2));
end

% 3) BEFORE TURBINE 2
h2s(3) = XSteam('h_pT',P(3),T(3));
h(3)   = h2s(3);
T2s(3) = XSteam('T_ph',P(3),h2s(3));
s2s(3) = XSteam('s_pT',P(3),T(3));
s(3)   = s2s(3);
T(3)   = T2s(3);
% 4) BEFORE CONDENSER
s2s(4) = s(3);
x2s(4) = (s2s(4) - XSteam('sL_p',P(4)))/(XSteam('sv_p',P(4))-XSteam('sL_p',P(4)));
if ( x2s(4) < 1 && x2s(4) > 0) % If the working fluid is two phase mixture
    h2s(4) = XSteam('h_px',P(4),x2s(4));
    T2s(4) = XSteam('Tsat_p',P(4));
else                           % If the working fluid is superheated vapor
    h2s(4) = XSteam('h_ps',P(4),s2s(4));
    T2s(4) = XSteam('T_ps',P(4),s2s(4));
end

if ( n(3) == -1 )               % If there is not inefficiency of Turbine 2
    h(4) = h2s(4);
    s(4) = s2s(4);
    T(4) = T2s(4);
else                          % If there is an inefficiency of Turbine 2
    h(4) = h(3) - n(3) * (h(3) - h2s(4));
    s(4) = XSteam('s_ph',P(4),h(4));
    T(4) = XSteam('T_ph',P(4),h(4));
end

% 5) BEFORE PUMP
% It is assumed that the fluid coming into pump is saturated liquid 
h2s(5) = XSteam('hL_p',P(5));                                                             
h(5)   = h2s(5);
v(5)   = XSteam('vL_p',P(5));                                                             
T2s(5) = XSteam('T_ph',P(5),h2s(5));
T(5)   = T2s(5);
s2s(5) = XSteam('sL_T',T(5));
s(5)   = s2s(5);
v(5)   = XSteam('vL_p',P(5));

% 6) BEFORE BOILER 
  s2s(6) = s(5);
  if ( s2s(6) < XSteam('sL_p',P(6)) ) % Which means that the fluid is compressed liquid 
     h2s(6) = h2s(5)+v(5)*(P(6)-P(5))*100; % *100 because we must use kpa in equation
     T2s(6) = XSteam('T_ps',P(6),s2s(6));
  elseif ( s2s(6) == XSteam('sL_p',P(6))) % Saturated Liquid
    h2s(6) = XSteam('hL_p',P(6));
    T2s(6) = XSteam('Tsat_p',P(6));
  else                                    % Two Phase Mixture
    x2s(6)   = (s2s(6) - XSteam('sL_p',P(6))) / (XSteam('sv_p',P(6)) - XSteam('sL_p',P(6)));
    h2s(6)   = XSteam('h_px',P(6),x2s(6));  
    T2s(6)   = XSteam('Tsat_p',P(6)); 
  end
  
if ( n(5) == -1 ) % Which means that there is no inefficiency
  s(6) = s2s(6);
  h(6) = h2s(6);
  T(6) = T2s(6);
else
  h(6) = (h2s(6) - h(5)) / n(5) + h(5);
  s(6) = XSteam('s_ph',P(6),h(6));
  T(6) = XSteam('T_ps',P(6),s(6));
end

% Mass Flow Rate m_dot[kg/s] and Thermal Efficiency Calculation
m_dot_ideal    = W_output(1) / ((h2s(1) - h2s(2)) + (h2s(3) - h2s(4))-(h2s(6) - h2s(5)));
nthermal_ideal = (h2s(1) - h2s(2) + h2s(3) - h2s(4) - h2s(6) + h2s(5)) / (h2s(1) - h2s(6) + h2s(3) - h2s(2)); 
m_dot          = W_output(1) / ((h(1) - h(2)) + (h(3) - h(4))-(h(6) - h(5)));
nthermal       = (h(1) - h(2) + h(3) - h(4) - h(6) + h(5)) / (h(1) - h(6) + h(3) - h(2)); 

% DISPLAY OF RESULTS
disp('      RESULTS       ')
disp(' ------------------ ')

% For Ideal Rankine Cycle

Wdot_turbine_Ideal1 = m_dot_ideal * (h2s(1) - h2s(2)) ; % [ kW ]
Wdot_turbine_Ideal2 = m_dot_ideal * (h2s(3) - h2s(4)) ; % [ kW ]
Wdot_turbine_i      = Wdot_turbine_Ideal1 + Wdot_turbine_Ideal2;
Wdot_pump_Ideal     = m_dot_ideal * (h2s(6) - h2s(5)) ; % [ kW ]
Qdot_in_Ideal       = m_dot_ideal * (h2s(1) - h2s(6) + h2s(3) - h2s(2)) ; % [ kW ]
Qdot_out_Ideal      = m_dot_ideal * (h2s(4) - h2s(5)) ; % [ kW ]
Wdot_cylce_Ideal    = Wdot_turbine_i - Wdot_pump_Ideal ; %  [ kW ]
BWR_Ideal           = Wdot_pump_Ideal / Wdot_turbine_i ;

disp(' ')
disp('Results for IDEAL Rankine Cycle')
disp('--------------------------------' )
disp(['Mass Flow Rate = ',num2str(m_dot_ideal,'%3.2f'),' [kg/s] '])
disp(['Thermal Efficiency = ',num2str(nthermal_ideal,'%1.2f')])
disp(' ')
disp('WorkPump[kW]    WorkTurbine1[kW]  WorkTurbine2[kW]     Qin[kW]     Qout[kW]    WorkCycle[kW] BackWorkRatio')
disp('--------------  ----------------     --------        ----------  ------------- ------------- ---------------- ')
d=sprintf('   %3.1f             %3.1f        %3.1f          %3.1f       %4.1f      %1.3f    %1.5f', Wdot_pump_Ideal,Wdot_turbine_Ideal1 ,Wdot_turbine_Ideal2, Qdot_in_Ideal,Qdot_out_Ideal, Wdot_cylce_Ideal, BWR_Ideal);
disp(d)
disp(' ')
disp('STATE   P[kPa]  T[^oC]  h[kj/kg]   s[kj/K.kg]  ')
disp('-----  ------- -------  --------   ---------  ')
for i = 1 : length(state)
    d = sprintf('   %1d   %3.1f   %3.1f   %4.1f   %1.4f \n', state(i),P(i)*100,T(i),h2s(i),s2s(i));
    disp(d)
end

% For Irreversible Rankine Cycle

Wdot_turbine1 = m_dot * (h(1) - h(2)) ; % [ kW ]
Wdot_turbine2 = m_dot * (h(3) - h(4)) ; % [ kW ]
Wdot_turbine  = Wdot_turbine1 + Wdot_turbine2;
Wdot_pump     = m_dot * (h(6) - h(5)) ; % [ kW ]
Qdot_in       = m_dot * (h(1) - h(6) + h(3) - h(2)) ; % [ kW ]
Qdot_out      = m_dot * (h(4) - h(5)) ; % [ kW ]
Wdot_cycle   = Wdot_turbine - Wdot_pump ; %  [ kW ]
BWR          = Wdot_pump / Wdot_turbine ;

disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ');
disp(' Results for Rankine Cycle with IRREVERSIBILITIES ' )
disp('--------------------------------------------------' )
disp(['Mass Flow Rate = ',num2str(m_dot,'%3.2f'),' [kg/s] '])
disp(['Thermal Efficiency = ',num2str(nthermal,'%1.2f')])
disp(' ')
disp('WorkPump[kW]    WorkTurbine1[kW]  WorkTurbine2[kW]     Qin[kW]     Qout[kW]    WorkCycle[kW] BackWorkRatio')
disp('--------------  ----------------     --------        ----------  ------------- ------------- ---------------- ')
d=sprintf('   %3.1f             %3.1f        %3.1f          %3.1f       %4.1f      %1.3f    %1.5f', Wdot_pump , Wdot_turbine1, Wdot_turbine2 , Qdot_in, Qdot_out, Wdot_cycle, BWR);
disp(d)
disp(' ')
disp('STATE   P[kPa]  T[^oC]  h[kj/kg]   s[kj/K.kg]  ')
disp('-----  ------- -------  --------   ---------  ')
for i = 1 : length(state)
    d = sprintf('   %1d   %3.1f   %3.1f   %4.1f   %1.4f \n', state(i),P(i)*100,T(i),h(i),s(i));
    disp(d)
end

% PLOTTING

% To get Liquid - Vapor Dome and Isobars
[Tsat Ssat] = makedome;
[T_iso_p1,s_iso_p1,T_iso_p2,s_iso_p2,T_iso_p3,s_iso_p3] = getisobarspro(P);
% Couple of arrangements for plotting
[T2_3, S2_3] = assistant (T(2),T(3),P(2),h(2),h(3));
[T6_1, S6_1] = assistant (T(6),T(1),P(1),h(6),h(1));
Tfinal = [ T(1) T(2) T2_3 T(4) T(5) T(6) T6_1 ];
sfinal = [ s(1) s(2) S2_3 s(4) s(5) s(6) S6_1 ];
[T2s_3, S2s_3] = assistant (T2s(2),T2s(3),P(2),h2s(2),h2s(3));
[T6s_1, S6s_1] = assistant (T2s(6),T2s(1),P(1),h2s(6),h2s(1));
T2sfinal = [ T2s(1) T2s(2) T2s_3 T2s(4) T2s(5) T2s(6) T6s_1 ];
s2sfinal = [ s2s(1) s2s(2) S2s_3 s2s(4) s2s(5) s2s(6) S6s_1 ];
% Draw Schematic View of Rankine Cycle
Schematic_View
title(' Schematic Drawing of Rankine Cycle ','fontsize',14,'fontweight','demi','fontname','calibri');
axis off
hold on
figure
plot(Ssat,Tsat,'r','linewidth',2)
hold on
plot(s_iso_p1,T_iso_p1,'--b','linewidth',2);
plot(s_iso_p2,T_iso_p2,'--b','linewidth',2);
plot(s_iso_p3,T_iso_p3,'--b','linewidth',2);
plot(sfinal,Tfinal,'c','linewidth',2);
plot(s2sfinal,T2sfinal,'--c','linewidth',2);
set(gca,'fontsize',14,'fontweight','demi','fontname','calibri')


% Marking and labelling
plot(s,T,'k.');
plot(s2s,T2s,'k.');

for i = 1 : 6
    if ( i == 6 )
        text(s(i)-0.35,T(i)-10,num2str(state(i)),'FontSize',12,'FontWeight','demi');
    elseif ( i == 5 )
        text(s(i)+0.05,T(i)-10,num2str(state(i)),'FontSize',12,'FontWeight','demi');    
    elseif( i == 4 )
        text(s(i)+0.2,T(i),num2str(state(i)),'FontSize',12,'FontWeight','demi'); 
    else
        text(s(i)+0.1,T(i)-6,num2str(state(i)),'FontSize',12,'FontWeight','demi'); 
    end
end
for i = 1 : 3
    if ( i == 1 )
    text(s2s(i*2)-0.4,T2s(i*2)-9,'2s','Fontsize',12,'FontWeight','demi');
    elseif ( i == 2 )
    text(s2s(i*2)-0.2,T2s(i*2)-8,'4s','FontSize',12,'FontWeight','demi');
    else
    text(s2s(i*2)-0.3,T2s(i*2)+15,'6s','FontSize',12,'FontWeight','demi');    
    end
end
in_iso1 = length(T_iso_p1);
in_iso2 = length(T_iso_p2);
in_iso3 = length(T_iso_p3);

text1 = ['P(1) = ',num2str(P(1) * 100),' kPa' ];    
text(s_iso_p1(in_iso1)-0.5,T_iso_p1(in_iso1)+5,text1,'FontSize',10,'FontWeight','demi','fontname','calibri');
text2 = ['P(2) = ',num2str(P(2) * 100),' kPa' ]; 
text(s_iso_p2(in_iso2)+0.1,T_iso_p2(in_iso2)-5,text2,'FontSize',10,'FontWeight','demi','fontname','calibri');
text3 = ['P(5) = ',num2str(P(5) * 100),' kPa' ]; 
text(s_iso_p3(in_iso3),T_iso_p3(in_iso3)-5,text3,'FontSize',10,'FontWeight','demi','fontname','calibri');

title('Rankine Cycle','FontWeight','demi','fontname','calibri');
xlabel(' Entropy ( kJ/kg.K ) ');
ylabel(' Temperature (C) ');
hold off
x_r = 0.5950 ; y_r = 41.525 ; w_r = 0.0002 ; h_r = 0.32 ;
rectangle('Position', [x_r, y_r, w_r, h_r],'EdgeColor', [0.4, 0.1, 0.4]);
x_a = 0.16; y_a = .6; w_a = 0.2; h_a = 0.3;
ax = axes('Units', 'normalized', ...
          'Position', [x_a, y_a, w_a, h_a], ...
          'Box', 'on', ...
          'Color', [0.95, 0.99, 0.95]);
hold on;
plot(Ssat,Tsat,'r','linewidth',2)
hold on
plot(s_iso_p1,T_iso_p1,'--b','linewidth',2);
plot(s_iso_p2,T_iso_p2,'--b','linewidth',2);
plot(s_iso_p3,T_iso_p3,'--b','linewidth',2);
plot(sfinal,Tfinal,'c','linewidth',2);
plot(s2sfinal,T2sfinal,'--c','linewidth',2);
plot(s,T,'k.','linewidth',10);
plot(s2s,T2s,'k.','linewidth',10);
axis([s(5)-0.0006 s(5)+0.005 T(5)-0.06 T2s(6)+0.45])
text(s(6),T(6)+0.03,num2str(state(6)),'FontSize',8,'FontWeight','demi');
text(s2s(6)-0.0005,T2s(6)+0.03,'6s','FontSize',8,'FontWeight','demi');
text(s(5)-0.0005,T(5)+0.03,num2str(state(5)),'FontSize',8,'FontWeight','demi');
set(gca,'XTick',[s(5):s(6)-s(5):s(6)])
set(gca,'YTick',[T(5):T(6)-T(5):T(6)])
set(gca,'XTickLabel',[num2str(s(5),'%1.3f');num2str(s(6),'%1.3f')])
set(gca,'YTickLabel',[num2str(T(5),'%1.2f');num2str(T(6),'%1.2f')])
set(gca,'fontname','calibri')
end
