function  [out] = rc(fc,in)

% RC ..........	First-order rc lowpass filter.
%
% 	Y = RC(fc,X) returns vector Y obtained through low-pass filtering the
%		input sequence X. "fc" is the cutoff frequency of the filter.
%

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
%       o       Modified under OCTAVE 2.0.14 2000.08.12
%===========================================================================

global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global BELL;
global WARNING;

check;

if (nargin ~= 2)
   error(eval('eval(BELL),eval(WARNING),help rc'));
   return;
end

%----------------------------------------------------------------------------
%	set the sampling frequency fs, and check its consistency
%----------------------------------------------------------------------------

fs = SAMPLING_FREQ;			% Default sampling frequency.
if (fc > (fs/2))
   error('Cut-off frequency fc must be <= (fs/2)')
end

passband = [fc/(fs/2)];			% Passband specification
[Bc,Ac]  = butter(1,passband);
[out1 out2]  = filter(Bc,Ac,in);
out3 = filter(Bc,Ac,zeros(1,SAMPLING_CONSTANT),out2);
if(size(out1,1)==1) out1=out1'; end   % MODIF. OCTAVE
if(size(out3,1)==1) out3=out3'; end   % MODIF. OCTAVE
out = [out1(:)' out3(:)'];
