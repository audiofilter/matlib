function [copt]=conj(opt)
% OPTVECTOR/CONJ take conjugate
% [copt]=conj(opt)

copt=opt;
copt.h=conj(copt.h);
