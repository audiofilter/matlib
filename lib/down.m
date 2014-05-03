function y = down(x,ang,samples)
% function y = down4(x)
% $Id: down4.m,v 1.1 1997/10/13 16:13:00 kirke Exp $
% down convert signal by 1/4 of sampling frequency
phase = 0;
for j=1:samples
  phase = phase+ang;
  if (phase > 2*pi) 
    phase = phase - 2*pi;
  endif
  y(j) = x(j)*exp(-i*phase);
end
