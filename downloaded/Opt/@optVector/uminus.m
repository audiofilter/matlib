function [mopt]=uminus(opt)
% OPTVECTOR/uminus unary minus
% [mopt]=uminus(opt)

mopt=opt;
mopt.h=-mopt.h;
