function M(A)
[m,n]=size(A);
fprintf('��������ʽΪ��%f\n',det(A));
B=inv(A);
[u,v]=eigs(B);
fprintf('��������������ֵΪ��');
for i=1:n
    fprintf('%f\t',v(i,i));
end
x=0;
for i=1:n
    x=x+A(1,i);
end
fprintf('\n�����һ��Ԫ��֮��Ϊ:%f\n',x);