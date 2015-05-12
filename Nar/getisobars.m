function [T_iso_p1,s_iso_p1,T_iso_p2,s_iso_p2] = getisobars(P,T,s)

T_iso_p1(1) = XSteam('Tsat_p',P(3)) - 10;
T_iso_p1(2) = XSteam('Tsat_p',P(3));
T_iso_p1(3) = XSteam('Tsat_p',P(3));
T_iso_p1(4) = XSteam('Tsat_p',P(3)) + 150;

s_iso_p1(1) = XSteam('s_pT',P(3),T_iso_p1(1));
s_iso_p1(2) = XSteam('sL_p',P(3));
s_iso_p1(3) = XSteam('sv_p', P(3));
s_iso_p1(4) = XSteam('s_pT',P(3),T_iso_p1(4));

T_iso_p2(1) = T(4) - 20 ;
T_iso_p2(2) = XSteam('T_ps',P(4),s(4));
T_iso_p2(3) = XSteam('Tsat_p',P(1));
T_iso_p2(4) = XSteam('Tsat_p',P(1));
T_iso_p2(5) = XSteam('Tsat_p',P(1)) + 150;

s_iso_p2(1) = XSteam('s_pT',P(4),T_iso_p2(1));
s_iso_p2(2) = s(4);
s_iso_p2(3) = XSteam('sL_p',P(4));
s_iso_p2(4) = XSteam('sv_p', P(4));
s_iso_p2(5) = XSteam('s_pT',P(4),T_iso_p2(5));

