function gibbs1()
load data1;%读取位移和荷载数据点
Dt=70;%油管内径,mm
Dr=22;%抽油杆直径,mm
fr=0.5*pi*(Dr/2/1000)^2; %抽油杆截面积,m^2
u=30e-3;%液体粘度,Pa*s
L=792.5;%抽油杆长度，m
Rou_r=8456;%抽油杆密度,kg/m^3
w=2*pi*7.6/60;%曲柄角速度,rad/s
x=L;%抽油杆深度m
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
m=Dt/Dr;
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


%Gibbs方程解析解

%hold on;
global u;
global f;
u=zeros(1,144);
f=zeros(1,144);
i=1;
for t=0:8/143:8  %以时间t为自变量
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
plot(u,f,'b');hold on;plot(U,D,'r');
xlabel('位移(m)');
ylabel('载荷(kN)');
title('示功图和泵功图');
legend('泵功图','示功图');
