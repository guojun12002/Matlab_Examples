%距离判别法，可判断样本属于类别。优点，直接输入类别总体，和样本数据，则可以直接判断样本属于类别。缺点：局限于两个总体%
function LengthJudge(X1,X2,x)
[p,n1]=size(X1);
[p,n2]=size(X2);
X_1=sum(X1,2)/n1;
X_2=sum(X2,2)/n2;
S1=zeros(p);
S2=zeros(p);
for a=1:n1
    Xa=zeros(p,1);
    for b=1:p
        Xa(b,1)=X1(b,a);
    end
    S1=S1+(Xa-X_1)*(Xa-X_1)';
end
for a=1:n2
    Xa=zeros(p,1);
    for b=1:p
        Xa(b,1)=X2(b,a);
    end
    S2=S2+(Xa-X_2)*(Xa-X_2)';
end
E=(S1+S2)/(n1+n2-2);
a=inv(E)*(X_1-X_2);
W=a'*(x-.5*(X_1+X_2));
if W>0
    fprintf('x->X1\n');
elseif W<0
    fprintf('x->X2\n');
else
    fprintf('It is difficult to Judge\n');
end
