 function [Z1,Z2]  =  xtal(Lo,Co,Ro,Cp,Rp,w);
 %        [Z1,Z2]  =  xtal(Lo,Co,Ro,Cp,w); 
 % Copywrite 2006-2010 The Mathworks, Inc.
 % Dick Benson
 
 % Xtal circuit model from manual circuit analysis.  
 % series Ro Lo Co in || with Cp
    wsq = w.*w;
    a = (1 - Lo*Co*wsq);    b = Ro*Co*w; 
    c = (-Ro*Co*Cp*wsq);    d = ((Cp+Co)-Lo*Cp*Co*wsq).*w;
    D = (c.*c + d.*d);
    X = (b.*c-a.*d)./D;
    R = (a.*c+b.*d)./D;
    Z = R+j*X;
    Z1 = 1./(1./Z + 1/Rp); 
  
% Use RF ToolBox for same calculation 
     
   rlc_1  = rfckt.seriesrlc('R',Ro,'L',Lo,'C',Co);
   c_1    = rfckt.seriesrlc('R',0,'L',0,'C',Cp);
   r_1    = rfckt.seriesrlc('R',Rp);
   N1     = rfckt.parallel('Ckts',{rlc_1,c_1,r_1});

   Zo   =  50;
   Zl   =  0; % note Zl = 0.
   analyze(N1,w/(2*pi),Zl,Zo,Zo); 
   % h = smith(N1,'GammaIn');
   
   % note that S11 is the input reflection coeff when terminated in Zo
   % this network is in then in series with Zo on the load end, 
   % therefore subtract Zo. 
    Z2=squeeze(gamma2z(N1.AnalyzedResult.S_Parameters(1,1,:),Zo))-Zo;
    
 
    