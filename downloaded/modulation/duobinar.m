function [duobinary_pulse] = duobinar(duobinary_type,no_block,arg1)

% DUOBINAR .... Defines a basic truncated Duobinary pulse.
%
%	DUOBINAR(A,NB) generates a Duobinary pulse g(t) truncated to NB blocks 
%		with the number of samples in each block determined by the 
%		current values of "sampling frequency" and "binary data rate":
%
%				A * sinc(t/Tb)
%			g(t) = ---------------.
%				 A -  (t/Tb)
%
%		If A = 1, g(t) represents Duobinary coding;
%		   A = 2, g(t) represents Modified-Duobinary coding.
%
%	DUOBINAR(A,NB,Rb) uses the value of Rb for binary data rate.
% 
%	See also DUOB_GEN, WAVE_GEN.

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
global DUOBINARY_BLOCK;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Set up parameters
%------------------------------------------------------------------------------

if ((nargin ~= 2) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help duobinar'));
   return;
elseif (nargin == 2)
   Rb    = BINARY_DATA_RATE;
elseif (nargin == 3)
   Rb    = arg1;
   SAMPLING_FREQ    = SAMPLING_CONSTANT*Rb;	%  Change sampling frequency;
   BINARY_DATA_RATE = Rb; 			%  Reset global variable
end

Tb = 1/BINARY_DATA_RATE;
Ts = 1/SAMPLING_FREQ;

%------------------------------------------------------------------------------
%	Input consistency control
%------------------------------------------------------------------------------

if ((duobinary_type ~= 1) & (duobinary_type ~= 2))
   error('Parameter must be 1(duobinary) or 2(modified duobinary).');
end

%------------------------------------------------------------------------------
%			Generation of samples
%------------------------------------------------------------------------------
%
%	First define required parameters
%
%------------------------------------------------------------------------------

no_samples_per_block = Tb/Ts;
no_total_samples     = no_block * no_samples_per_block;
time                 = Ts * [-(no_total_samples/2):(no_total_samples/2 - 1)];
dconst               = duobinary_type;

%------------------------------------------------------------------------------
%	Determine the INDEX where denominator = 0, determine those values
%	through L'Hopital's rule.
%------------------------------------------------------------------------------

index  = ~(dconst==time/Tb);	% indices of samples where [denominator] = 0

g         = zeros(size(time));
g( index) = dconst * sinc(time(index)/Tb)    ./ (dconst - time(index)/Tb);
g(~index) = dconst * cos(pi*time(~index)/Tb) ./ (dconst - 2*time(~index)/Tb);

duobinary_pulse = [g(2:length(g)) 0];
