function out = Q_function(in)

% Q_FUNCTION ..	Implementation of Q function using complementary error
%		function ERF from the MATLAB library..
%	
%	The probability that a Gaussian random variable with mean "m" and 
%	variance "s" will have an observed value greater than "m + ks" is
%	given by the value of the Q function evaluated at the point "k":
%
%				        inf             
%		Q(k) = 	(1/sqrt(2pi)) integral( exp(-(x^2)/2) dx )
%				        k	
%
%	In other words, if V ~ Gaussian(0,1), then Pr[V >= k] = Q(k).
%	REMARK: To avoid conflicts with variable names this function has been 
%		renamed "q_function" from "Q" as stated in the manual.
%
%	SEE ALSO: GAUSS, ERF.

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
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%       o       Modified under OCTAVE 2.0.14 2000.08.12
%===========================================================================

% out = (1/2) * erf( in/sqrt(2), Inf, 'high' );
 out = (1/2) * erf( in/sqrt(2) );  % MODIF. OCTAVE
