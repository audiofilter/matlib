function y = down4(x,ang)
% function y = down4(x)
% $Id: down4.m,v 1.1 1997/10/13 16:13:00 kirke Exp $
% down convert signal by 1/4 of sampling frequency
y = zeros(1,size(x,2)) + i*zeros(1,size(x,2));
for j=1:size(x,2)
  ang = ang + pi/2;
  if (ang > 2*pi) 
    ang = ang - 2*pi;
  end
  y(j) = x(j)*exp(-i*ang);
end
