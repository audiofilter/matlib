function [xo,yo] = stair(x,y)

%STAIR	Stairstep graph (bar graph without internal lines).
%	Stairstep plots are useful for drawing time history plots of
%	digital sampled-data systems.
%	STAIR(Y) draws a stairstep graph of the elements of vector Y.
%	STAIR(X,Y) draws a stairstep graph of the elements in vector Y at
%	the locations specified in X.  The X-values must be in
%	ascending order and evenly spaced.
%	[XX,YY] = STAIR(X,Y) does not draw a graph, but returns vectors
%	X and Y such that PLOT(XX,YY) is the stairstep graph.
%	See also BAR, STAIRS and HIST.

%	L. Shure, 12-22-88.
%	Copyright (c) 1988 by the MathWorks, Inc.
%
%	Modified for our display, Mehmet Zeytinoglu, 1991.
%
               
n = length(x);
if nargin == 1
	y = x;
	x = 1:n;
end
delta = (max(x) - min(x)) / (n-1);
nn = 2*n;
yy = zeros(nn+2,1);
xx = yy;
%t = x(:)';
t = x(:)' - delta;
xx(1:2:nn) = t;
xx(2:2:nn) = t;
xx(nn+1:nn+2) = t(n) + [delta;delta];
yy(2:2:nn) = y;
yy(3:2:nn+1) = y;
if nargout == 0
	plot(xx,yy)
else
	xo = xx;
	yo = yy;
end
