function pure=ispure(quad)
% OPTQUAD/ISPURE  true if there are no constant or linear terms 
% [pure]=ispure(quad)
% returns true if quad is purely quadratic
pure=(quad.xoffr>=0 & quad.xoffr>=0);
