function [y]= BoxTime(x,freqs,scale)
%   CTPROCESS/private/BOXTIME
%       finds inverse fourier transform of boxcars of width 'scale'
%       located at freqs
%       I.F.T. is evaluated at times given in x.

sincres = zeros(size(x));

ii = find(x==0);
sincres(ii) = scale;
ii = find(x~=0);
sincres(ii) = sin(pi*x(ii)*scale)./(pi*x(ii));

y = sincres .* exp(j*2*pi*freqs(:)*x);
