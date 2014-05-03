function out = wavelet_step (in,h,g)

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

fh=fliplr(h);
fg=fliplr(g);
Nh=length(fh); 
Ng=length(fg); 
Nin=size(in,2);

a=[in zeros(size(in,1),2*Nh)]; a=a'; a=a(:)'; 
a=conv(a,fh); a=a([1:(Nin+2*Nh)*size(in,1)]);
a=reshape(a,Nin+2*Nh,size(in,1))';

b1=a(:,[Nh:Nin+Nh-1])+[zeros(size(in,1),Nin-Nh+1) a(:,[1:Nh-1])];

a=[in zeros(size(in,1),2*Ng)]; a=a'; a=a(:)'; 
a=conv(a,fg); a=a([1:(Nin+2*Ng)*size(in,1)]);
a=reshape(a,Nin+2*Ng,size(in,1))';

b2=a(:,[Ng:Nin+Ng-1])+[zeros(size(in,1),Nin-Ng+1) a(:,[1:Ng-1])];

out=[b1(:,[1:2:Nin]) b2(:,[1:2:Nin])];
end
