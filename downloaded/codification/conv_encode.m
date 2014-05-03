function c = conv_encode(G,x,k)

% Usage: c = conv_encode(G,x,k)
%
% This function takes as input an entire block of information bits 'x'
% (which are arranged in a row vector), the coeficients of the 
% generator matrix 'G', and the number of shift positions per cicle 'k'
% returns as output an entire convolutionally encoded codeword 'c'.
%
% Example:  conv_encode([1 1 0 ; 0 1 1 ],[ 1 1 1 0 1 0],1) =
%                      = [1 0 0 1 0 0 1 0 1 1 1 1 0 1 0 0]  
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
 
c = cyclic_encode(G,x);
fila = size(G,1);

if ( k > 1)
  i=[0:length(c)-1];
  i=i(rem(i,k*fila)>= (k-1)*fila);
  i=i+1;
  c=c(i);
end

end


