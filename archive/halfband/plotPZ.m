function plotPZ(H,list)
%function plotPZ(H,list=0)
%Plot the poles and zeros of a transfer function.
%If list is non-zero, a list of the poles and zeros is superimposed on the plot.

if nargin < 2
    list = 0;
end

if strcmp(H.form,'coeff')
    z = roots(H.num);
    p = roots(H.den);
elseif strcmp(H.form,'zp')
    z = H.zeros;
    p = H.poles;
else
    fprintf(1,'form %s is unknown.\n', H.form);
    return
end

% Plot x and o for poles and zeros, respectively
if ~isempty(z)
	plot(real(p),imag(p),'x',real(z),imag(z),'o')
else
	plot(real(p),imag(p),'x')
end

% Draw unit circle, real axis and imag axis
hold_status = ishold;
hold on
plot(exp(j*2*pi*(0:0.01:1)));
axis('equal');
limits = axis;
plot([0 0],limits(3:4),'k:',limits(1:2),[0 0],'k:')

if list
% List the poles and zeros
    p = cplxpair(p);
    y = 0.05*(ceil(length(p)/2)+1);
    str = 'Poles:               ';
    text( 0, y, str, 'Hor', 'Right', 'Ver', 'Mid'); y = y - 0.1;
    for i = 1:2:length(p);
	if abs(imag(p(i))) < 1e-6
	    str = sprintf('%+.4f      ', real(p(i)) );
	else
	    str = sprintf( '%+.4f+/-j%.4f  ', real(p(i)), abs(imag(p(i))) );
	end
	text( 0, y, str, 'Hor', 'Right', 'Ver', 'Mid'); y = y - 0.1;
    end
    if ~isempty(z)
	z = z( ~isnan(z) & ~isinf(z) );
	z = cplxpair(z);
	y = 0.05*(ceil(length(z)/2)+1);
	str = '        Zeros:';
	text( 0, y, str, 'Hor', 'Left', 'Ver', 'Mid'); y = y - 0.1;
	for i = 1:2:length(z);
	    if abs(imag(z(i))) < 1e-6
		str = sprintf('%+.4f      ', real(z(i)) );
	    else
		str = sprintf( '  %+.4f+/-j%.4f', real(z(i)), abs(imag(z(i))) );
	    end
	    text( 0, y, str, 'Hor', 'Left', 'Ver', 'Mid');
	    y = y - 0.1;
	end
    end

end

if ~hold_status	% Return hold to previous status
    hold off
end
