function training()
file1=char('Number\0.bmp','Number\1.bmp','Number\2.bmp','Number\3.bmp','Number\4.bmp','Number\5.bmp','Number\6.bmp','Number\7.bmp','Number\8.bmp','Number\9.bmp');
file2=char('Letter\A.bmp','Letter\B.bmp','Letter\C.bmp','Letter\D.bmp','Letter\E.bmp','Letter\F.bmp','Letter\G.bmp','Letter\H.bmp','Letter\I.bmp','Letter\J.bmp');
%设置一个自联想存储器，用于排除部分输入图像的“噪声”以及修复“破损”
W1=0;%权值矩阵
img=im2double(imread(file1(1,:)));
P1=img(:);
    for j=1:length(P1)
        if P1(j)==0
            P1(j)=-1;
        end
    end
for i=2:10
    img=im2double(imread(file1(i,:)));
    p=img(:);
    for j=1:length(p)
        if p(j)==0
            p(j)=-1;
        end
    end
    P1=[P1,p];
end
W1=P1*P1';
save('W1.mat','W1');%保存自联想存储器权值矩阵

% %测试
% img_test=im2double(imread('Input\0.bmp'));
% pp=img_test(:);
% a=W1*pp;
% for j=1:length(a)
%      if a(j)<=0
%         a(j)=0;
%      else
%         a(j)=1;
%      end
% end
% imshow(~reshape(a,7,5));

%Hebb规则线性联想器
W2=0;%权值矩阵
img1=im2double(imread(file1(1,:)));
P=img1(:);
img2=im2double(imread(file2(1,:)));
T=img2(:);
for i=2:10
    img1=im2double(imread(file1(i,:)));
    p=img1(:);
    P=[P,p];
    img2=im2double(imread(file2(i,:)));
    t=img2(:);
    T=[T,t];    
end
P_plus=inv(P'*P)*P';
W2=T*P_plus;
save('W2.mat','W2');%保存Hebb规则线性联想器权值矩阵

% %测试
% img_test=im2double(imread('Input\0.bmp'));
% pp=img_test(:);
% a=W2*pp;
%  for i=1:length(a)
%      if a(i)<0.5
%          a(i)=0;
%      else
%          a(i)=1;
%      end
%  end
% b=reshape(a,7,5);
% imshow(~b);

