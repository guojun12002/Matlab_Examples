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

%�ҶȾ�ֵ
g_=0;
for r=1:R
    g_=g_+r*p(r);
end

%�Ҷȷ���
sigma_2=0;
for r=1:R
    sigma_2=sigma_2+((r-g_)^2)*p(r);
end

%�Ҷ�ƫ��
S=0;
for r=1:R
   S=S+(1/(sqrt(sigma_2))^3)*((r-g_)^3)*p(r);
end

%�Ҷȷ��
P=0;
for r=1:R
    P=P+(1/(sigma_2)^2)*((r-g_)^4)*p(r);
end

%�Ҷ�����
E=0;
for r=1:R
   E=E+(p(r))^2; 
end

%�Ҷ���
T=0;
for r=1:R
    T=T+(-1)*(1-p(r))*log10(1-p(r));
end

global F;
F=[g_ sigma_2 S P E T]

