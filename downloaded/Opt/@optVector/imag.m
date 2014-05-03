function [iopt]=imag(opt)
% OPTVECTOR/IMAG take imaginary part
% [iopt]=imag(opt)

iopt=opt;
iopt.h=imag(iopt.h);
