function [HBF,pbr,sbr] = frespHBF(f1,f2,f,phi,fp,msg)
%[HBF pbr sbr] = frespHBF(f1,f2,f,phi,fp,msg)	
%Compute the frequency response, the passband ripple and the stopband ripple 
% of a Saramaki HBF. If msg is non-null 

% Handle the input arguments
parameters = ['f1 ';'f2 ';'f  ';'phi';'fp ';'msg'];
defaults = [ NaN NaN NaN 1 0 NaN ];
for i=1:length(defaults)
    if i>nargin
	eval([parameters(i,:) '=defaults(i);'])  
    elseif eval(['any(isnan(' parameters(i,:) ')) | isempty(' parameters(i,:) ')'])
	eval([parameters(i,:) '=defaults(i);'])  
    end
end
if isnan(f)
    f = linspace(0,.5,1024);
end
if isnan(msg)
    msg = '';
end

Npts = length(f);
w = 2*pi*f;
z = exp(j*w);
cos_w = real(z);

n2 = length(f2);
F2 = zeros(size(w));
for i = 1:n2
    F2 = F2 + f2(i)*cos(w*(2*i-1));
end
F2 = F2*2;
HBF = evalF1(f1,F2); 

if nargout > 1 | isempty(msg)
    passband = 1:floor(2*fp*(Npts-1) +1);
    stopband = Npts + 1 - passband;
    pbr = max( abs( abs(HBF(passband)) -1 ) );
    sbr = max( abs(HBF(stopband)) );
end

if ~isempty(msg)
    clf
    subplot(211)
    F1 = evalF0(f1,z,phi); 
    plot(f,abs(F1),'--', f,phi*abs(F2),':', f, abs(HBF),'-');
%    phi
    legend('F1', 'F2', 'HBF')
    title(msg);
    hold on; grid on
    axis([0 0.5 0 1.1])

    subplot(212)
    plot(f,dbv(HBF))
    axis([0 0.5 -200 10])
    grid on

    msg = sprintf( ' pbr=%.1e', pbr );
    text(0.0, -10, msg, 'VerticalAlignment', 'top');
    msg = sprintf( 'sbr=%.0fdB ', dbv(sbr) );
    text(0.5, dbv(sbr), msg, 'HorizontalAlignment', 'right', ...
      'VerticalAlignment', 'bottom');
    figure(gcf);
end
