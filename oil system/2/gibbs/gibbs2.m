function gibbs2()
load data2;%读取位移和荷载数据点
Dt=44;%油管内径,mm
Dr1=25;%抽油杆直径,mm
Dr2=22;%抽油杆直径,mm
Dr3=19;%抽油杆直径,mm
u=30e-3;%液体粘度,Pa*s
L1=523.61;%一级抽油杆长度，m
L2=664.32;%二级抽油杆长度，m
L3=618.35;%三级抽油杆长度，m
Rou_r=8456;%抽油杆密度,kg/m^3
w=2*pi*4/60;%曲柄角速度,rad/s
k=size(D,2);%读取离散化采样点数
E=2.1e11;%弹性模量
a=sqrt(E/Rou_r);%应力波在抽油杆住中的传播速度
n_=10;%付氏级数所取项数

%4个傅里叶系数
sigma=zeros(1,n_);sigma0=0;
tao=zeros(1,n_);
v=zeros(1,n_);v0=0;
derta=zeros(1,n_);

%4个特殊系数
alpha=zeros(1,n_);
beta=zeros(1,n_);
kn=zeros(1,n_);
miu=zeros(1,n_);

%4个特殊函数
On=zeros(1,n_);
Pn=zeros(1,n_);
On_=zeros(1,n_);
Pn_=zeros(1,n_);

%计算阻尼系数
fr=0.5*pi*(Dr1/2/1000)^2; %抽油杆截面积,m^2
L=L1;
x=L;%抽油杆深度m
m=Dt/Dr1;
B1=(m^2-1)/(2*log(m))-1;
B2=m^4-1-(m^2-1)^2/log(m);
C=(2*pi*u/(9.8*Rou_r*fr))*(1/log(m)+(4/B2)*(B1+1)*(B1+2*tan(w*L*a)/((w*L/a)/(cos(w*L/a))+sin(w*L/a))));

%计算傅里叶系数
%n=0时
for p=1:k
    sigma0=sigma0+(2/k)*D(p);
    v0=v0+(2/k)*U(p);
end
%n>0时
for n=1:n_
    for p=1:k
            sigma(n)=sigma(n)+(2/k)*D(p)*cos(2*n*pi*p/k);
            tao(n)=tao(n)+(2/k)*D(p)*sin(2*n*pi*p/k);
            v(n)=v(n)+(2/k)*U(p)*cos(2*n*pi*p/k);
            derta(n)=derta(n)+(2/k)*U(p)*sin(2*n*pi*p/k);
    end
end

%计算特殊系数
for n=1:n_
    alpha(n)=n*w*sqrt(1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    beta(n)=n*w*sqrt(-1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    kn(n)=(sigma(n)*alpha(n)+tao(n)*beta(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
    miu(n)=(sigma(n)*beta(n)-tao(n)*alpha(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
end

%计算特殊函数
for n=1:n_
    On(n)=(kn(n)*cosh(beta(n)*x)+derta(n)*sinh(beta(n)*x))*sin(alpha(n)*x)+(miu(n)*sinh(beta(n)*x)+v(n)*cosh(beta(n)*x))*cos(alpha(n)*x);
    Pn(n)=(kn(n)*sinh(beta(n)*x)+derta(n)*cosh(beta(n)*x))*cos(alpha(n)*x)-(miu(n)*cosh(beta(n)*x)+v(n)*sinh(beta(n)*x))*sin(alpha(n)*x);
    On_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x)+((sigma(n)*cosh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x);
    Pn_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x)-((sigma(n)*sinh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x);
end

%计算新1的边界值
v0=v0+sigma0*L/(E*fr);
for n=1:n_
    sigma(n)=E*fr*On_(n);
    tao(n)=E*fr*Pn_(n);
    v(n)=On(n);
    derta(n)=Pn(n);
end

%计算阻尼系数
fr=0.5*pi*(Dr2/2/1000)^2; %抽油杆截面积,m^2
L=L1+L2;
x=L;%抽油杆深度m
m=Dt/Dr2;
B1=(m^2-1)/(2*log(m))-1;
B2=m^4-1-(m^2-1)^2/log(m);
C=(2*pi*u/(9.8*Rou_r*fr))*(1/log(m)+(4/B2)*(B1+1)*(B1+2*tan(w*L*a)/((w*L/a)/(cos(w*L/a))+sin(w*L/a))));

%计算特殊系数
for n=1:n_
    alpha(n)=n*w*sqrt(1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    beta(n)=n*w*sqrt(-1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    kn(n)=(sigma(n)*alpha(n)+tao(n)*beta(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
    miu(n)=(sigma(n)*beta(n)-tao(n)*alpha(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
end

%计算特殊函数
for n=1:n_
    On(n)=(kn(n)*cosh(beta(n)*x)+derta(n)*sinh(beta(n)*x))*sin(alpha(n)*x)+(miu(n)*sinh(beta(n)*x)+v(n)*cosh(beta(n)*x))*cos(alpha(n)*x);
    Pn(n)=(kn(n)*sinh(beta(n)*x)+derta(n)*cosh(beta(n)*x))*cos(alpha(n)*x)-(miu(n)*cosh(beta(n)*x)+v(n)*sinh(beta(n)*x))*sin(alpha(n)*x);
    On_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x)+((sigma(n)*cosh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x);
    Pn_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x)-((sigma(n)*sinh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x);
end

%计算新2的边界值
v0=v0+sigma0*L/(E*fr);
for n=1:n_
    sigma(n)=E*fr*On_(n);
    tao(n)=E*fr*Pn_(n);
    v(n)=On(n);
    derta(n)=Pn(n);
end

%计算阻尼系数
fr=0.5*pi*(Dr3/2/1000)^2; %抽油杆截面积,m^2
L=L1+L2+L3;
x=L;%抽油杆深度m
m=Dt/Dr3;
B1=(m^2-1)/(2*log(m))-1;
B2=m^4-1-(m^2-1)^2/log(m);
C=(2*pi*u/(9.8*Rou_r*fr))*(1/log(m)+(4/B2)*(B1+1)*(B1+2*tan(w*L*a)/((w*L/a)/(cos(w*L/a))+sin(w*L/a))));

%计算特殊系数
for n=1:n_
    alpha(n)=n*w*sqrt(1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    beta(n)=n*w*sqrt(-1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    kn(n)=(sigma(n)*alpha(n)+tao(n)*beta(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
    miu(n)=(sigma(n)*beta(n)-tao(n)*alpha(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
end

%计算特殊函数
for n=1:n_
    On(n)=(kn(n)*cosh(beta(n)*x)+derta(n)*sinh(beta(n)*x))*sin(alpha(n)*x)+(miu(n)*sinh(beta(n)*x)+v(n)*cosh(beta(n)*x))*cos(alpha(n)*x);
    Pn(n)=(kn(n)*sinh(beta(n)*x)+derta(n)*cosh(beta(n)*x))*cos(alpha(n)*x)-(miu(n)*cosh(beta(n)*x)+v(n)*sinh(beta(n)*x))*sin(alpha(n)*x);
    On_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x)+((sigma(n)*cosh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x);
    Pn_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x)-((sigma(n)*sinh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x);
end

%Gibbs方程解析解

%hold on;

global u;
global f;
u=zeros(1,144);
f=zeros(1,144);
i=1;
for t=0:16/144:16  %以时间t为自变量
Ut=sigma0*x/(2*E*fr)+v0/2;
Ft=sigma0/2;
for n=1:n_
    Ut=Ut+(On(n)*cos(n*w*t)+Pn(n)*sin(n*w*t));
    Ft=Ft+E*fr*(On_(n)*cos(n*w*t)+Pn_(n)*sin(n*w*t))/1000;
end
u(i)=Ut;
f(i)=Ft;
i=i+1;
%plot(Ut,Ft);
end
plot(U,D,'b');hold on;plot(u,f,'r');
xlabel('位移(m)');
ylabel('载荷(kN)');
title('示功图和泵功图');
legend('示功图', '泵功图');
