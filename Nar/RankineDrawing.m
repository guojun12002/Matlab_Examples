function RankineDrawing
% Boiler
Bx = [2 2 11 11 2];
By = [9 18 18 9 9];

% Turbine 
T1x = [20 20 23 23 20];
T1y = [16 18 20 14 16];

% Condenser
Cx = [21 25 25 21 21];
Cy = [10 10 3 3 10];

% Pump
R = 2;
x0 = 13; y0 = 2;
for theta = 1 : 360 
    Px(theta) = x0 + R * cosd(theta);
    Py(theta) = y0 + R * sind(theta);
end

% From Pump to Turbine  Way
PTx = [11.2 4 4 20];
PTy = [3 3 17 17];

% From Turbine to Condenser
TCx = [23 23];
TCy = [14 10];

% From Condenser to Pump
CPx = [23 23 14.8];
CPy = [3 1 1];

% Connection between Turbines

con2x = [23 24];
con2y = [17 17];
arrowturbinex = [24 25 24 24];
arrowturbiney = [17.5 17 16.5 17.5];

% Arrows
A1x = [13.5 14 13.5]; A1y = [17.5 17 16.5];
A4x = [22.5 23 23.5]; A4y = [11.5 11 11.5];
A5x = [16.5 16 16.5]; A5y = [1.5 1 0.5];
A6x = [3.5 4 4.5]   ; A6y = [5.5 6 5.5];

% Plotting
plot(Bx,By,'k','linewidth',2);
hold on;
plot(T1x,T1y,'k','linewidth',2);
plot(Cx,Cy,'k','linewidth',2);
plot(Px,Py,'k','linewidth',2);
plot(PTx,PTy,'--r','linewidth',2);
plot(TCx,TCy,'--r','linewidth',2);
plot(CPx,CPy,'--r','linewidth',2);
plot(con2x,con2y,'k','linewidth',10);
% plot(A1x,A1y,'r','linewidth',3);
% plot(A4x,A4y,'r','linewidth',3);
% plot(A5x,A5y,'r','linewidth',3);
% plot(A6x,A6y,'r','linewidth',3);
% plot(arrowturbinex,arrowturbiney,'k','linewidth',3);
axis([0 28 0 20])
text(14,17.2,'\rightarrow','FontSize',28,'FontWeight','demi');
text(22.4,11,'\downarrow','FontSize',28,'FontWeight','demi');
text(16,1.2,'\leftarrow','FontSize',28,'FontWeight','demi');
text(3.4,6,'\uparrow','FontSize',28,'FontWeight','demi');
text(22.5,9.5,'Condenser','FontSize',14,'rotation',270,'FontWeight','demi','fontname','calibri');
text(11.5,2,'Pump','FontSize',14,'FontWeight','demi','fontname','calibri');
text(3,17.8,'Steam Generator','FontSize',14,'rotation',270,'FontWeight','demi','fontname','calibri');
text(25,17,'Turbine','FontSize',14,'FontWeight','demi','fontname','calibri');
text(A1x(2),A1y(2)+1,'1','FontSize',12,'FontWeight','demi','fontname','calibri');
text(A4x(2)+1,A4y(2)+0.5,'2','FontSize',12,'FontWeight','demi','fontname','calibri');
text(A5x(2),A5y(2)+1,'3','FontSize',12,'FontWeight','demi','fontname','calibri');
text(A6x(2)-1,A6y(2),'4','FontSize',12,'FontWeight','demi','fontname','calibri');