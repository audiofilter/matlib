function r = crc(g,x)

% Usage: r = crc(g,x)
%
% This function takes as input an entire block of information bits 'x'
% (which are arranged in a row vector), and the coeficients of the 
% generator polynomials 'g', and returns as output an entire 
% convolutionally encoded codeword 'r'.
%  
% Example:  crc([1 0 1 0],[1 1 1 0 1 1 1 0]) = [1 1 1 0 1 1 1 0 0 0 0]
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

if(size(g,2)==1) g=g'; end
if(size(x,2)==1) x=x'; end
a=cyclic_matrix(g,size(x,2));
b=syst_matrix(a);
r=mult_mod2(x,b);

end
