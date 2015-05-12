function [D,P]=Floyd(D)
n=size(D,1);
P=zeros(n);
for k=1:n
    for i=1:n
        for j=1:n
            if D(i,j)>D(i,k)+D(k,j)
                D(i,j)=D(i,k)+D(k,j);
                P(i,j)=k;
            end
        end
    end
end