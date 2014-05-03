function initConvpoly(ind);
% calculations for convpoly region

global OPT_DATA;

param = OPT_DATA.regions(ind).param;

% take the convex hull to eliminate extra points
K = convhulln(param.points);

% convhulln returns the facets of the convex hull as dim-tuples of
% points, which are indices into param.points. We would like to
% store the unique indices in the global OPT_DATA. This will
% provide a list of the polytope's vertices.
hullv = unique(K(:));

% copy into global
OPT_DATA.regions(ind).param.hullv = hullv;
