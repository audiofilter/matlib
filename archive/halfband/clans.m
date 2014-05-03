function NTF=clans(order,OSR,Q,rmax,opt)
%NTF = clans(order=4,R=64,Q=5,rmax=0.95,opt=0)	Optimal NTF design
%for a multi-bit modulator.
%CLANS = "closed-loop analysis of noise-shapers,"
%and was originally developed by J.G. Kenney and R. Carley.

% Handle the input arguments
parameters = {'order';'OSR';'Q';'rmax';'opt'};
defaults = [ 4 64 5 0.95 0 ];
for i=1:length(defaults)
    parameter = char(parameters(i));
    if i>nargin | ( eval(['isnumeric(' parameter ') '])  &  ...
     eval(['any(isnan(' parameter ')) | isempty(' parameter ') ']) )
        eval([parameter '=defaults(i);'])
    end
end

% Create the initial guess
NTF = synthesizeNTF(order,OSR,opt,1+Q,0);
Hz = NTF.zeros;
x = zeros(1,order);
odd = rem(order,2);
if odd
    z = NTF.poles(1)/rmax;
    if any(abs(z))>1 %project poles outside rmax onto the circle
	z = z./abs(z);
    end
    s = (z-1)./(z+1);
    x(1)= sqrt(-s);
end
for i=odd+1:2:order
    z = NTF.poles(i:i+1)/rmax;
    if any(abs(z))>1 %project poles outside rmax onto the circle
	z = z./abs(z);
    end
    s = (z-1)./(z+1);
    coeffs=poly(s);
    wn = sqrt(coeffs(3));
    zeta = coeffs(2)/(2*wn);
    x(i) = sqrt(zeta);
    x(i+1) = sqrt(wn);
end

% Run the optimizer
x=constr('dsclansObj',x,[],[],[],[],order,OSR,Q,rmax,Hz);

NTF = dsclansNTF(x,order,rmax,Hz);
