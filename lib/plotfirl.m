function l=plotfirl(fir,points)
% Octave OK
% $Id: plotfir.m,v 1.2 1997/10/13 16:14:40 kirke Exp kirke $
% Plot frequency response
%
if nargin < 2;
  points = 200;
end;  
aa = [1 zeros(1,points-1)]';
[h,w]=freqz(fir,aa,points);
l=20*log10(abs(h));
semilogx(w/pi,l);
%axis([0.001 1 -100 10]);
grid;
