function sss = scicimp(over,stages)
% Sharpened CIC (Cascaded integrated comb) filter using
% Kaiser Method (3-2*x)*x*x
% $Id: scicimp.m,v 1.1 1997/10/13 16:13:12 kirke Exp $
imp = [1];
for ii=2:stages+1
	imp = conv(imp,ones(1,over))/over;
end
cic2 = conv(imp,imp);
cc = -2*imp;
cc(over) = cc(over) + 3;
sss = conv(cic2,cc);



