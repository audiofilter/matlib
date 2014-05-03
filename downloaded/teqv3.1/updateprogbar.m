%UPDATEPROGBAR Update progress bar by increasing it one step.
% UPDATEPROGBAR(H,S,M) updates the progress bar with handle H
% by an amount of 1/M. So that in M steps the progress bar is
% full (100\%).

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
% Version:      %W%   %G%
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function updateprogbar(statusHndl,status,maxstatus)

% make the axes with the handle statusHndl active
axes(statusHndl);
% fill the bar one additional step 
   xpatch=[0 status status 0]/(maxstatus+1);
   ypatch=[0 0 1 1];
   patch(xpatch,ypatch,'r','EdgeColor','none','EraseMode','none');
   view(2);
% save the current status of the bar 
   set(statusHndl,'UserData',status);
   drawnow;