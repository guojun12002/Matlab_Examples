function RBF()
file1=char('Number\0.bmp','Number\1.bmp','Number\2.bmp','Number\3.bmp','Number\4.bmp','Number\5.bmp','Number\6.bmp','Number\7.bmp','Number\8.bmp','Number\9.bmp');
file2=char('Letter\A.bmp','Letter\B.bmp','Letter\C.bmp','Letter\D.bmp','Letter\E.bmp','Letter\F.bmp','Letter\G.bmp','Letter\H.bmp','Letter\I.bmp','Letter\J.bmp');
%file1为输入数据，file2为目标输出数据

img=im2double(imread(file1(1,:)));
p=img(:);
    for j=1:14
        p=[p;0];
    end
b=reshape(p,7,7);
P1=max(eig(b));
for i=2:10
    img=im2double(imread(file1(i,:)));
    p=img(:);
    for j=1:14
        p=[p;0];
    end
    b=reshape(p,7,7);
    pp=max(eig(b));
    P1=[P1,pp];
end
%P1为输入数据的向量,同理求出输出数据的向量保存到P2里面

img=im2double(imread(file2(1,:)));
p=img(:);
    for j=1:14
        p=[p;0];
    end
b=reshape(p,7,7);
P2=max(eig(b));
for i=2:10
    img=im2double(imread(file2(i,:)));
    p=img(:);
    for j=1:14
        p=[p;0];
    end
    b=reshape(p,7,7);
    pp=max(eig(b));
    P2=[P2,pp];
end

%使用P1，P2数据进行RBF网络训练
%初始化网络训练参数，误差值为0.0001，散布常数为1；
%显示频率为1，隐含层的最大神经元数为20；
spread=1;
goal=1e-4;
df=1;
mn=20;
%建立网络模型
net=newrb(P1,P2,goal,spread,mn,df);
