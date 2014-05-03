function cA=get_cA(soc)
% SOCConstr/get_cA  [c, A.'] extraction function
% cA=get_cA(soc)

cA=get_h(soc.SOCvect,'linear');
