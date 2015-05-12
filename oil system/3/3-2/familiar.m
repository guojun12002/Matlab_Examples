function familiar()
load matrix;
R=max(max(mtx));
J=size(mtx,1);
K=size(mtx,2);
b=zeros(1,R);
p=zeros(1,R);
for r=1:R
    for j=1:J
        for k=1:K
            if mtx(j,k)==r
                b(r)=b(r)+1;
            end
        end        
    end
end
for r=1:R
    p(r)=b(r)/(J*K);
end

%灰度均值
g_=0;
for r=1:R
    g_=g_+r*p(r);
end

%灰度方差
sigma_2=0;
for r=1:R
    sigma_2=sigma_2+((r-g_)^2)*p(r);
end

%灰度偏度
S=0;
for r=1:R
   S=S+(1/(sqrt(sigma_2))^3)*((r-g_)^3)*p(r);
end

%灰度峰度
P=0;
for r=1:R
    P=P+(1/(sigma_2)^2)*((r-g_)^4)*p(r);
end

%灰度能量
E=0;
for r=1:R
   E=E+(p(r))^2; 
end

%灰度熵
T=0;
for r=1:R
    T=T+(-1)*(1-p(r))*log10(1-p(r));
end

global F;
F=[g_ sigma_2 S P E T]

