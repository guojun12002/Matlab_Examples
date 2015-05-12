function BP(X,Y)
% P=[。。。];输入T=[。。。];输入数据格式是5行2列
%数据
P=X';
T=Y';


%  创建一个新的前向神经网络 
net=newff(minmax(P),[5,2],{'tansig','purelin'},'traingdm')


net.trainParam.epochs = 10000;
net.trainParam.goal = 0.1;
LP.lr=0.1;
%  调用 TRAINGDM 算法训练 BP 网络
net=train(net,P,T);

%  对 BP 网络进行仿真
A = sim(net,P);
%  计算仿真误差 
E = T - A;
MSE=mse(E)
x=1:100;
y=sim(net,x)
plot(x,y(2,:));