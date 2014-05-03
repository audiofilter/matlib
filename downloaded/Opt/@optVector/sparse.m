function [fopt]=sparse(opt)
% OPTVECTOR/SPARSE Convert full vector to sparse vector.
% [fopt]=sparse(opt)

fopt=opt;
fopt.h=sparse(fopt.h);
