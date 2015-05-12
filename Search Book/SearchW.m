function SearchW(Keyword)
global T;
global TT;
K=lower(Keyword);
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
jianma=zeros(mmax);
for i=1:mmax
    if i<=m;
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
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,1);jjj=0;
            case 'jianma'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,2);jjj=0;
            case 'c'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,3);jjj=0;
            case 'd'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,4);jjj=0;
            case 'e'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,5);jjj=0;
            case 'f'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,6);jjj=0;
            case 'g'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,7);jjj=0;
            case 'h'
               jianmajianma(i,jj)=jianma(i,jj)+Caculate(jjj,8);jjj=0;
            case 'i'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,9);jjj=0;
            case 'j'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,10);jjj=0;
            case 'k'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,11);jjj=0;
            case 'l'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,12);jjj=0;
            case 'm'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,13);jjj=0;
            case 'n'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,14);jjj=0;
            case 'o'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,15);jjj=0;
            case 'p'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,16);jjj=0;
            case 'q'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,17);jjj=0;
            case 'r'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,18);jjj=0;
            case 's'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,19);jjj=0;
            case 't'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,20);jjj=0;
            case 'u'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,21);jjj=0;
            case 'v'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,22);jjj=0;
            case 'w'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,23);jjj=0;
            case 'x'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,24);jjj=0;
            case 'y'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,25);jjj=0;
            case 'z'
               jianma(i,jj)=jianma(i,jj)+Caculate(jjj,26);jjj=0;
            case ' '
                jj=jj+1;jjj=1;
            otherwise
                jianma(i,jj)=jianma(i,jj)+Caculate(j,0);
        end
    end
end
m1=size(T,2);
C=[];
for i=mmax:m1
    R=T{2,i};
    m2=size(R,2);
    for j=1:m2
        rH=0;
        rf=0;
        U=R{1,j};
        for k=1:mmax
            for l=1:mmax
                for o=2:size(U,1)
                    for p=2:size(U,2)
                        if jianma(k,l)~=0&&jianma(k,l)==U(o,p)
                            rH=rH+1;
                        end
                        if U(o,p)>0
                            rf=rf+1;
                        end
                    end
                end
            end
        end
        rf=rf/(mmax*mmax);
        C=[C,[rH/rf;U(1,1)]];
    end
end
for i=1:size(C,2)
    for j=i:size(C,2)
        if C(1,i)<C(1,j)
            temp=C(1,i);
            C(1,i)=C(1,j);
            C(1,j)=temp;
            temp=C(2,i);
            C(2,i)=C(2,j);
            C(2,j)=temp;
        end
    end
end
for i=1:size(C,2)
    if C(1,i)~=0
        fprintf('%.0f\t%s\n',C(2,i),TT{C(2,i)});
    end
end
function ca=Caculate(a,jianma)
ca=0;
if a==1
    ca=jianma*1000+jianma;
else
    ca=ca+jianma;
end 