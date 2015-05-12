function Edmonds(A)
[m,n]=size(A);
M=zeros(m,n);
for i=1:m
    for j=1:n
        if A(i,j)
            M(i,j)=1;
            break;
        end
    end
    if M(i,j)
        break;
    end
end
while 1
    for i=1:m
        x(i)=0;
    end
    for i=1:n
        y(i)=0;
    end
    for i=1:m
        pd=1;
        for j=1:n
            if M(i,j)
                pd=0;
            end
        end
        if pd
            x(i)=-n-1;
        end
    end
    pd=0;
    while (1)
        xi=0;
        for i=1:m
           if x(i)<0
                xi=i;
                break;
           end
        end
        if xi==0
            pd=1;
            break;
        end
        x(xi)=x(xi)*(-1);
        k=1;
        for j=1:n
            if (A(xi,j)&y(j)==0)
                y(j)=xi;
                yy(k)=j;
                k=k+1;
            end
        end
        if k>1
            k=k-1;
            for j=1:k
                pdd=1;
                for i=1:m
                    if M(i,yy(j))
                        x(i)=-yy(j);
                        pdd=0;
                        break;
                    end
                end
                if pdd
                    break;
                end
            end
            if pdd
                k=1;
                j=yy(j);
                while (1)
                    P(k,2)=j;
                    P(k,1)=y(j);
                    j=abs(x(y(j)));
                    if j==n+1
                        break;
                    end
                    k=k+1;
                end
                for i=1:k
                    if M(P(i,1),P(i,2))
                        M(P(i,1),P(i,2))=0;
                    else
                        M(P(i,1),P(i,2))=1;
                    end
                end
                break;
            end
        end
    end
    if pd
        break;
    end
end
M