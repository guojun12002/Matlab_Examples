function data()
global xx;
 a0 =       1.369 ;
       a1 =      -1.242 ;
       b1 =   -0.004747 ;
       a2 =     -0.1066 ;
       b2 =    -0.02098  ;
       a3 =    -0.01754  ;
       b3 =     0.02717  ;
       a4 =   -0.003438 ;
       b4 =    0.002133 ;
       w =     0.04365;
for x=1:144/459:144
    y=a0 + a1*cos(x*w) + b1*sin(x*w) + a2*cos(2*x*w) + b2*sin(2*x*w) + a3*cos(3*x*w) + b3*sin(3*x*w) + a4*cos(4*x*w) + b4*sin(4*x*w);
    xx=[xx,y];
end