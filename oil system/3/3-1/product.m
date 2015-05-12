function product()
Spe;%柱塞有效冲程,m
dQp;%抽油泵一次冲次的漏失量,m^3/次
namta_v;%泵排出压力条件下有关内混合物的体积系数
Ns;%抽油机的冲次,min^-1
Ap;%柱塞横截面积,m^2
Sr;%悬点冲程长度，m
nw;%标准条件下混合液的含水率,%
Bo;%井下原油体积系数m^3/m^3
Bw;%井下水的体积系数m^3/m^3

%混合液体积系数namta_v的计算
namta_v=1/((1-nw)*B0+nw*Bw);

%理论产液量
Qth=1440*Sr*Ns*Ap;

%实际产液量计算模型
Q=1440*Ns*(Spe*Ap-dQp)*namta_v;

