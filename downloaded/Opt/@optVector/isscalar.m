function sc=isscalar(opt)
% optVector/isscalar  true for scalar 
% [sc]=isscalar(opt)
% returns true if opt is scalar (i.e. is a length-1 optVector)
sc=(size(opt.h,2)==1);
