function [serial] = a2d(in_analog,no_bits,arg3,arg4)

% A2D .........	Analog-to-digital conversion.
%
%	A2D(X,N,FLAG_1,FLAG_2) operates on the sampled input sequence X.  
%		Each sample is quantized and coded using N-bits/sample.
%		FLAG_1 specifies the type of quantization.
%		Choices for FLAG_1 are:
%
%			'uniform'	and	'mu_law'
%
%		FLAG_2 determines how the 2^N quantization level are coded.
%		Choices for FLAG_2 are:
%
%			'natural'	and	'gray'
%
%	A2D(X,N,FLAG_1) uses the default coding method 'natural'.
%	A2D(X,N) uses default flags of 'uniform' and 'natural'.
%
%	See also QUANTIZE, MU_LAW, BIN_ENC, BIN2GRAY.

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

%------------------------------------------------------------------------------
%	Check input parameters and assign function parameters.
%------------------------------------------------------------------------------

if ((nargin ~= 2) & (nargin ~= 3) & (nargin ~= 4))
   error(eval('eval(BELL),eval(WARNING),help a2d'));
   return;
elseif (nargin == 2)
   companding    = 'uniform';
   source_coding = 'natural';
elseif (nargin == 3)
   companding    = arg3;
   source_coding = 'natural';
elseif (nargin == 4)
   companding    = arg3;
   source_coding = arg4;
end

fprintf('\n\t\t\t       A/D CONVERSION \n');
fprintf(  '\t\t\t--------------------------\n\n');

%------------------------------------------------------------------------------
%	[1].  Companding if required and then quantization.
%------------------------------------------------------------------------------

fprintf('o PERFORMING QUANTIZATION : \n');

if (strcmp(companding,'uniform')), 
   x = in_analog;
elseif (strcmp(companding,'mu_law')), 
   fprintf('\t Mu_law companding;\n');
   x = mu_law(in_analog); 
   fprintf('\t\t Companding complete;\n');
else
   error('Unknown companding/quantization type.');
end

xq = quantize(x,no_bits);

fprintf('\t Quantization complete.\n');

%------------------------------------------------------------------------------
%	[2].  Binary transformation and GRAY coding if required.
%------------------------------------------------------------------------------

fprintf('o PERFORMING SOURCE CODING : \n');

fprintf('\t Natural binary coding;\n');

xsource = bin_enc(xq,no_bits);

if strcmp(source_coding,'natural')
   fprintf('\t\t Natural Binary coding complete;\n');
   fprintf('\t Source coding complete.\n');
elseif strcmp(source_coding,'gray')
   fprintf('\t\t Natural Binary coding complete;\n');
   fprintf('\t Natural Binary --> GRAY-code transformation;\n');
   xgray   = bin2gray(xsource);
   fprintf('\t\t GRAY coding complete;\n');
   fprintf('\t Source coding complete.\n');
   xsource = xgray;
else
   error('Unknown source coding');
end

%------------------------------------------------------------------------------
%	[3].  Parallel to serial convertion.
%------------------------------------------------------------------------------

fprintf('o PERFORMING PARALLEL-TO-SERIAL CONVERSION : \n');

xsource = rot90(xsource);  % MODIF. OCTAVE PAR2SER
serial = par2ser(xsource);

fprintf('\t Parallel-to-serial conversion complete.\n');
