function l=plotlfir(fir,points)
% Octave OK
% Plot frequency response using semilogx
%
if nargin < 2;
  points = 100;
end;  
[h,w]=freqz(fir,1,points);
l=20*log10(abs(h));
x=1:points;
semilogx(x,l);
axis([1 points -50 0]);
grid;
