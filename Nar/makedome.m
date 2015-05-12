function [Tsat Ssat] = makedome

P=[0.01:0.01:0.10 0.15:0.05:0.30 0.40:0.10:0.50 0.75:0.25:4 4.5:0.5:10 11:1:15 17.5:2.5:25 30 35 40:10:220 220.9]; %Pressure Values (bar)

Tsat=zeros(1,length(P)-1);% Saturation Temperatures(Oc)

for i=1:(2*length(P)-1)
    if ( i < length(P) )
       T=XSteam('Tsat_p',P(i));
       Tsat(i)=T;
    elseif ( i == length(P) )
      % T=XSteam('Tsat_p',P(i));
       Tsat(i)=374.14;
       c=0;
    else
        c=c+2;
        T=XSteam('Tsat_p',P(i-c));
        Tsat(i)=T;
    end
end

Ssat=zeros(1,length(Tsat));%Saturated Liquid Entropy until T=Tc, Then Saturated Vapour Entropy  
%For Saturated Liquid S=Sf, For Saturated Vapor S=Sg
for i=1:(length(Tsat))
    if ( i < length(P) )
        S=XSteam('sL_T',Tsat(i));
        Ssat(i)=S;
    elseif ( i == length(P) )
       % S=XSteam('sV_T',Tsat(i));
        Ssat(i)=4.4298;
    else
        S=XSteam('sV_T',Tsat(i));
        Ssat(i)=S;
    end
end