% bafdopen.m  BUTTON: OPEN
%   
%          Advanced Analog Filter Design - AFDesign
%   
%   Authors: Dejan V. Tosic, Miroslav D. Lutovac, 1999/02/21
%   tosic@galeb.etf.bg.ac.yu   http://www.rcub.bg.ac.yu/~tosicde/
%   lutovac@iritel.bg.ac.yu    http://galeb.etf.bg.ac.yu/~lutovac/
%   Copyright (c) 1999-2000 by Tosic & Lutovac
%   $Revision: 1.21 $  $Date: 2000/10/03 13:45$
%   
%   References:
%   Miroslav D. Lutovac, Dejan V. Tosic, Brian L. Evans
%        Filter Design for Signal Processing
%           Using MATLAB and Mathematica
%        Prentice Hall - ISBN 0-201-36130-2 
%         http://www.prenhall.com/lutovac
%
                         
% This file is part of AFDesign toolbox for MATLAB.
% Refer to the file LICENSE.TXT for full details.
%                        
% AFDesign version 2.1, Copyright (c) 1999-2000 D. Tosic and M. Lutovac
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; see LICENSE.TXT for details.
%                       
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%                       
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc.,  59 Temple Place,  Suite 330,  Boston,
% MA  02111-1307  USA,  http://www.fsf.org/

[speck1,speca1,filnumb1,filtype1,nmin1,nmax1,nincmin1,nincmax1]=afdopen(moreaxis);

if ~isempty(speca1);
  speck=speck1;
  speca=speca1;
  filnumb=filnumb1;
  filtype=filtype1;
  nmin=nmin1;
  nmax=nmax1;
  nincmin=nincmin1;
  nincmax=nincmax1;
  ninc=0;
  b16n = uicontrol('Style', 'text' ...
     , 'String', ['n=',num2str(nmin+ninc)] ...
     , 'Units', 'normalized', 'BackgroundColor',[0.9 0.9 0.9] ...
     , 'Position', [0.0 0.95 0.05 0.04]);
  if fig2;
    set(eb8,'String',num2str(ninc));
    set(et9,'String',[num2str(nincmin),'<=ninc<=',num2str(nincmax)]);
  end;
end;
