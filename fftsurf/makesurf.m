function makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2)
% makesurf(ti,x,y,f1,n1,sig1,f2,n2,sig2)
% This function plots two surfaces juxtaposed 
% in fullscreen mode
titl=@(ti,n,sig) [ti,' for n = ',num2str(n),...
               '  &  s = ',num2str(sig)];
close; range=getaxis(x,y,f1,f2);  
subplot(1,2,1), surf(x,y,f1), title(titl(ti,n1,sig1))
xlabel('x axis'),ylabel('y axis'), zlabel('z axis')
axis equal, axis(range), subplot(1,2,2)
surf(x,y,f2), title(titl(ti,n2,sig2))
xlabel('x axis'),ylabel('y axis'), zlabel('z axis')
axis equal, axis(range),colormap([1 1 0])
u=get(gcf,'units');
set(gcf,'units','normalized','outerposition',[0,0,1,1]);
set(gcf,'units',u),shg  