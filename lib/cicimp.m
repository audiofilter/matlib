function imp = cicimp(over,stages)
%$Id: cicimp.m,v 1.2 1997/10/13 15:52:12 kirke Exp $
% Program to calculate impulse response coefficients for CIC interpolation filter
imp = [1];
for ii=2:stages+1
	imp = conv(imp,ones(1,over));
end
