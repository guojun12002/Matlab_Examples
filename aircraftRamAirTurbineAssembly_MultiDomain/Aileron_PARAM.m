% PARAMETERS FOR HYDRAULIC CYLINDER
RO = 0.1;
t = 0.005;
h = 2.5;
lic = -1.1;
rho = 1000;

APist = pi*(RO - 2*t)*(RO - 2*t);
ROO = RO;
RIO = RO - t;
ROI = RO-t;
RII = RO- 2*t;
h_seg = h/2;

ro = ROO;
ri = RIO;
h = h_seg;
rho = rho;
rot_oc = [0 0 165];

mass_OC = rho*pi*(ro*ro-ri*ri)*h;
inertia_OC = mass_OC*([(3*ro*ro + h*h) 0 0;0 6*ro*ro 0;0 0 (3*ro*ro + h*h)]-[(3*ri*ri + h*h) 0 0;0 6*ri*ri 0;0 0 (3*ri*ri + h*h)])/12;

ro = ROI;
ri = RII;
h = h_seg;
rho = rho;
rot_ic = [0 0 0];

mass_IC = rho*pi*(ro*ro-ri*ri)*h;
inertia_IC = mass_IC*([(3*ro*ro + h*h) 0 0;0 6*ro*ro 0;0 0 (3*ro*ro + h*h)]-[(3*ri*ri + h*h) 0 0;0 6*ri*ri 0;0 0 (3*ri*ri + h*h)])/12;

a = 0.1;
b = 2;
c = 0.05;
rho = 1000;
theta = 180;

mass_Link = rho*a*b*c;
inertia_Link = rho*a*b*c*[(b^2+c^2) 0 0; 0 (a^2+c^2) 0; 0 0 (a^2+b^2)]/12;

Actuator_Attach_Pt = [0 -0.2 0];
Actuator_Wing_Pt = [-0.5 0 0];
Outer_Cylinder_Length = 0.35;
Inner_Cylinder_Length = 0.25;

Outer_Cyl_Axis = Actuator_Wing_Pt - Actuator_Attach_Pt;
%Outer_Cyl_Axis = Outer_Cyl_Axis/(sqrt(sum(Outer_Cyl_Axis.*Outer_Cyl_Axis)));

%Actuator_Angle = atan(Outer_Cyl_Axis(2)/Outer_Cyl_Axis(1))*180/pi;
Actuator_Angle = -10;
Outer_Cyl_CS2 = Outer_Cyl_Axis*Outer_Cylinder_Length;

Cylinder_Overlap = 0.05 ;

Signal_Times = linspace(0,0.5,11);
Signal_Values = [0 1 1 0 0 -1 -1 0 0 0 0];

Airfoil_Length = 1;
Airfoil_Thickness_1 = 0.25;
Airfoil_Thickness_2 = 0.2;
Airfoil_Offset_1=0.15;
Airfoil_Offset_2=-0.13;
Airfoil_Nose_Length = 0.10;

Wind_Offset = 0.7;

Ka = 1*1e-1;
Kb = 2500;

Ka_Final = 0.1791;
Kb_Final = 343.75;