%   Advanced Digital and Analog Filter Design - AFDesign 
%   Version 2.1   23-Sep-2000
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
%  MAIN SCRIPT, BASIC OPERATIONS, DEMOS and OTHER
%   afdesign.m   -  Run AFDesign (main script)
%   dadesign.m   -  Run Digital Advanced Filter Design (main script)
%   aadesign.m   -  Run Analog Advanced Filter Design (main script)
%   demoaafd.m   -  Demo analog advanced filter design (main script)
%   demodafd.m   -  Demo digital advanced filter design (main script)
%                
%   readmead.txt -  Last minute changes and analog AFDesign introduction
%   readmedd.txt -  Last minute changes and digital AFDesign introduction
%   contents.m   -  This file
%                
%  BUTTONS       
%   bafd2d5.m    -  Button: analog AFD design 2 x D5
%   bafdd1.m     -  Button: analog AFD design D1
%   bafdd2.m     -  Button: analog AFD design D2
%   bafdd3a.m    -  Button: analog AFD design D3a
%   bafdd3b.m    -  Button: analog AFD design D3b
%   bafdd4a.m    -  Button: analog AFD design D4a
%   bafdd4b.m    -  Button: analog AFD design D4b
%   bafdd5.m     -  Button: analog AFD design D5
%   bafdinfo.m   -  Button: analog Show short help
%   bafdopen.m   -  Button: load schematic from a*.dat
%   bdfd2d5.m    -  Button: digital AFD design 2 x D5
%   bdfdd1.m     -  Button: digital AFD design D1
%   bdfdd2.m     -  Button: digital AFD design D2
%   bdfdd3a.m    -  Button: digital AFD design D3a
%   bdfdd3b.m    -  Button: digital AFD design D3b
%   bdfdd4a.m    -  Button: digital AFD design D4a
%   bdfdd4b.m    -  Button: digital AFD design D4b
%   bdfdd5.m     -  Button: digital AFD design D5
%   bdfdinfo.m   -  Button: digital Show short help
%   bdfdopen.m   -  Button: load schematic from d*.dat
%      
% FILTER SPECIFICATION
%   abandpas.dat   -  Analog bandpass filter specification
%   abandrej.dat   -  Analog bandreject filter specification
%   ahighpas.dat   -  Analog highpass filter specification
%   alowpass.dat   -  Analog lowpass filter specification
%   atmpspec.dat   -  Analog attenuation-limits filter specification
%   dbandpas.dat   -  Digital bandpass filter specification
%   dbandrej.dat   -  Digital bandreject filter specification
%   dhighpas.dat   -  Digital highpass filter specification
%   dlowpass.dat   -  Digital lowpass filter specification
%   dtmpspec.dat   -  Digital attenuation-limits filter specification
%
% INTERNALLY USED UTILITY ROUTINES
% ANALOG ADVANCED FILTER DESIGN
%   afd2d5.m       -  Analog AFD - design 2 x D5
%   afd3d5.m       -  Analog AFD - design 3 x D5
%   afda2k.m       -  Attenuation to characteristic function conversion
%   afdcheck.m     -  Check specification
%   afdd1.m        -  Analog AFD - design D1
%   afdd2.m        -  Analog AFD - design D2
%   afdd3a.m       -  Analog AFD - design D3a
%   afdd3b.m       -  Analog AFD - design D3b
%   afdd4a.m       -  Analog AFD - design D4a
%   afdd4b.m       -  Analog AFD - design D4b
%   afdd5.m        -  Analog AFD - design D5
%   afddemo.m      -  Demo specification and design D1
%   afddinfo.m     -  Show short help
%   afdedit.m      -  Change the current filter specification
%   afdesbu2.m     -  Generate buttons: Advanced Analog Filter Design
%   afdesbut.m     -  Generate buttons: Advanced Analog Filter Design
%   afdhp.m        -  Normalized lowpass elliptic transfer function
%   afdl.m         -  Discrimination factor L(n,ksi)
%   afdnell.m      -  Minimum elliptic order
%   afdnminq.m     -  Minimum elliptic order for minQ design
%   afdopen.m      -  Read-in a filter specification from a*.dat file
%   afdorder.m     -  Order range (nmin,nmax)
%   afdpass.m      -  Plot attenuation in passband
%   afdplot.m      -  Plot attenuation
%   afdqfmax.m     -  Maximum pole-Q factor
%   afdqk.m        -  q(k)
%   afdqx.m        -  qx(c)
%   afdrx.m        -  Rx(c)
%   afdsimsp.m     -  Simetric spec
%   afdsnaei.m     -  S(n,a,e,i)
%   afdstop.m      -  Plot attenuation in stopband
%   afdtran.m      -  Plot attenuation in transition band
%   afdv.m         -  dfdv(v) - Internal utility
%   afdview.m      -  View current filter specification
%   afdxmax.m      -  Maximum selectivity
%   afdxmin.m      -  Minimum selectivity
%   afdxminq.m     -  MinQ minimum selectivity
%   afdxna.m       -  X(n,a)
%   afdxnai.m      -  X(n,a,i)
%   afdzeta.m      -  Zeta(n,a,e)
%   afdzoom.m      -  Zoom attenuation
%   afdzoomd.m     -  Zoom attenuation
%   afdzoomp.m     -  Zoom attenuation plot
%
% INTERNALLY USED UTILITY ROUTINES
% DIGITAL ADVANCED FILTER DESIGN
%   dfd2d5.m       -  Digital AFD - design 2 x D5
%   dfda2k.m       -  Attenuation to characteristic function conversion
%   dfdab.m        -  Coefficients a and b
%   dfdcheck.m     -  Check specification
%   dfdd1.m        -  Digital AFD - design D1
%   dfdd2.m        -  Digital AFD - design D2
%   dfdd3a.m       -  Digital AFD - design D3a
%   dfdd3b.m       -  Digital AFD - design D3b
%   dfdd4a.m       -  Digital AFD - design D4a
%   dfdd4b.m       -  Digital AFD - design D4b
%   dfdd5.m        -  Digital AFD - design D5
%   dfddemo.m      -  Demo specification and design D1
%   dfddinfo.m     -  Show short help
%   dfdedit.m      -  Change the current filter specification
%   dfdemax.m      -  Maximum ripple
%   dfdemin.m      -  Minimum ripple
%   dfdesbu2.m     -  Generate buttons: Advanced Digital Filter Design
%   dfdesbut.m     -  Generate buttons: Advanced Digital Filter Design
%   dfdfpmax.m     -  Maximum normalizing frequency
%   dfdfpmin.m     -  Minimum normalizing frequency
%   dfdhb.m        -  Bandpass normalized transfer function
%   dfdhp.m        -  Highpass normalized transfer function
%   dfdhr.m        -  Bandreject normalized transfer function
%   dfdl.m         -  L(n,a)
%   dfdnell.m      -  Minimum order for a given spec
%   dfdnminq.m     -  Minimum order of minQ design
%   dfdopen.m      -  Read-in a filter specification from d*.dat file
%   dfdorder.m     -  Order range (nmin,nmax)
%   dfdpass.m      -  Plot attenuation in passband
%   dfdplot.m      -  Plot attenuation
%   dfdqk.m        -  q(k)
%   dfdqx.m        -  qx(c)
%   dfdqx2.m       -  qx2(c)
%   dfdqxmq.m      -  qxmq(c)
%   dfdrx.m        -  Rx(c)
%   dfdsimsp.m     -  Simetric spec
%   dfdsnaei.m     -  S(n,a,e,i)
%   dfdstop.m      -  Plot attenuation in stopband
%   dfdtran.m      -  Plot attenuation in transition band
%   dfdv.m         -  dfdv(v) - Internal utility
%   dfdview.m      -  View current filter specification
%   dfdxmax.m      -  Maximum selectivity
%   dfdxmin.m      -  Minimum selectivity
%   dfdxminq.m     -  MinQ minimum selectivity
%   dfdxmq2.m      -  MinQ minimum selectivity
%   dfdxna.m       -  X(n,a)
%   dfdxnai.m      -  X(n,a,i)
%   dfdzbl.m       -  Bilinear transform
%   dfdzeta.m      -  Zeta(n,a,e)
%   dfdzoom.m      -  Zoom attenuation
%   dfdzoomd.m     -  Zoom attenuation
%   dfdzoomp.m     -  Zoom attenuation plot
%                
   
%   -------------------------------------------
%   Copyright (c) 1999-2000 by Tosic & Lutovac
%   $Revision: 1.21 $  $Date: 2000/10/03 13:45$
%
% This file is part of AFDesign toolbox for MATLAB.
% Refer to the file LICENSE.TXT for full details.
%                        
% AFDesign version 2.1, Copyright (C) 1999-2000 D. Tosic and M. Lutovac
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
% 
