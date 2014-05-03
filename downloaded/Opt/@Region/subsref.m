function sgs=subsref(reg,S)
% REGION/SUBSREF subscript operator

global OPT_DATA;

if length(S) ~= 1
    error('illegal arguments to subsref()')
end;
sgs=[];
switch S.type
case '.'
    % note-- allows access to hidden members; only here for debugging
    switch S.subs
    case 'param'
        sgs = OPT_DATA.regions(reg.ind).param;
    otherwise
        ;
    end;
otherwise
    error('illegal arguments to subsref()');
end;
