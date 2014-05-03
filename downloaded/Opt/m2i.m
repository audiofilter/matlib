function [tau, coeff] = m2i(mtx, xoff, yoff)
% M2I 
%   converts matrix filter to indexed form

[I,J] = find(mtx);  % nonzero entries
tau = [I+xoff J+yoff];
coeff = mtx(find(mtx));

[tau,sid] = sortrows(tau);
coeff = coeff(sid);