function I = subsindex(A)
% OPTSPACE/SUBSINDEX  Subscript index.

I = A.poolnum -1;
% the '- 1' is because for some reason subsindex in Matlab requires
% a zero-based index.
