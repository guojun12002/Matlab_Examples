function Lottery(n,P,x,r)
f=zeros(2,29);
for i=1:29
    f(1,i)=i;
end
for a=1:29
sum1=0;sum2=0;sum3=0;
%计算sum1%
for k=4:7
    sum1=sum1+P(a,k)*x(a,k);
end
if a==23
    sum1=sum1+P(a,2)*x(a,2)+P(a,3)*x(a,3);
end
%把x矩阵填充完毕%
for i=1:3
    if a~=23
        x(a,i)=r(a,i)*(1-sum1)*n;
    end
    if a==23
        if i==1
            x(a,i)=r(a,i)*(1-sum1)*n;
        end
    end
end
%计算sum3，当a=23时情况不同%
if a~=23
for i=1:3
    for k=4:7
            sum3=sum3+P(a,k)*(1-(1-P(a,i))^n)*x(a,k)*r(a,i);
    end
end
end
if a==23
    for k=2:7
        sum3=sum3+P(a,k)*x(a,k)*(1-(1-P(a,1))^n)*r(a,1);
    end
end
%计算sum2，当a=23时情况不同%
if a~=23
for i=1:3
    sum2=sum2+r(a,i)*(1-(1-P(a,i))^n);
end
end
if a==23
    sum2=(1-(1-P(a,1))^n)*r(a,1);
end
%方程组解%
t=sum1+sum2-sum3;
s=sum(P(a,4:7).*x(a,4:7))/sum(P(a,1:7).*x(a,1:7));
d=(((1-s)*sum2)/3)^3*(s/4)^4;
mu=d^(1/7)*7;
f(2,a)=(1-exp(-(n*t)))*mu;
end
for i=1:29
    for j=i:29
        if f(2,i)<f(2,j)
            temp=f(2,i);
            f(2,i)=f(2,j);
            f(2,j)=temp;
            clear temp;
            temp=f(1,i);
            f(1,i)=f(1,j);
            f(1,j)=temp;
            clear temp;
        end
    end
end
format long
x
format short
f