function Abcd=get_Abcd(soc,how)
% SOCConstr/get_Abcd  A,b,c,d extraction function
% Abcd=get_Abcd(soc,how)

if nargin<2
	how='loqo';
end;

switch(class(how))
case 'char'
	switch(how)
	case 'loqo'
		cumrank=[0 cumsum(soc.Mrank+1)];
		Abcd={};
		for k=1:length(soc.Mrank)
			Abcd{k}=flipud(get_h(soc.SOCvect((cumrank(k)+1):cumrank(k+1)),'full').');
		end;
	end;
case 'double'
	cumrank=[0 cumsum(soc.Mrank+1)];
	Abcd=get_h(soc.SOCvect((cumrank(how)+1):cumrank(how+1)),'full');
end;	
