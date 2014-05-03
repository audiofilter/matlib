function out = wavelet_inv_step(in,hh,gg,desp)

% Usage: out = wavelet_inv_step(in,hh,gg,desp)
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
  M1=size(gg,2);M2=size(hh,2); 
  for i=0:N/2-1
     even=0.0; odd=0.0;
     for j=0:M2/2-1 even= even+hh(2*j+2)*in(:,1+rem(i+j,N/2)); end     % low
     for j=0:M1/2-1 even= even+gg(2*j+2)*in(:,1+rem(i+j,N/2)+N/2); end 
     for j=0:M2/2-1 odd = odd +hh(2*j+1)*in(:,1+rem(i+j,N/2)); end 
     for j=0:M1/2-1 odd = odd +gg(2*j+1)*in(:,1+rem(i+j,N/2)+N/2); end % high
     out(:,1+rem(2*i+M2+desp-2,N))=even; 
     out(:,1+rem(2*i+M2+desp-1,N))=odd;
  end

end
