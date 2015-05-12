function range=getaxis(x,y,f1,f2)
% range=getaxis(x,y,f1,f2)
xmin=min(x(:)); xmax=max(x(:)); 
ymin=min(y(:)); ymax=max(y(:));
fmin=min([f1(:);f2(:)]); fmax=max([f1(:);f2(:)]);
range=[xmin,xmax,ymin,ymax,fmin,fmax];