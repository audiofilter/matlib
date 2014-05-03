function y = interleave(x, n, m)

% Usage: y = interleave(x, n, m)
%
% Implements a (n x m) interleaver. The input data 'x' is written 
% into a (n x m) matrix in a column-by-column fashion, and read out 
% in a row-by-row fashion
%
% Example: interleave([ 1 2 3 4 5 6 7 8], 4, 2) = [1 5 2 6 3 7 4 8]
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

y=[];

for k=1:length(x)/(n*m)

a=x([(k-1)*n*m+1:k*n*m]);
b=reshape(a,n,m); b=b';
c=b(:)';

y = [y c];

end
