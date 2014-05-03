function b=get_b(soc,type)
% SOCConstr/get_b  b extraction function
% b=get_b(soc,type)
% if type='cell' (default) then b is returned as a cell array
% if type='matrix' then b is returned concatenated as a single vector
% b=get_b(soc,n)
% returns only the nth b

if nargin==1
  type='cell';
end;
ib=[2 2+cumsum(soc.Mrank+1)];
if isa(type,'double')
	b=get_h(soc.SOCvect(ib(type):ib(type+1)-2),'const').';
else
	M=length(soc.Mrank);
	switch(type)
	case 'cell'
		b=cell(1,M);
		for m=1:M
			b{m}=get_h(soc.SOCvect(ib(m):ib(m+1)-2),'const').';
		end;
	case 'matrix'
		b=get_h(soc.SOCvect(setdiff(1:ib(end)-2,ib(1:end-1)-1)),'const').';
	otherwise
		error('illegal argument');
	end;
end;
