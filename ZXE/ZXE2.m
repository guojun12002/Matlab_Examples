function ZXE2(x,y)
T=zeros(2,1);A=zeros(2,2);a=zeros(2,1);
A(1,1)=sum(x.^0);
A(1,2)=sum(x.^2);
A(2,1)=sum(x.^2);
A(2,2)=sum(x.^4);
T(1,1)=sum(y);
T(2,1)=sum(y.*x.^2);
a=A\T;
for k=1:2
    fprintf('a[%d]=%f\n',k,a(k))
end