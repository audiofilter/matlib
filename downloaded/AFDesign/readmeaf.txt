AFDesign Toolbox -- ADVANCED FILTER DESIGN in MATLAB

AFDesign version 2.1, Copyright (c) 1999-2000 D. Tosic and M. Lutovac
   lutovac@iritel.bg.ac.yu    http://galeb.etf.bg.ac.yu/~lutovac/
   tosic@galeb.etf.bg.ac.yu   http://www.rcub.bg.ac.yu/~tosicde/
This is free software.
   
AFDesign is a MATLAB toolbox for generating a comprehensive set of
elliptic digital and analog filter design alternatives.
AFDesign is easy to use, intuitive, and it is based on standard 
built-in MATLAB commands.

INSTALLATION: AFDesign is distributed in compressed form as the file
afdesign.zip. Decompress afdesign.zip with path names. You obtain

AFD\AFDesign

AFDesign directory has to be appended to the MATLAB path. 

RUNNING: Run MATLAB and execute the following main scripts:

(a) afdesign.m  --  Advanced Filter Design
(b) aadesign.m  --  Analog Advanced Filter Design
(c) dadesign.m  --  Digital Advanced Filter Design
(d) demoaafd.m  --  AFDesign analog design demo
(e) demodafd.m  --  AFDesign digital design demo

DESIGN: After invoking AFDesign.m the the main window appears,
and you can choose a digital or analog filter design.
Click a button and start a filter design by choosing among
many design alternatives D1, D2, D3a, D3b, D4a, D4b, D5 and 2D5.
For example, if you want to design a classical elliptic filter,
click the D1 button, wait a second, and the summary of 
design parameters show up in the MATLAB command window.
Click the buttons labeled "n+" or "n-" to adjust the filter order.

VISUALIZATION: Plot attenuation versus frequency by using the
PLOT, PASS, TRAN, STOP, or ZOOM buttons.
 
OPEN, VIEW, and EDIT buttons are used to read-in a filter specification
from a file, view the current filter specification, and change 
the current filter specification.

DEMO button loads a demo spec and the D1 design parameters summary.

SEE ALSO:  
Miroslav D. Lutovac, Dejan V. Tosic, Brian L. Evans
        Filter Design for Signal Processing
           Using MATLAB and Mathematica
        Prentice Hall - ISBN 0-201-36130-2 
          http://www.prenhall.com/lutovac
 
To get updates of AFDesign join our AFD e-mail list; contact us at
 lutovac@galeb.etf.bg.ac.yu   or   tosic@telekom.etf.bg.ac.yu
We welcome your feedback -- your suggestions are appreciated.

COPYRIGHT NOTICE: 
 This file is part of AFDesign toolbox for MATLAB.
 Refer to the file LICENSE.TXT for full details.

 AFDesign version 2.1, Copyright (C) 1999-2000 D. Tosic and M. Lutovac
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; see LICENSE.TXT for details.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

%   $Revision: 1.21 $  $Date: 2000/10/03 13:45$
----------------- end-of-readmeaf.txt ------------------------
