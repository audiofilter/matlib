global x y d px py m b;
px=3; py=1; m=-2; b=2;

InitOpt;
ov=newOptSpace;
x=optVar(ov);
y=optVar(ov);

d=optVar(ov);
%constr={y<m*x+b, (x-px).^2+(y-py).^2<d.^2}; % doesn't work yet
%constr={y<m*x+b, sum((x-px).^2)+sum((y-py).^2)<d.^2};
constr={y<m*x+b, energy(x-px)+energy(y-py)<energy(d)};
soln=minimize(d,constr,ov,'sedumi');
%soln=minimize(d,constr,ov,'loqosoclp','plot1');

plot1(soln);