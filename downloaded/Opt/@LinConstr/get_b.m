function b=get_b(lconstr)
% LinConstr/get_b   b extraction function
% b=get_b(lconstr)

b=-get_h(lconstr.vect,'const').';
