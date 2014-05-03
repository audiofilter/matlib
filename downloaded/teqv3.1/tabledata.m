% Copyright (c) 1999-2003 The University of Texas
% All Rights Reserved.
%  
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%  
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%  
% The GNU Public License is available in the file LICENSE, or you
% can write to the Free Software Foundation, Inc., 59 Temple Place -
% Suite 330, Boston, MA 02111-1307, USA, or you can find it on the
% World Wide Web at http://www.fsf.org.
%  
% Programmers:	Guner Arslan
% Version:        %W% %G%
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at ming@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

close all

%load tablesfinalsims2
load table
rep = size(RDMTfinalresults,5);
nw = 17; %5 6 9
nb = 32;
reps = 1;
rep = length(reps);
fprintf('MMSE    MSSNR   MGSNR  min-ISI  MBR  MFB\n');
for loopNum = channels 
   meth = 0;
   for method = methods
      meth = meth + 1;
      rdmt = 0;
      maxr = 0;
      for iter = reps            
         rdmt = rdmt + squeeze(RDMTfinalresults(nw,nb,loopNum,method,iter));    
         maxr = maxr + RDMTmfbresults(nw,nb,loopNum,method,iter);
      end
      rdmt = rdmt/rep/1e6;
      maxr = maxr/rep/1e6;
      fprintf('%2.4f ',rdmt/maxr);
        
   end
   fprintf('%2.6f ',maxr);
   fprintf('\n');
end


