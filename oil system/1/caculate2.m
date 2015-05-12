function caculate2()
R=0.950;
P=3.675;
C=2.495;
A=4.315;
K=sqrt((R+P)^2+C^2);
l=C;
n=7.6;
u=2*pi*n/60;
for t=0:0.01:10
    Ot=u*t;
    a=asin(l/K);
    O0=a-acos(((R+P)^2+K^2-C^2)/(2*(R+P)*K));
    O1t=O0+Ot;
    O2t=2*pi-O1t+a;
    Lt=sqrt(R^2+K^2-2*R*K*cos(O2t));
    bt=asin(R*sin(O2t)/Lt);
    O3t=acos((P^2+Lt^2-C^2)/(2*P*Lt))-bt;
    O4t=acos((P^2-Lt^2-C^2)/(2*C*Lt))-bt;
    xt=acos((C^2+Lt^2-P^2)/(2*C*Lt));
    Fit=xt+bt;
    Vt=-((2*pi*n*R)*(sin(O3t-O2t)))/((30*C)*(sin(O3t-O4t)));
    Fimax=acos((C^2+K^2-(R+P)^2)/(2*C*K));
    Fimin=acos((C^2+K^2-(P-R)^2)/(2*C*K));
    Stt=(Fimax-Fit)*A;
    St=A*(acos((C^2+K^2-(R+P)^2)/(2*C*K))-acos((C^2+Lt^2-P^2)/(2*C*Lt))-asin(R*sin(O2t)/Lt));

    hold on;
    plot(t,St,'b');
end