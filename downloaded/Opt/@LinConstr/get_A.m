function A=get_A(lconstr)
% LinConstr/get_A   A extraction function
% A=get_A(lconstr)

A=get_h(lconstr.vect,'linear').';
