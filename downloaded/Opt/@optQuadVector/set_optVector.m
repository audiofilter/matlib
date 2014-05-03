function oqv=set_optVector(qvect,aff)
% OPTQUADVECTOR/SET_OPTVECTOR optVector insertion function
% oqv=set_optVector(qvect,aff)

global OPT_DATA;

oqv = qvect;

if OPT_DATA.casebug
  oqv.optvector = aff;
else
  oqv.optVector = aff;
end;
