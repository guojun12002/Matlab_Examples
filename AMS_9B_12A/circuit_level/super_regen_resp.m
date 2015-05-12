Farray=(-100:2:100)*1e3;
figure
Level=zeros(length(Farray),1);
for k = 1:length(Farray)
    Foffset=Farray(k);
    sim('super_regen_1x');
    Level(k)= Detector;
    plot(Farray,Level)
end;