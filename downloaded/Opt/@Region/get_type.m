function type = get_type(reg)
% REGION/GET_TYPE Region type extraction
%
% type = get_type(reg) returns the type of Region reg.

global OPT_DATA;

type = OPT_DATA.regions(reg.ind).type;
