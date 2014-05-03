InitOpt;
ov = newOptSpace;

%=========================
% Define impulse response
%=========================
% here, create a 2N x 2N impulse response with symmetry through the
% origin. First, define a single quadrant of points, not including
% the coordinate axes. Then, define one half-axis, not including
% the center point. Finally, define the center point. The quadrants
% are intersected with a circular region because of the
% circularly-symmetric passband we desire here.
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
p2.dim = 2;
p2.center = [0 0];
p2.radius = N;
circleB = Region('sphere', p2);
% circleB is a circular region defined by its center and radius. It
% is called 'sphere' becuase it can be generalized to any dimensionality.

sqlat = Lattice(eye(2));
% sqlat is a square, integer lattice
aa1 = optArray(sqlat, quadrantBoundary*circleB, ov);
aa2 = optArray(sqlat, quadrantBoundary*circleB, ov);
% two impulse responses are created on the same set of points, the
% square lattice points contained within the region which is the
% intersection of circleB and quadrantBoundary. Note that the
% intersection can be found using the function call
%     intersect(quadrantBoundary, circleB)
% but is more conveniently found using the * operator. A union of
% regions would be found using union(a,b) or the + operator.
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
% The desired passband is a thin annulus between radii .245 and
% .255. This is accomplished by subtracting a circle of the smaller
% radius from a circle of the larger radius, and hence the
% coefficient vector is [1; -1]. Both circles are centered at the
% origin.
pp = NDProcess('Circle', [.255;.245], [0 0; 0 0], [1; -1]);
ps = NDProcess({'Box'; 'Circle'; 'Circle'}, {[1 1]; .32; .18}, ...
	       [0 0; 0 0; 0 0], [1; -1; 1]);
% The stopband is more complicated; starting with a box to indicate
% the entire fundamental period of the frequency response, we
% subtract a circle slightly larger than the outer ring of the
% annulus, and add back to the stopband a circle slightly smaller
% than the inner ring of the annulus. 
% Since this process is composed of different types of basis
% functions, the function call to NDProcess is a bit more
% complicated. The basis function types must now be specified for
% each instance of a basis function in a cell array column
% vector. A cell array is created using the {} and the entries are
% separated by semicolons.
% Similarly, the parameters for each basis function instance must
% be given in separate entries of a cell array column vector. 'Box'
% requires a width vector [1 1] which indicates a width of 1 in the
% x-direction and a width of 1 in the y-direction. 'Circle'
% requires only a scalar for the radius.
% The frequency shift matrix and coefficient vector are given as usual.

ppwr = pwr(pp.*aa-pp);
spwr = pwr(ps.*aa)/pwr(ps);
% The various powers are computed. The power of the stopband
% process through the filter aa is to be constrained to be
% small. The passband is treated differently; in that case, we
% minimize the difference in power between the unfiltered and
% filtered passband process.

% As an alternative, set up pass- and stopbands using gridded
% formulation
p3.dim = 2;
p3.center = [0 0];
p3.radius = .255;
p4 = p3;
p4.radius = .245;
annulusReg = setdiff(Region('sphere', p3), Region('sphere', p4));
fpb = points(annulusReg, sqlat*.010);
p5.dim = 2;
p5.points = [-.5 -.5; -.5 .5; .5 -.5; .5 .5];
p3.radius = .32;
p4.radius = .18;
sbReg = Region('convpoly', p5) * ~Region('sphere', p3) + ...
	Region('sphere', p4);
fsb = points(sbReg, sqlat*.015);
%Hpb = fourier(aa, fpb);
%Hsb = fourier(aa, fsb);
%pp = NDProcess('Impulse', [], fpb, ones(size(fpb,1),1));
%ps = NDProcess('Impulse', [], fsb, ones(size(fsb,1),1));
%ppwr = pwr(pp.*aa-pp);
%spwr = pwr(ps.*aa)/pwr(ps);

%==============================
% Set up constraints and solve
%==============================
delta = 100*optVar(ov);
constr = {ppwr < delta.^2, spwr < 1e-3};
%constr = {abs(1-Hpb).^2 < optVector(1), ...
%	  sum(abs(Hsb).^2) < delta.^2} ;
	  
%soln = minimize(delta, constr, ov, 'sedumi');
soln = minimize(delta, constr, ov, 'sdpt3');
himp = full(get_h(optimal(aa,soln)));

flt = i2m(get_locs(aa),himp);
% i2m converts the resulting filter himp, which is on a square grid
% indexed by a matrix of locations, to the matrix form required by
% fft2 and surf.
Tsize = 75; Tvec = linspace(-.5, .5, Tsize);
FLT = fftshift(fft2(flt,Tsize,Tsize));

surf(Tvec, Tvec, 20*log10(abs(FLT)));
xlabel('x'), ylabel('y')
