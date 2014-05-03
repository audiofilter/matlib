function [x_estimate] = d2a(in_serial,no_bits,arg3,arg4)

% D2A .........	Digital-to-analog conversion of PCM data.
%
%	D2A(X,N,FLAG_1,FLAG_2) operates on the input data X.  
%		The input sequence is assumed to be a binary, serial data 
%		where each sample is represented by N bits.  
%		The flags are as follows:
%
%		FLAG_1 : 'uniform' or 'mu_law'.
%		FLAG_2 : 'natural' or 'gray';
%
%	D2A(X,N) is equivalent to calling D2A function with
%		FLAG_1 = 'uniform and 'FLAG_2 = 'natural'.
%	D2A(X,N,FLAG_1) is equivalent to calling D2A function with
%		FLAG_2 = 'natural'.
%
%	See also A2D, DIFF_DEC, BIN_DEC, GRAY2BIN, MU_INV.

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
%	o   Eliminated output LPF. 06.19.91 MZ
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
   error(eval('eval(BELL),eval(WARNING),help d2a'));
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

if ( any( abs(in_serial)-sign(in_serial)) )
   error('Input sequence is not binary')
end

fprintf('\n\t\t\t    DECODING CHANNEL OUTPUT  \n');
fprintf(  '\t\t\t-------------------------------\n\n');

%------------------------------------------------------------------------------
%	[1].  Parallel to serial convertion.
%------------------------------------------------------------------------------

fprintf('o PERFORMING SERIAL-TO-PARALLEL CONVERSION : \n');

x_parallel = ser2par(in_serial,no_bits);
x_parallel = rot90(x_parallel,-1); % MODIF. OCTAVE SER2PAR

fprintf('\t Serial-to-parallel conversion complete.\n');

%------------------------------------------------------------------------------
%	[2].  Binary to analog convarsion
%------------------------------------------------------------------------------

fprintf('o PERFORMING BINARY-TO-QUANTIZED-ANALOG CONVERSION : \n');

if strcmp(source_coding,'gray')
   fprintf('\t GRAY --> NATURAL transformation;\n');
   x_bin = gray2bin(x_parallel);
   fprintf('\t\t GRAY decoding complete;\n');
elseif strcmp(source_coding,'natural')
   x_bin = x_parallel;
else
   error('Unknown source coding');
end

fprintf('\t Binary to quantization level conversion;\n');

x_quantized = bin_dec(x_bin);

fprintf('\t\t BINARY to quantization level conversion complete;\n');
fprintf('\t Source decoding complete.\n');

%------------------------------------------------------------------------------
%	[3].  If during A/D mu-law was used we have to reverse the companding
%	      and low-pass filter the signal.
%------------------------------------------------------------------------------

fprintf('o PERFORMING QUANTIZED-ANALOG-TO-ANALOG CONVERSION : \n');

if (strcmp(companding,'uniform')), 
   x = x_quantized;
elseif (strcmp(companding,'mu_law')), 
   fprintf('\t Mu_law expansion;\n');
   x = mu_inv(x_quantized); 
   fprintf('\t\t Expansion complete;\n');
else
   error('Unknown companding/quantization type.');
end

x_estimate = x;
