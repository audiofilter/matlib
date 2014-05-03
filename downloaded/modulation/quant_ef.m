function  quant_ef(inq,no_bits)

% QUANT_EF ....	Evaluates the efficiency of the quantization operation.
%
%	QUANT_EF(XQ,N) operates on the input sequence XQ that had previously
%		quantized with QUANTIZE using 2^N quantization levels.  
%		The efficiency of the quantizer can be measured by observing 
%		how many of the 2^N quantization steps have been utilized.  
%		QUANT_EF computes and displays these statistics.

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

if ((nargin ~= 1) & (nargin ~= 2))
   error(eval('eval(BELL),eval(WARNING),help quant_ef'));
   return;
end   
if (no_bits > 8) | (no_bits < 1) | (no_bits ~= fix(no_bits))
   error('Number of bits/sample must be an integer between 1 and 8.');
end

no_qs = no_bits;

qstep = 2/no_qs;
for i = 1:1:(no_qs/2)
   q(      i    ) = -1 + (i-1)*qstep + qstep/2;
   q(no_qs-(i-1)) =  1 - (i-1)*qstep - qstep/2;
end

[nbins,foo] = hist(inq,q);
zerobin     = length(nbins(nbins==0));
okbin       = length(nbins(nbins~=0));

fprintf('\n');
fprintf('Number of available quantization steps ..... = %5.0f\n',no_qs);
fprintf('Number of used quantization steps .......... = %5.0f\n',okbin);
fprintf('Number of unused quantization steps ........ = %5.0f\n',zerobin);
fprintf('\n');
fprintf('PERCENTAGE UTILIZATION = %8.2f percent.\n', ((okbin/no_qs)*100) );
