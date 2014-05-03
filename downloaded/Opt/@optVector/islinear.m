function lin=islinear(opt)
% OPTVECTOR/ISLINEAR  true if there are no constant terms 
% [lin]=islinear(opt)
% returns true if opt is linear in the opt vars (no constant terms)
lin=(opt.xoff>=0);
