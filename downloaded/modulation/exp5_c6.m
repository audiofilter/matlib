function [out] = exp5_c6(power)

% EXP5_C6 .....	Experiment 5 step C6.
%
%	EXP5_C6( POWER ) performs the procedure outlined in step C6 of 
%		experiment at the POWER level and returns the following vector
%		as a result:
%
%		[ signal_power    SQNR(uniform)     SQNR(non-uniform) ];
%
%		All answers are in dBW.

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

%------------------------------------------------------------------------
%	Input parameter control
%------------------------------------------------------------------------
if (nargin ~= 1)
   error(eval('eval(BELL),eval(WARNING),help exp5_c6'));
   return;
end   

no_pow = length(power);
if ( ~isempty(find(power<0)) )
   error('Power values must be a positive.');
end
out = zeros(no_pow,3);

%------------------------------------------------------------------------
%	Perform required operations
%------------------------------------------------------------------------

if( nargout == 0 )
	disp('                                      '),   ...
	disp('  SIGMAs^2   SQNR(un)  SQNR(mu-law)   '),   ...
	disp('--------------------------------------')
end

for ii = 1:no_pow

	s          = limiter(laplace(1000,power(ii)),-1,1);	% Original sequence
	sq         = quantize(s,8);			% Uniform quantized sequence
	msq        = mu_inv(quantize(mu_law(s),8));	% Non-uniform quantized sequence

	sigma2_s   = var(s);				% Variance of "s"
	sigma2_sq  = var(s-sq);				% Variance of "sq"
	sigma2_msq = var(s-msq);			% Variance of "msq"

	snr_unif   = 10*log10( sigma2_s / sigma2_sq );  	% SQNR(uniform)
	snr_nunif  = 10*log10( sigma2_s / sigma2_msq );  	% SQNR(non-uniform)

	out(ii,:)   = [ 10*log10(var(s)), snr_unif, snr_nunif ];

end
