function mhsx()
m=input('�����������������������');
n=input('���������(����)��');
a=zeros(m,n);
for i=1:m
for j=1:n
    fprintf('������%d��',i)
    fprintf('%d�е�ֵ',j)
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
fprintf('��׼����ľ�����')
a
for h=1:6
c=input('ŷʽ���뷨��c��ȡֵ��');
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
fprintf('ģ�����ƾ�����')
r
end
%'������Ķ��������ѡȡ���ʵ�cֵ��ģ�����ƾ���';
%����ƽ�����󴫵ݱհ���������һ��m�ļ���ֱ���õ���Ҫ�ıհ�TΪֹ��ģ���ȼ۾���
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
for x=1:5%ƽ�����󴫵ݱհ�
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
fprintf('ģ���ȼ۾�����')
T
r




        




    