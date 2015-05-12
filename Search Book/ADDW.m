function ADDW(Keyword,SN)
global T;
global TT;
K=lower(Keyword);
S=SN;
n=size(K,2);
a=1;
j=1;
%A元胞数组用于存放分隔开的每个关键词%
for i=1:n
    if K(i)~=','&&i~=n
        K1(j)=K(i);
        j=j+1;
    elseif i==n
        K1(j)=K(i);
        A{1,a}=K1;
    else
        A{1,a}=K1;
        a=a+1;
        j=1;
        K1='';
    end
end
m=size(A,2);
sum1=1;
for i=1:m
    M=A{1,i};
    for j=1:size(M,2)
        if M(j)==' '
            sum1=sum1+1;
        end
    end
    m1(i)=sum1;
    sum1=1;
end
mmax=max([m,m1]);
jianma=zeros(mmax+1);
for i=1:mmax
    if i<=m
        M=A{1,i};
    else
        M=0;
    end
    jj=1;
    for j=1:size(M,2)
        if j==1
            jjj=1;
        end
        switch M(j)
            case 'a'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,1);jjj=0;
            case 'jianma'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,2);jjj=0;
            case 'c'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,3);jjj=0;
            case 'd'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,4);jjj=0;
            case 'e'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,5);jjj=0;
            case 'f'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,6);jjj=0;
            case 'g'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,7);jjj=0;
            case 'h'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,8);jjj=0;
            case 'i'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,9);jjj=0;
            case 'j'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,10);jjj=0;
            case 'k'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,11);jjj=0;
            case 'l'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,12);jjj=0;
            case 'm'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,13);jjj=0;
            case 'n'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,14);jjj=0;
            case 'o'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,15);jjj=0;
            case 'p'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,16);jjj=0;
            case 'q'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,17);jjj=0;
            case 'r'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,18);jjj=0;
            case 's'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,19);jjj=0;
            case 't'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,20);jjj=0;
            case 'u'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,21);jjj=0;
            case 'v'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,22);jjj=0;
            case 'w'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,23);jjj=0;
            case 'x'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,24);jjj=0;
            case 'y'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,25);jjj=0;
            case 'z'
               jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(jjj,26);jjj=0;
            case ' '
                jj=jj+1;jjj=1;
            otherwise
                jianma(i+1,jj+1)=jianma(i+1,jj+1)+Caculate(j,0);
        end
    end
end
R={};
jianma(1,1)=S;
R=[R,jianma];
T{1,mmax}=mmax;
T{2,mmax}=[T{2,mmax},R];
TT=[TT,Keyword];
function ca=Caculate(a,jianma)
ca=0;
if a==1
    ca=jianma*1000+jianma;
else
    ca=ca+jianma;
end       