function BP(X,Y)
% P=[������];����T=[������];�������ݸ�ʽ��5��2��
%����
P=X';
T=Y';


%  ����һ���µ�ǰ�������� 
net=newff(minmax(P),[5,2],{'tansig','purelin'},'traingdm')


net.trainParam.epochs = 10000;
net.trainParam.goal = 0.1;
LP.lr=0.1;
%  ���� TRAINGDM �㷨ѵ�� BP ����
net=train(net,P,T);

%  �� BP ������з���
A = sim(net,P);
%  ���������� 
E = T - A;
MSE=mse(E)
x=1:100;
y=sim(net,x)
plot(x,y(2,:));