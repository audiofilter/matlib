function c = bin_exor(a,b)

% Usage: c = bin_exor(a,b)
%
% A, B, and C are decimal number
% C is the EXOR (bit a bit) of A and B 
% Example:  bin_exor(7,8)=15
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

la=floor(log2(a))+1; lb=floor(log2(b))+1;
if(la>lb)lc=la; else lc=lb; end
if(lc<1) lc=1 ; end
aa([1:lc])=0; bb([1:lc])=0;

xa=a;
for i=1:la
  aa(i)=rem(xa,2);
  xa=floor(xa/2);
end

xb=b;
for i=1:lb
  bb(i)=rem(xb,2);
  xb=floor(xb/2);
end

cc([1:lc])=xor(aa([1:lc]),bb([1:lc]));

c=0; pot=1;
for i=1:lc
  c=c+cc(i)*pot;
  pot=pot*2;
end

end
