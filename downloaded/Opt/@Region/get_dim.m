function dim = get_dim(reg)
% REGION/GET_DIM Region dimension
%
% dim = get_dim(reg) returns the dimension of Region reg.

global OPT_DATA;

dim = OPT_DATA.regions(reg.ind).param.dim;
