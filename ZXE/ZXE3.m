% ������϶��ζ���ʽ������ͼ�� %
function ZXE3(x,y,m)
S=zeros(1,2*m+1);T=zeros(m+1,1);

%�������淽����ĸ���Ԫ�ص�ֵ%
for k=1:2*m+1
    S(k)=sum(x.^(k-1));
end
for k=1:m+1
    T(k)=sum(x.^(k-1).*y);
end

A=zeros(m+1,m+1);a=zeros(m+1,1);

%�������и���Ԫ�ص�ֵ�γ����淽�������%
for i=1:m+1
    for j=1:m+1
        A(i,j)=S(i+j-1);
    end
end
a=A\T;  %�����϶��ζ���ʽ��ϵ��%

%��ӡ����Ϻ�Ķ��ζ���ʽ%
fprintf('��Ϻ���Ϊ��y=%.3f',a(1));
for k=2:m+1
    fprintf('+(%.3f)',a(k));
    for l=1:k-1
        fprintf('*x');
    end
end
fprintf('\n');

%����ϵĶ��ζ���ʽ���л�ͼ������ע�����㣬ͼ�����������ǩ%
z=0:.5:12;
f=a(1)+a(2).*z+a(3).*z.^2;
plot(x,y,'or',z,f)
t=strcat('y=',mat2str(a(1),4),'+',mat2str(a(2),4),'*x+(',mat2str(a(3),4),')*x*x');
legend('x,y sample',t);
for k=1:m+1
    s=strcat('(',mat2str(x(k),4),',',mat2str(y(k),4),')');
    text(x(k)+.2,y(k),s);
end
xlabel('x');ylabel('y');