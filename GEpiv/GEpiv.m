function GEpiv(A,b)
[m,n]=size(A);
nb=n+1;Ab=[A b];
for i=1:m-1
    [pivot,p]=max(abs(Ab(i:n,i)));
    ip=p+i-1;
    if ip~=i
        Ab([i ip],:)=Ab([ip i],:);
    end
    pivot=Ab(i,i);
    for k=i+1:m
        Ab(k,i:nb)=Ab(k,i:nb)-(Ab(k,i)/pivot)*Ab(i,i:nb);
    end
end
x=zeros(n,1);
x(n)=Ab(n,nb)/Ab(n,n);
for i=n-1:-1:1
    x(i)=(Ab(i,nb)-Ab(i,i+1:n)*x(i+1:n,1))/Ab(i,i);
end
for k=1:n
    fprintf('x[%d]=%f\n',k,x(k));
end