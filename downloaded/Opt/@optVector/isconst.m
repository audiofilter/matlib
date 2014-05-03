function cn=isconst(opt)
% optVector/isconst  true for constant 
% [cn]=isconst(opt)
% returns true if opt is constant (does not depend on optimization variable)
cn=(opt.xoff<0) & (size(opt.h,1)<=1) & (get_pool(opt) == 0);
