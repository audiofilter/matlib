%SETPROGBAR Setup a progress bar.
% [Hf, Hs] = SETPROGBAR(S) sets up a progress bar with the
% title given in the string S.
%
% Hf is the handle to the figure and Hs is the handle to
% the status of the progress bar.

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
% Version:      @(#)setprogbar.m	1.2   08/15/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [figHndl, statusHndl] = setprogbar(namestring)

% open figure
figHndl = figure('Name',namestring,...
		'IntegerHandle','off',...
      'NumberTitle','off',...
      'MenuBar','none',...
      'position',[330 500 400 40]);

% setup axes 
   statusHndl=axes( ...
        'Units','normalized', ...
        'Position',[0.05 0.1 0.9 0.6], ...
        'Box','on', ...
        'UserData',0, ...
        'Visible','on', ...
        'XTick',[],'YTick',[], ...
        'XLim',[0 1],'YLim',[0 1]);
     
