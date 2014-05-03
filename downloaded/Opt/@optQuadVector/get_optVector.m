function vect=get_optVector(qvect)
% optQuadVector/get_optVector optVector extraction function
% vect=get_optVector(qvect)

global OPT_DATA;

if OPT_DATA.casebug
  vect=qvect.optvector;
else
  vect=qvect.optVector;
end;