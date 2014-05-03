%$Id: eyeimp.m,v 1.1 1997/09/25 17:09:24 kirke Exp $
% Program to plot eyediag given overall impulse response
function f = eyeimp(all,over)
% Number of symbols
np = 200;
% PN Generators for I & Q
fill = [1 zeros(1,13)];
r = pngen1(np,[1,6,8,14],fill);
yz = zeros(1,np*over);

for j=1:np;
	yz(over*j) = r(j);
	for jj=1:over-1
		yz(over*j+jj) = 0;
	end
end
% FIR
f = filter(all,1,yz);
eyediag(f,over);
