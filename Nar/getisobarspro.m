 function [T_iso_p1,s_iso_p1,T_iso_p2,s_iso_p2,T_iso_p3,s_iso_p3] = getisobarspro(P)
% For isobar at top
% Temperature
Tsat = XSteam('Tsat_p',P(1));
Ti   = 20;                    % [o^C]
Tf   = 550;                   % [o^C]
n_point = 100;                % Number of points for each segment
temp_grad1 = (Tsat - Ti) / n_point ;% Temp Difference for Compressed Liquid
temp_grad2 = (Tf - Tsat) / n_point ;% Temp Difference for Superheated Vapor
tempgrad = 0;
for i = 1 : n_point % Compressed Liquid Phase
    T_iso_p1(i) = Ti + tempgrad;
    tempgrad = tempgrad + temp_grad1;
end
for i = (n_point+1) : 2*n_point % Two Phase Mixture
    T_iso_p1(i) = Tsat;
end
tempgrad = 0;
for i = (2*n_point+1) : 3*n_point+1
    T_iso_p1(i) = Tsat + tempgrad;
    tempgrad = tempgrad + temp_grad2;
end
% Entropy
for i = 1 : n_point
    s_iso_p1(i) = XSteam('s_pT',P(1),T_iso_p1(i));
end 
s_iso_p1(n_point+1) = XSteam('sL_p',P(1));
x_grad = 1 / (n_point-1); 
x = 0;
for i = (n_point+2) : (2*n_point)
    x = x + x_grad; 
    h = XSteam('h_px',P(1),x);
    s_iso_p1(i) = XSteam('s_ph',P(1),h);
end
s_iso_p1(2*n_point+1) = XSteam('sv_p',P(1));
for i = (2*n_point+2) : 3*n_point+1
    s_iso_p1(i) = XSteam('s_pT',P(1),T_iso_p1(i));
end

% For isobar at middle
Tsat_2 = XSteam('Tsat_p',P(2));
Ti_2   = 20;                    % [o^C]
Tf_2   = 500;                   % [o^C]              
temp_grad1_2 = (Tsat_2 - Ti_2) / n_point;% Temp Difference for Compressed Liquid
temp_grad2_2 = (Tf_2 - Tsat_2) / n_point ;% Temp Difference for Superheated Vapor
tempgrad_2 = 0;
for i = 1 : n_point % Compressed Liquid Phase
    T_iso_p2(i) = Ti_2 + tempgrad_2;
    tempgrad_2 = tempgrad_2 + temp_grad1_2;
end
for i = (n_point+1) : 2*n_point % Two Phase Mixture
    T_iso_p2(i) = Tsat_2;
end
tempgrad_2 = 0;
for i = (2*n_point+1) : 3*n_point+1
    T_iso_p2(i) = Tsat_2 + tempgrad_2;
    tempgrad_2 = tempgrad_2 + temp_grad2_2;
end
% Entropy
for i = 1 : n_point
    s_iso_p2(i) = XSteam('s_pT',P(2),T_iso_p2(i));
end 
s_iso_p2(n_point+1) = XSteam('sL_p',P(2));
x_grad_2 = 1 / (n_point-1); 
x_2 = 0;
for i = (n_point+2) : (2*n_point)
    x_2 = x_2 + x_grad_2; 
    h = XSteam('h_px',P(2),x_2);
    s_iso_p2(i) = XSteam('s_ph',P(2),h);
end
s_iso_p2(2*n_point+1) = XSteam('sv_p',P(2));
for i = (2*n_point+2) : 3*n_point+1
    s_iso_p2(i) = XSteam('s_pT',P(2),T_iso_p2(i));
end

% For isobar at low
Tsat_3 = XSteam('Tsat_p',P(5));
Ti_3   = 20;                    % [o^C]
Tf_3   = 300;                   % [o^C]              
temp_grad1_3 = (Tsat_3 - Ti_3) / n_point;% Temp Difference for Compressed Liquid
temp_grad2_3 = (Tf_3 - Tsat_3) / n_point ;% Temp Difference for Superheated Vapor
tempgrad_3 = 0;
for i = 1 : n_point % Compressed Liquid Phase
    T_iso_p3(i) = Ti_3 + tempgrad_3;
    tempgrad_3 = tempgrad_3 + temp_grad1_3;
end
for i = (n_point+1) : 2*n_point % Two Phase Mixture
    T_iso_p3(i) = Tsat_3;
end
tempgrad_3 = 0;
for i = (2*n_point+1) : 3*n_point+1
    T_iso_p3(i) = Tsat_3 + tempgrad_3;
    tempgrad_3 = tempgrad_3 + temp_grad2_3;
end
% Entropy
for i = 1 : n_point
    s_iso_p3(i) = XSteam('s_pT',P(5),T_iso_p3(i));
end 
s_iso_p3(n_point+1) = XSteam('sL_p',P(5));
x_grad_3 = 1 / (n_point-1); 
x_3 = 0;
for i = (n_point+2) : (2*n_point)
    x_3 = x_3 + x_grad_3; 
    h = XSteam('h_px',P(5),x_3);
    s_iso_p3(i) = XSteam('s_ph',P(5),h);
end
s_iso_p3(2*n_point+1) = XSteam('sv_p',P(5));
for i = (2*n_point+2) : 3*n_point+1
    s_iso_p3(i) = XSteam('s_pT',P(5),T_iso_p3(i));
end
