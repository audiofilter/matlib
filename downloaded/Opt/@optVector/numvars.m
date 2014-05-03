function nn = numvars(vv)
% OPTVECTOR/NUMVARS 
%  returns number of optimization variables
%  upon which optVector depends (i.e. number of rows of 
%  optVectors's kernel matrix)

nn = size(vv.h,1);