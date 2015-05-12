function caculate()
b=2.495;
l=3.675;
r=0.950;
m=b;
n=-(l+r);
a=4.315;
hold on;
for i=0:0.001:2     
u=i*pi;
x1=m+r*sin(u);
y1=n+r*cos(u);
c=x1^2+y1^2+b^2-l^2;
y=-(2*c*y1+2*sqrt(4*x1^2*y1^2*b^2+4*x1^4*b^2-x1^2*c^2))/(4*(x1^2+y1^2));
%y=-((2*(m + r*sin(u))^2*(2*r*cos(u)*(m + r*sin(u)) - 2*r*sin(u)*(n + r*cos(u)))*(b^2 - l^2 + (n + r*cos(u))^2 + (m + r*sin(u))^2) - 16*b^2*r*cos(u)*(m + r*sin(u))^3 + 2*r*cos(u)*(m + r*sin(u))*(b^2 - l^2 + (n + r*cos(u))^2 + (m + r*sin(u))^2)^2 - 8*b^2*r*cos(u)*(n + r*cos(u))^2*(m + r*sin(u)) + 8*b^2*r*sin(u)*(n + r*cos(u))*(m + r*sin(u))^2)/(4*b^2*(m + r*sin(u))^4 - (m + r*sin(u))^2*(b^2 - l^2 + (n + r*cos(u))^2 + (m + r*sin(u))^2)^2 + 4*b^2*(n + r*cos(u))^2*(m + r*sin(u))^2)^(1/2) - (n + r*cos(u))*(4*r*cos(u)*(m + r*sin(u)) - 4*r*sin(u)*(n + r*cos(u))) + r*sin(u)*(2*b^2 - 2*l^2 + 2*(n + r*cos(u))^2 + 2*(m + r*sin(u))^2))/(4*(n + r*cos(u))^2 + 4*(m + r*sin(u))^2) + ((2*(4*b^2*(m + r*sin(u))^4 - (m + r*sin(u))^2*(b^2 - l^2 + (n + r*cos(u))^2 + (m + r*sin(u))^2)^2 + 4*b^2*(n + r*cos(u))^2*(m + r*sin(u))^2)^(1/2) + (n + r*cos(u))*(2*b^2 - 2*l^2 + 2*(n + r*cos(u))^2 + 2*(m + r*sin(u))^2))*(8*r*cos(u)*(m + r*sin(u)) - 8*r*sin(u)*(n + r*cos(u))))/(4*(n + r*cos(u))^2 + 4*(m + r*sin(u))^2)^2;
S=a*abs(y)/b;
plot(i,y);

end
