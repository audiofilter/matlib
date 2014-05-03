function [saff]=sum(aff)
% optVector/sum  affine sum
% [saff]=sum(aff)
% a is type optVector
saff=optVector;
saff=set_pool(saff,get_pool(aff));
saff=set_xoff(saff,get_xoff(aff));
saff=set_h(saff,sum(get_h(aff),2));
