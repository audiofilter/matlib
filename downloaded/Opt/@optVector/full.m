function [fopt]=full(opt)
% OPTVECTOR/FULL Convert sparse vector to full vector.
% [fopt]=full(opt)

fopt=opt;
fopt.h=full(fopt.h);
