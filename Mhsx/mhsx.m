function mhsx()
m=input('数组的行数（特征参数）是');
n=input('数组的列数(论域)是');
a=zeros(m,n);
for i=1:m
for j=1:n
    fprintf('请输入%d行',i)
    fprintf('%d列的值',j)
    a(i,j)=input('');
end
end
a
mi=zeros(m,1);
ma=zeros(m,1);
for i=1:m
    ma(i,1)=max(a(i,:));
    mi(i,1)=min(a(i,:));
end
for i=1:m
    for j=1:n
        a(i,j)=(a(i,j)-mi(i,1))/(ma(i,1)-mi(i,1));
    end
end
fprintf('标准化后的矩阵是')
a
for h=1:6
c=input('欧式距离法中c的取值是');
R=zeros(n,n);
r=zeros(n,n);
b=a'
for i=1:n
    for j=1:n
        for k=1:m
        R(i,j)=R(i,j)+(b(i,k)-b(j,k))^2;
        end
        r(i,j)=1-c*sqrt(R(i,j));
    end
end
fprintf('模糊相似矩阵是')
r
end
%'在上面的多种情况中选取合适的c值和模糊相似矩阵';
%利用平方法求传递闭包，利用下一个m文件，直到得到需要的闭包T为止（模糊等价矩阵）
z=zeros(1,n);
T=zeros(n,n);
for i=1:n
    for j=1:n
        for k=1:n
            z(k)=min(r(i,k),r(k,j));
        end
        T(i,j)=max(z);
    end
end
for x=1:5%平方法求传递闭包
    r=T;
    for i=1:n
    for j=1:n
        for k=1:n
            z(k)=min(r(i,k),r(k,j));
        end
        T(i,j)=max(z);
    end
    end
end
fprintf('模糊等价矩阵是')
T
r




        




    