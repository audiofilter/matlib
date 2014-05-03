function out = wt(in,code,stages)
  
% Usage: out = wt(in,code,stages)
%
% Example for Daubechies D4
% in= [1 2 3 4 5 6 7 8]; code='daub4'; stages=1;
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
  [h g hh gg desp]=wcoeff(code);
   
% EXAMPLE FOR DAUBECHES D4
% h= [0.482963, 0.836516, 0.224144, -0.129410];
% g= [-0.129410, -0.224144, 0.836516, -0.482963];

  hsize=N; % hsize va a reducirse a la mitad en cada etapa */
  out=in;
  for k=1:stages            
    out(:,[1:hsize])=wavelet_step(out(:,[1:hsize]),h,g);
    hsize=hsize/2;
  end
  
end

