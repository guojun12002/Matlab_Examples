function [Tassist, Sassist] = assistant (Ti,Tf,P,hi,hf)
Tsat = XSteam('Tsat_p',P);
n_point = 100;
if( Ti<Tsat && Tf>Tsat )
    temp_grad1 = (Tsat - Ti) / n_point ;% Temp Difference for Compressed Liquid
    temp_grad2 = (Tf - Tsat) / n_point ;% Temp Difference for Superheated Vapor
    tempgrad = 0;
    for i = 1 : n_point % Compressed Liquid Phase
        Tassist(i) = Ti + tempgrad;
        tempgrad = tempgrad + temp_grad1;
    end
    for i = (n_point+1) : 2*n_point % Two Phase Mixture
        Tassist(i) = Tsat;
    end
    tempgrad = 0;
    for i = (2*n_point+1) : 3*n_point+1
        Tassist(i) = Tsat + tempgrad;
        tempgrad = tempgrad + temp_grad2;
    end
    % Entropy
    for i = 1 : n_point
        Sassist(i) = XSteam('s_pT',P,Tassist(i));
    end 
    Sassist(n_point+1) = XSteam('sL_p',P);
    x_grad = 1 / n_point; 
    x = 0;
    for i = (n_point+2) : (2*n_point-1)
        x = x + x_grad; 
        h = XSteam('h_px',P,x);
        Sassist(i) = XSteam('s_ph',P,h);
    end
    Sassist(2*n_point) = XSteam('sv_p',P);
    for i = (2*n_point+1) : 3*n_point+1
        Sassist(i) = XSteam('s_pT',P,Tassist(i));
    end
    
elseif( Ti==Tsat && Tf>Tsat )
    % Temperature
    n_pointSpec = 30;
    temp_grad = (Tf - Tsat) / n_point ;
    for i = 1 : n_pointSpec
        Tassist(i) = Tsat;
    end
    tempgrad = 0;
    for i = (n_pointSpec+1) : (n_pointSpec+1+n_point)
        Tassist(i) = Tsat + tempgrad;
        tempgrad = tempgrad + temp_grad;
    end
    % Entropy
    xi = (hi - XSteam('hL_p',P)) / (XSteam('hv_p',P) - XSteam('hL_p',P));
    x_grad = (1 - xi) / (n_pointSpec-1); 
    x = 0;
    xgrad = 0;
    for i = 1 : n_pointSpec
        x = xi + xgrad;
        xgrad = xgrad + x_grad;
        h = XSteam('h_px',P,x);
        Sassist(i) = XSteam('s_ph',P,h);
    end
    Sassist(n_pointSpec+1) = XSteam('sv_p',P);
    for i = (n_pointSpec+2) : (n_pointSpec+1+n_point)
        Sassist(i) = XSteam('s_pT',P,Tassist(i));
    end
elseif( Ti>Tsat && Tf>Tsat )
    n_pointSpec = 50;
    % Temperature
    temp_grad = (Tf - Ti) / n_pointSpec;
    tempgrad = 0;
    for i = 1 : n_pointSpec
        Tassist(i) = Ti + tempgrad;
        tempgrad = tempgrad + temp_grad;
    end
    % Entropy
    for i = 1 : n_pointSpec
        Sassist(i) = XSteam('s_pT',P,Tassist(i));
    end
elseif( Ti == Tsat && Tf == Tsat )
    n_pointSpec = 50;
    % Temperature
    for i = 1 : n_pointSpec
        Tassist(i) = Tsat;
    end
    % Entropy
    xi = (hi - XSteam('hL_p',P))/(XSteam('hv_p',P) - XSteam('hL_p',P)); 
    xf = (hf - XSteam('hL_p',P))/(XSteam('hv_p',P) - XSteam('hL_p',P));
    x_grad = (xf-xi)/n_pointSpec;
    x = 0;
    for i = 1 : n_pointSpec
        x = x + x_grad;
        h = XSteam('h_px',P,x);
        Sassist(i) = XSteam('s_ph',P,h);
    end
end