function [out] = dice(in,face,dice_type)
%
% DICE ........ Generates discrete random variables simulating the outcome
%		of an experiment where the gambler rolls a "DIE".
%
%	DICE(N,FACE,TYPE) generates N discrete valued random variates 
%		representing the outcome of the experiment where the gambler 
%		rolls a "FACE"-faced die N times.  FACE is limited to a 
%		maximum number of 10 (THIS RESTRICTION CAN BE ELIMINATED).  
%               The fairness in this experiment is 
%		determined by the TYPE parameter, which can be either:
%		
%			'fair'		or		'biased'
%
%       DICE(N,FACE) is the same but uses the default 'fair' die.

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
global BELL;
global WARNING;

check;

%-------------------------------------------------------------------------
%	Define default parameters and default setup.
%-------------------------------------------------------------------------
type_default = 'fair';
%-------------------------------------------------------------------------
%	Check input parameters
%-------------------------------------------------------------------------
if ((nargin < 2) | (nargin > 3))
   error(eval('eval(BELL),eval(WARNING),help dice'));
   return;
end
if (nargin == 2), dice_type = type_default;                end
% if ( face > 10 ), error('Number of faces must be <= 10.'); end

if  strcmp(dice_type, 'fair')

    a = rand(1,in);

elseif  strcmp(dice_type, 'biased')

    mu = 20*rand;
    z = randn(1,in);
    r = abs(z + mu);
    a = r - min(r) + 0.001;
    a = a/max(a+0.001);

else

    error('Unknown dice type; consult your gambling master.')

end

delta = 1/face;
[out] = ceil( a/delta );

