function g = triangle(arg1,arg2)

% TRIANGLE ..... Generates a "triangular" pulse. 
%
%			      /\        +1
%			    /    \      
%			  /        \    
%			/            \   0
%
%		--------+------+-----+---------> time
%			0     Tb/2   Tb   
%
%		There will be "SAMPLING_CONSTANT" samples to represent this 
%		pulse shape.  This function is used by the M-function WAVE_GEN.	

%	AUTHORS : M. Zeytinoglu & N. W. Ma
%             Department of Electrical & Computer Engineering
%             Ryerson Polytechnic University
%             Toronto, Ontario, CANADA
%
%	DATE    : August 1991.
%	VERSION : 1.0

%===========================================================================
% Modifications history:
% ----------------------
%	o   Added "checking"  11.30.1992 MZ
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%===========================================================================

global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;

check;

if (nargin == 0)
   Rb = BINARY_DATA_RATE;
   fs = SAMPLING_FREQ;
elseif (nargin == 1)
   Rb = arg1;
   fs = SAMPLING_FREQ;
elseif (nargin == 2)
   Rb = arg1;
   fs = arg2;
end

no_sample = fs/Rb;
no_middle = no_sample./2;
delta     = 1/no_middle;

g(            1:(no_middle)) = [delta:delta:1];
g((no_middle+1):(no_sample)) = [(1-delta):-delta:0];

if(size(g,2)==1) g=g'; end;  % MODIF. OCTAVE 
