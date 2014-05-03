function goodspec = dfdcheck(speca,filnumb)

% dfdcheck.m  AFD check specification
%   
%          Advanced Digital Filter Design - AFDesign
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

goodspec = 1;

if any(speca-abs(speca))
 goodspec = 0;
 disp('AFD ERROR in filter specification: Negative data.')
 return
end

if     filnumb==1
 if speca(1)>=speca(2)
  goodspec = 0;
  disp('AFD ERROR in lowpass spec: Fpass >= Fstop.')
 end
 if speca(2)>=0.5
  goodspec = 0;
  disp('AFD ERROR in lowpass spec: Fstop >= 0.5.')
 end
 if speca(3)>=speca(4)
  goodspec = 0;
  disp('AFD ERROR in lowpass spec: Apass >= Astop.')
 end

elseif filnumb==2
 if speca(1)>=speca(2)
  goodspec = 0;
  disp('AFD ERROR in highpass spec: Fstop >= Fpass.')
 end
 if speca(2)>=0.5
  goodspec = 0;
  disp('AFD ERROR in highpass spec: Fpass >= 0.5.')
 end
 if speca(3)>=speca(4)
  goodspec = 0;
  disp('AFD ERROR in highpass spec: Apass >= Astop.')
 end

elseif filnumb==3
 if speca(1)>=speca(2)
  goodspec = 0;
  disp('AFD ERROR in bandpass spec: Fstop1 >= Fpass1.')
 end
 if speca(2)>=speca(3)
  goodspec = 0;
  disp('AFD ERROR in bandpass spec: Fpass1 >= Fpass2.')
 end
 if speca(3)>=speca(4)
  goodspec = 0;
  disp('AFD ERROR in bandpass spec: Fpass2 >= Fstop2.')
 end
 if speca(4)>=0.5
  goodspec = 0;
  disp('AFD ERROR in bandpass spec: Fstop2 >= 0.5.')
 end
 if speca(6)>=speca(5)
  goodspec = 0;
  disp('AFD ERROR in bandpass spec: Apass >= Astop1.')
 end
 if speca(6)>=speca(7)
  goodspec = 0;
  disp('AFD ERROR in bandpass spec: Apass >= Astop2.')
 end

elseif filnumb==4
 if speca(1)>=speca(2)
  goodspec = 0;
  disp('AFD ERROR in bandreject spec: Fpass1 >= Fstop1.')
 end
 if speca(2)>=speca(3)
  goodspec = 0;
  disp('AFD ERROR in bandreject spec: Fstop1 >= Fstop2.')
 end
 if speca(3)>=speca(4)
  goodspec = 0;
  disp('AFD ERROR in bandreject spec: Fstop2 >= Fpass2.')
 end
 if speca(4)>=0.5
  goodspec = 0;
  disp('AFD ERROR in bandreject spec: Fpass2 >= 0.5.')
 end
 if speca(5)>=speca(6)
  goodspec = 0;
  disp('AFD ERROR in bandreject spec: Apass1 >= Astop.')
 end
 if speca(7)>=speca(6)
  goodspec = 0;
  disp('AFD ERROR in bandreject spec: Apass2 >= Astop.')
 end

else
 error(['AFD ERROR: Unsupported filter type ', num2str(filnumb), '.'])

end
