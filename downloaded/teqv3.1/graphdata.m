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

%load tmp
%load nw17c4
%load nw03c4
%load nb32finalsims
%load nw17finalsims
load nb32_1
methods = [1 3 4 5 6 ];


if size(nb) == 1 & size(nw) == 1
   strx = ['channel'];
   maxx = max(channel) + 1;
   minx = min(channel) - 1;
   str1 = 'channels';
elseif size(nb) == 1
   strx = ['N_w'];
   maxx = max(nw) + 1;
   minx = min(nw) - 1;
   str1 = 'nw';
elseif size(nw) == 1
   strx = ['\nu'];
   maxx = max(nb) + 1;
   minx = min(nb) - 1;
   str1 = 'nb';
else
   error('Only one variable can be a vector');
end

strlook = ['k-db-or-+b->k-vr-^b-+'];
%strlook = ['r-hk-db-or-+b->k-vr-^b-+'];
%strlook = ['k:d k-.*k--xk-^ k-+ k-v k-^ k-+ '];
%strlook = ['-- -. -  :  -- -. -  :  '];

for iter = 1:size(RDMTfinalresults,5)
   meth = 0;
   for loopNum = channels 
      figure
      axis off;
      axhndl = axes;
      set(axhndl,'fontsize',16);
      axis on
      hold on
      
      for method = methods
         meth = meth + 1;
         rdmt = squeeze(RDMTfinalresults(nw,nb,loopNum,method,iter));    
         str2 = ['plot(',str1,',rdmt/1e6,strlook(meth*3-2:meth*3),''linewidth'',2)']; eval(str2);
      end
      
      str3 = ['plot(',str1,',RDMTmfbresults(nw,nb,loopNum,method)/1e6,''-k.'',''linewidth'',2);'];eval(str3);
      xy = axis;
      xy(1) = minx;
      xy(2) = maxx;
      xy(3) = 1;
      xy(4) = 1.05*max(RDMTmfbresults(nw,nb,loopNum,method)/1e6);
      axis(xy);
      xlabel(strx);
      ylabel('Bit Rate (Mbps)')
      box on
      hold off
      str4 = ['MMSE   ';'UTC    ';'MSSNR  ';'MGSNR  ';'min-ISI';'MBR    ';'MFB    '];
      %str4 = ['MMSE   ';'MSSNR  ';'MGSNR  ';'min-ISI';'MBR    ';'MFB    '];
      str5 = str4([methods max(methods)+1],:);
      leghndl= legend(axhndl,str5);
      set(leghndl,'fontsize',10)
      set(leghndl,'position',[0.56 0.33 0.3 0.3])
   end
   
end

