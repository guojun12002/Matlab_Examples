function M(A)
[m,n]=size(A);
fprintf('矩阵行列式为：%f\n',det(A));
B=inv(A);
[u,v]=eigs(B);
fprintf('矩阵的逆矩阵特征值为：');
for i=1:n
    fprintf('%f\t',v(i,i));
end
x=0;
for i=1:n
    x=x+A(1,i);
end
fprintf('\n矩阵第一行元素之和为:%f\n',x);