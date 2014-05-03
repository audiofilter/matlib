function out = wavelet_step(in,h,g)

% Usage: out = wavelet_step(in,h,g)
%
% Copyright (C) 2000-2001 F. Arguello (http://web.usc.es/~elusive)
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2, or (at your option)
% any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

  N=size(in,2);
  M1=size(h,2);M2=size(g,2); 
  for i=0:N/2-1
     even=0.0; odd=0.0;
     for j=0:M1-1 even=even+h(j+1)*in(:,1+rem(2*i+j,N)); end    % low pass 
     for j=0:M2-1 odd = odd+g(j+1)*in(:,1+rem(2*i+j,N)); end    % high 
     out(:,1+i)=even; out(:,1+N/2+i)=odd;
  end

end
