function gibbs2()
load data2;%��ȡλ�ƺͺ������ݵ�
Dt=44;%�͹��ھ�,mm
Dr1=25;%���͸�ֱ��,mm
Dr2=22;%���͸�ֱ��,mm
Dr3=19;%���͸�ֱ��,mm
u=30e-3;%Һ��ճ��,Pa*s
L1=523.61;%һ�����͸˳��ȣ�m
L2=664.32;%�������͸˳��ȣ�m
L3=618.35;%�������͸˳��ȣ�m
Rou_r=8456;%���͸��ܶ�,kg/m^3
w=2*pi*4/60;%�������ٶ�,rad/s
k=size(D,2);%��ȡ��ɢ����������
E=2.1e11;%����ģ��
a=sqrt(E/Rou_r);%Ӧ�����ڳ��͸�ס�еĴ����ٶ�
n_=10;%���ϼ�����ȡ����

%4������Ҷϵ��
sigma=zeros(1,n_);sigma0=0;
tao=zeros(1,n_);
v=zeros(1,n_);v0=0;
derta=zeros(1,n_);

%4������ϵ��
alpha=zeros(1,n_);
beta=zeros(1,n_);
kn=zeros(1,n_);
miu=zeros(1,n_);

%4�����⺯��
On=zeros(1,n_);
Pn=zeros(1,n_);
On_=zeros(1,n_);
Pn_=zeros(1,n_);

%��������ϵ��
fr=0.5*pi*(Dr1/2/1000)^2; %���͸˽����,m^2
L=L1;
x=L;%���͸����m
m=Dt/Dr1;
B1=(m^2-1)/(2*log(m))-1;
B2=m^4-1-(m^2-1)^2/log(m);
C=(2*pi*u/(9.8*Rou_r*fr))*(1/log(m)+(4/B2)*(B1+1)*(B1+2*tan(w*L*a)/((w*L/a)/(cos(w*L/a))+sin(w*L/a))));

%���㸵��Ҷϵ��
%n=0ʱ
for p=1:k
    sigma0=sigma0+(2/k)*D(p);
    v0=v0+(2/k)*U(p);
end
%n>0ʱ
for n=1:n_
    for p=1:k
            sigma(n)=sigma(n)+(2/k)*D(p)*cos(2*n*pi*p/k);
            tao(n)=tao(n)+(2/k)*D(p)*sin(2*n*pi*p/k);
            v(n)=v(n)+(2/k)*U(p)*cos(2*n*pi*p/k);
            derta(n)=derta(n)+(2/k)*U(p)*sin(2*n*pi*p/k);
    end
end

%��������ϵ��
for n=1:n_
    alpha(n)=n*w*sqrt(1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    beta(n)=n*w*sqrt(-1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    kn(n)=(sigma(n)*alpha(n)+tao(n)*beta(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
    miu(n)=(sigma(n)*beta(n)-tao(n)*alpha(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
end

%�������⺯��
for n=1:n_
    On(n)=(kn(n)*cosh(beta(n)*x)+derta(n)*sinh(beta(n)*x))*sin(alpha(n)*x)+(miu(n)*sinh(beta(n)*x)+v(n)*cosh(beta(n)*x))*cos(alpha(n)*x);
    Pn(n)=(kn(n)*sinh(beta(n)*x)+derta(n)*cosh(beta(n)*x))*cos(alpha(n)*x)-(miu(n)*cosh(beta(n)*x)+v(n)*sinh(beta(n)*x))*sin(alpha(n)*x);
    On_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x)+((sigma(n)*cosh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x);
    Pn_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x)-((sigma(n)*sinh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x);
end

%������1�ı߽�ֵ
v0=v0+sigma0*L/(E*fr);
for n=1:n_
    sigma(n)=E*fr*On_(n);
    tao(n)=E*fr*Pn_(n);
    v(n)=On(n);
    derta(n)=Pn(n);
end

%��������ϵ��
fr=0.5*pi*(Dr2/2/1000)^2; %���͸˽����,m^2
L=L1+L2;
x=L;%���͸����m
m=Dt/Dr2;
B1=(m^2-1)/(2*log(m))-1;
B2=m^4-1-(m^2-1)^2/log(m);
C=(2*pi*u/(9.8*Rou_r*fr))*(1/log(m)+(4/B2)*(B1+1)*(B1+2*tan(w*L*a)/((w*L/a)/(cos(w*L/a))+sin(w*L/a))));

%��������ϵ��
for n=1:n_
    alpha(n)=n*w*sqrt(1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    beta(n)=n*w*sqrt(-1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    kn(n)=(sigma(n)*alpha(n)+tao(n)*beta(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
    miu(n)=(sigma(n)*beta(n)-tao(n)*alpha(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
end

%�������⺯��
for n=1:n_
    On(n)=(kn(n)*cosh(beta(n)*x)+derta(n)*sinh(beta(n)*x))*sin(alpha(n)*x)+(miu(n)*sinh(beta(n)*x)+v(n)*cosh(beta(n)*x))*cos(alpha(n)*x);
    Pn(n)=(kn(n)*sinh(beta(n)*x)+derta(n)*cosh(beta(n)*x))*cos(alpha(n)*x)-(miu(n)*cosh(beta(n)*x)+v(n)*sinh(beta(n)*x))*sin(alpha(n)*x);
    On_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x)+((sigma(n)*cosh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x);
    Pn_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x)-((sigma(n)*sinh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x);
end

%������2�ı߽�ֵ
v0=v0+sigma0*L/(E*fr);
for n=1:n_
    sigma(n)=E*fr*On_(n);
    tao(n)=E*fr*Pn_(n);
    v(n)=On(n);
    derta(n)=Pn(n);
end

%��������ϵ��
fr=0.5*pi*(Dr3/2/1000)^2; %���͸˽����,m^2
L=L1+L2+L3;
x=L;%���͸����m
m=Dt/Dr3;
B1=(m^2-1)/(2*log(m))-1;
B2=m^4-1-(m^2-1)^2/log(m);
C=(2*pi*u/(9.8*Rou_r*fr))*(1/log(m)+(4/B2)*(B1+1)*(B1+2*tan(w*L*a)/((w*L/a)/(cos(w*L/a))+sin(w*L/a))));

%��������ϵ��
for n=1:n_
    alpha(n)=n*w*sqrt(1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    beta(n)=n*w*sqrt(-1+sqrt(1+(C/(n*w))^2))/(a*sqrt(2));
    kn(n)=(sigma(n)*alpha(n)+tao(n)*beta(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
    miu(n)=(sigma(n)*beta(n)-tao(n)*alpha(n))/(E*fr*((alpha(n))^2+(beta(n))^2));
end

%�������⺯��
for n=1:n_
    On(n)=(kn(n)*cosh(beta(n)*x)+derta(n)*sinh(beta(n)*x))*sin(alpha(n)*x)+(miu(n)*sinh(beta(n)*x)+v(n)*cosh(beta(n)*x))*cos(alpha(n)*x);
    Pn(n)=(kn(n)*sinh(beta(n)*x)+derta(n)*cosh(beta(n)*x))*cos(alpha(n)*x)-(miu(n)*cosh(beta(n)*x)+v(n)*sinh(beta(n)*x))*sin(alpha(n)*x);
    On_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x)+((sigma(n)*cosh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x);
    Pn_(n)=((tao(n)*cosh(beta(n)*x))/(E*fr)+(derta(n)*beta(n)-v(n)*alpha(n))*sinh(beta(n)*x))*cos(alpha(n)*x)-((sigma(n)*sinh(beta(n)*x))/(E*fr)+(v(n)*beta(n)+derta(n)*alpha(n))*cosh(beta(n)*x))*sin(alpha(n)*x);
end

%Gibbs���̽�����

%hold on;

global u;
global f;
u=zeros(1,144);
f=zeros(1,144);
i=1;
for t=0:16/144:16  %��ʱ��tΪ�Ա���
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
xlabel('λ��(m)');
ylabel('�غ�(kN)');
title('ʾ��ͼ�ͱù�ͼ');
legend('ʾ��ͼ', '�ù�ͼ');
