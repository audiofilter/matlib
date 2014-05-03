InitOpt;
ov = newOptSpace;

cirP.dim = 2;
cirP.center = [0 0];
cirP.radius = 5;
cirRegion = Region('sphere', cirP);

h1P.a = [1;0];
h1P.b = 0.01;
h1P.dim = 2;
h1 = Region('halfspace',h1P);

h2P.a = -[1/sqrt(3);-1];
h2P.b = 0;
h2P.dim = 2;
h2 = Region('halfspace',h2P);

h3P.a = [1/sqrt(3);1];
h3P.b = 0;
h3P.dim = 2;
h3 = Region('halfspace',h3P);

wedge = h1 * h2 * h3 * cirRegion;
%wedge = intersect(h1, intersect(h2, intersect(h3, cirRegion)));

M = [ [1;0] [1/2; sqrt(3)/2] ];
Ms = [ [0; sqrt(3)] [3/2; sqrt(3)/2] ];
ll = Lattice ( M );
% sublattice
lls1 = Lattice( Ms );
% shifts of sublattice
lls2 = lls1 + M(:,1);
lls3 = lls1 + M(:,2);
% freq domain
ldual = Lattice(inv(M)');
lsdual = Lattice(inv(Ms)');

%aas1 = optArray(lls1, wedge, ov);
aas2 = optArray(lls2, wedge, ov);
aas3 = optArray(lls3, wedge, ov);

aa0 = optArray([0 0], 1/3);

aawedge = aas2 + aas3;
aafull = aawedge;
for k=1:5
  aafull = aafull + rot(aawedge, k*pi/3, [1 2]);
end

aafull = aafull + aa0;

r = .6/3;
p2.dim = 2;
p2.points = ([0 0; r -r/sqrt(3); r r/sqrt(3)]);
rfreq = Region('convpoly', p2);

degs = 0:60:300;
rads = degs .* (pi/180);
hexP.points = [ cos(rads)' sin(rads)' ];
hexP.dim = 2;
hexRegion = Region('convpoly', hexP);

hexP.points = (2*r/sqrt(3))*[ sin(rads)' cos(rads)' ];
ShexRegion = Region('convpoly', hexP) | [2/3 0];

stopRegion = intersect(hexRegion, ShexRegion);

ltight = lsdual*0.01;

fPgrid = points(rfreq, ltight);
fSgrid = points(stopRegion, ltight);
Hpb = real(fourier(aafull, fPgrid));
Hsb = real(fourier(aafull, fSgrid));

delta = optVar(ov);
%soln = minimize( delta, {Hpb < 1+10^(-0.1/20), 1-10^(-0.1/20)<Hpb, ...
%		    -delta<Hsb, Hsb<delta}  , ov, 'sedumi');
soln = minimize(delta, {-delta<Hsb, Hsb<delta}, ov, 'sedumi');

ourfilt = optimal(aafull, soln);

lsqscale = .025;
lsq = lsqscale * Lattice([1 0 ; 0 1]);
p1.dim = 2; p1.points = 0.5*[2 2; -2 2; 2 -2; -2 -2];
rBigSquare = Region('convpoly', p1);
dualspts = points(rBigSquare, lsdual);
dualpts = points(rBigSquare, ldual);
plotgrid = points(rBigSquare, lsq);

fresp = fourier(ourfilt, plotgrid);
disp('done fourier')

FRESP = i2m(round(get_locs(fresp)/lsqscale), get_h(fresp));
disp('done i2m')

X = (1:size(FRESP,1)) * lsqscale - 2;
Y = (1:size(FRESP,2)) * lsqscale - 2;

%surf(X, Y, 20*log10(abs(FRESP)));
surf(X, Y, real(FRESP));
