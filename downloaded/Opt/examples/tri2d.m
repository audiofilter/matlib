InitOpt;
ov = newOptSpace;

%=========================
% Define impulse response
%=========================
% here, create a 2N x 2N impulse response with symmetry through the
% origin. First, define a single quadrant of points, not including
% the coordinate axes. Then, define one half-axis, not including
% the center point. Finally, define the center point.
N = 5;
p1.dim = 2;
p1.points = [1 1; 1 N; N 1; N N];
quadrantBoundary = Region('convpoly', p1);
% quadrant boundary is a Region, which is a square with corners at
% (1,1) and (N,N). A 'convpoly' region is defined by its corner points.
p1.points = [-.1 1; .1 1; -.1 N; .1 N];
gutterBoundary = Region('convpoly', p1);
% gutterBoundary is used for a half-axis, not including the
% origin. It is a rectangle with vertices given as above. Note that
% it is only wide enough, given a square integer lattice of points,
% to contain points on the axis.

sqlat = Lattice(eye(2));
% sqlat is a square, integer lattice
aa1 = optArray(sqlat, quadrantBoundary, ov);
aa2 = optArray(sqlat, quadrantBoundary, ov);
% two impulse responses are created on the same set of points, the
% square lattice points contained within the quadrantBoundary
% region. 
ca1 = optArray(sqlat, gutterBoundary, ov);
ca2 = optArray(sqlat, rot(gutterBoundary, pi/2), ov);
% two impulse responses for the axes; note that the gutterBoundary
% region is rotated prior to creating the impulse response for the
% x-axis. 
ca = optArray([0 0], ov);
% ca is the center point
aa = aa1+ aa1' + flip(aa2, 1) + flip(aa2, 2) ...
    +ca + ca1 + ca1' + ca2 + ca2';
% aa, the entire impulse response, is the sum of various flips of
% the components.

%===========================
% Define pass and stopbands
%===========================
% The following creates a filter with a square passband minus a
% single-point stopband at the origin. Note that because of the
% symmetry of the impulse response, only half of the fundamental
% period need be considered.
pp = NDProcess('Triangle', .9*[.2 .2; .2 .2], ...
	       [.1 .1; .1 -.1], ...
	       [1 1]);
% pp is the passband process; it consists of two triangle basis
% functions located at (.1,.1) and (.1,-.1), each 90% of 
% (.2 x .2).  The fact that the frequency shift matrix is of width
% 2 ensures that the process is 2-D.
ps = NDProcess('Box', [.5 1; .25 .5], [.25 0; .125 0], [1 -1]);
% ps is the process for the outer stopband. It consists of a box
% corresponding to the entire half of the fundamental period with
% a box slightly larger than the passband taken from it (so one
% coefficient is 1 and the other is -1.)
psc = NDProcess('Impulse', [], [0 0], 1);
% psc is the process for the one-point stopband at the origin. As
% no parameter is needed for the 'Impulse' basis function, the
% empty matrix [] is used.
ppwr = pwr(pp.*aa-pp);
spwr = pwr(ps.*aa)/pwr(ps);
scpwr = pwr(psc.*aa)/pwr(psc);
% The various powers are computed. The power of the stopband
% processes through the filter aa are to be constrained to be
% small. The passband is treated differently; in that case, we
% minimize the difference in power between the unfiltered and
% filtered passband process.

%==============================
% Set up constraints and solve
%==============================
delta = 100*optVar(ov);
constr = {ppwr < delta.^2, spwr < 1e-4, scpwr < 1e-9};
	  
soln = minimize(delta, constr, ov, 'sedumi');
himp = full(get_h(optimal(aa,soln)));

flt = i2m(get_locs(aa),himp);
% i2m converts the resulting filter himp, which is on a square grid
% indexed by a matrix of locations, to the matrix form required by
% fft2 and surf.
Tsize = 100; Tvec = linspace(-.5, .5, Tsize);
FLT = fftshift(fft2(flt,Tsize,Tsize));

surf(Tvec, Tvec, 20*log10(abs(FLT)));
xlabel('x'), ylabel('y')
