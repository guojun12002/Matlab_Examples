function Dijkstra(S)
n=size(S,1);
for i=1:n
    l(i)=S(1,i);
    z(i)=1;
end
s=[];
s(1)=1;
v=1;
for k=1:n
    s(k)=v;
    u=s(k);
    for i=1:n
        for j=1:k
            if i~=s(j)
                if l(i)>l(u)+S(u,i)
                    l(i)=l(u)+S(u,i);
                    z(i)=u;
                end
            end
        end
    end
    l1=l;
    for i=1:n
        for j=1:k
            if i==s(j)
                l1(i)=inf;
            end
        end
    end
    lv=inf;
    for i=1:n
        if l1(i)<lv
            lv=l1(i);
            v=i;
        end
    end
end
l
z