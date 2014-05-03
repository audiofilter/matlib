function d=get_d(soc,n)
% SOCConstr/get_d  d extraction function
% d=get_d(soc)
%   return all d in a vector
% d=get_d(soc,n)
%   return only the nth d


id=[1 1+cumsum(soc.Mrank(1:end-1)+1)];
if nargin==1
	d=full(get_h(soc.SOCvect(id),'const'));
else
	d=full(get_h(soc.SOCvect(id(n)),'const'));
end;
