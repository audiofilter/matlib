function out = wavelet_inv_step (in,hh,gg,desp)

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

fh=fliplr(hh);
fg=fliplr(gg);
Nh=length(fh); 
Ng=length(fg); 
Nin=size(in,2);

a=[in(:,[1:Nin/2]) zeros(size(in,1),Nh)]; a=a'; a=a(:)'; 
a=conv(a,fh([2:2:Nh])); a=a([1:(Nin/2+Nh)*size(in,1)]);
a=reshape(a,Nin/2+Nh,size(in,1))';

b1=a(:,[Nh/2:Nin/2+Nh/2-1])+[zeros(size(in,1),Nin/2-Nh/2+1) a(:,[1:Nh/2-1])];

a=[in(:,[1+Nin/2:Nin]) zeros(size(in,1),Ng)]; a=a'; a=a(:)'; 
a=conv(a,fg([2:2:Ng])); a=a([1:(Nin/2+Ng)*size(in,1)]);
a=reshape(a,Nin/2+Ng,size(in,1))';

b1=b1+a(:,[Ng/2:Nin/2+Ng/2-1])+[zeros(size(in,1),Nin/2-Ng/2+1) a(:,[1:Ng/2-1])];

a=[in(:,[1:Nin/2]) zeros(size(in,1),Nh)]; a=a'; a=a(:)'; 
a=conv(a,fh([1:2:Nh])); a=a([1:(Nin/2+Nh)*size(in,1)]);
a=reshape(a,Nin/2+Nh,size(in,1))';

b2=a(:,[Nh/2:Nin/2+Nh/2-1])+[zeros(size(in,1),Nin/2-Nh/2+1) a(:,[1:Nh/2-1])];

a=[in(:,[1+Nin/2:Nin]) zeros(size(in,1),Ng)]; a=a'; a=a(:)'; 
a=conv(a,fg([1:2:Ng])); a=a([1:(Nin/2+Ng)*size(in,1)]);
a=reshape(a,Nin/2+Ng,size(in,1))';

b2=b2+a(:,[Ng/2:Nin/2+Ng/2-1])+[zeros(size(in,1),Nin/2-Ng/2+1) a(:,[1:Ng/2-1])];

% out=[b2 ; b1];
% out=out(:)';
out(:,[1:2:Nin])=b2;
out(:,[2:2:Nin])=b1;
out=shift(out',Nh+desp-2)';
end

