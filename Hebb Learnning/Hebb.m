function Hebb(string)
load W1.mat;
load W2.mat;

% %首先使用自联想储存器进行计算，希望得到标准输入矩阵
% img=im2double(imread(string));
% pp=img(:);
% a1=W1*pp;
% for j=1:length(a1)
%      if a1(j)<=0
%         a1(j)=0;
%      else
%         a1(j)=1;
%      end
% end

%用Hebb学习网络进行异联想，输出结果
img_test=im2double(imread(string));
pp=img_test(:);
a2=W2*pp;
 for i=1:length(a2)
     if a2(i)<0.5
         a2(i)=0;
     else
         a2(i)=1;
     end
 end
b=~reshape(a2,7,5);
imshow(b);
imwrite(b,strcat('Output\out_',string(7:length(string))));
% imwrite(b,strcat('newout_',string(7:length(string))));