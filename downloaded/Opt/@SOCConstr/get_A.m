function A=get_A(soc,type)
% SOCConstr/get_A  A extraction function
% A=get_A(soc,type)
% if type='cell' (default) then A is returned as a cell array
% if type='matrix' then A is returned concatenated as a single matrix
% A=get_A(soc,n)
% returns only the nth A

global OPT_DATA;
if nargin==1
	type='cell';
end;
iA=[2 2+cumsum(soc.Mrank+1)];
if isa(type,'double')
	A=get_h(soc.SOCvect(iA(type):iA(type+1)-2),'linear').';
else
	M=length(soc.Mrank);
	switch(type)
	case 'cell'
		A=cell(1,M);
		for m=1:M
			A{m}=get_h(soc.SOCvect(iA(m):iA(m+1)-2),'linear').';
		end;
	case 'matrix'
		A=get_h(soc.SOCvect(setdiff(1:iA(end)-2,iA(1:end-1)-1)),'linear').';
	otherwise
		error('illegal argument');
	end;
end;
