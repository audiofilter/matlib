function quant_ch(no_bits,type,mu)

% QUANT_CH .... Diplay quantizer characteristic.
%
%	QUANT_CH(N,TYPE) displays the input-output charcteristics of a TYPE 
%		quantizer that employs 2^N quantization levels.  N should be 
%		an integer between 1 and 8, otherwise output takes forever.  
%		Valid TYPE options are: 'UNIFORM' and 'MU_LAW'.  
%		A 45 degree line corresponding to unity transformation is 
%		included for reference purposes.  With increasing N, the 
%		quantizer characteristic will approach the reference.
%
%	QUANT_CH(N,'MU_LAW',MU) If TYPE == 'MU_LAW', then an optional MU
%		parameter can be entered. Note that the default value for
%		MU = 255, which is the North American standard. MU = 1
%		corresponds to uniform quantization.
%
%	See also QUANTIZER, MU_LAW, QUANT_EF.

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

%---------------------------------------------------------------------------
%	Define defaults
%---------------------------------------------------------------------------

NMAX = 8;
NOPT = nan;

%---------------------------------------------------------------------------
%	Check input parameters
%---------------------------------------------------------------------------

if ((nargin ~= 1) & (nargin ~= 2) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help quant_ch'));
   return;
end   
if (no_bits > NMAX) | (no_bits < 2) | (no_bits ~= fix(no_bits))
   error('Number of bits/sample must be an integer between 1 and 8.');
end

%---------------------------------------------------------------------------
%	Check validity of TYPE option
%---------------------------------------------------------------------------

if strcmp(type, 'uniform')
   NOPT = 0;
elseif strcmp(type, 'mu_law')
   NOPT = 1;
end
if isnan(NOPT), error('Unknown quantize TYPE'), end

%---------------------------------------------------------------------------
%	Set-up input vector X and quantized values of X, namely XQ.
%---------------------------------------------------------------------------

x = [-1:0.01:1];
if (NOPT == 0)
   xq = quantize(x,no_bits);
elseif (NOPT == 1)
   if (nargin == 2)
      xq = quantize(mu_law(x),no_bits);
   elseif (nargin == 3)
      xq = quantize(mu_law(x,mu),no_bits);
   end
end

%---------------------------------------------------------------------------
%	Display set-up
%---------------------------------------------------------------------------

title('QUANTIZER CHARACTERISTIC'), ...
xlabel('INPUT'),                   ...
ylabel('OUTPUT'),                  ...
% axis('square'),   ...
axis;  grid,                       ...
plot(x,x); hold on, stairs(x,xq);

hold off
