function c=get_c(soc,type)
% SOCConstr/get_c  c extraction function
% c=get_c(soc,type)
% if type='cell' (default) then c is returned as a cell array
% if type='matrix' then c is returned concatenated as a single matrix
% c=get_c(soc,n)
% returns only the nth c

global OPT_DATA;
if nargin==1
  type='cell';
end;
ic=[1 1+cumsum(soc.Mrank(1:end-1)+1)];
if isa(type,'double')
	c=get_h(soc.SOCvect(ic(type)),'linear');
else
	M=length(soc.Mrank);
	switch(type)
	case 'cell'
		c=cell(1,M);
		for m=1:M
			c{m}=get_h(soc.SOCvect(ic(m)),'linear');
		end;
	case 'matrix'
		c=get_h(soc.SOCvect(ic),'linear');
	otherwise
		error('illegal argument');
	end;
end;
