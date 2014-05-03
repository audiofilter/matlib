function out = fftsize(in)

% FFTSIZE ..... Determines the fft block size for efficient computation,
%		Output is a power or 2.  
%
%	FFTSIZE(N) generates minimum power of 2 that is greater than or equal 
%		to N.  For example FFTSIZE(512) = 512,and FFTSIZE(513) = 1024.  
%		For efficiency reasons the maximum allowed block size is 
%		8192 = 2^13.

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
%===========================================================================

%------------------------------------------------------------------------------
%		Define deafult parameter values
%------------------------------------------------------------------------------

MAX_BITSIZE = 13;			% for MAX_FFTSIZE = 2^13 = 8192;

%------------------------------------------------------------------------------
%	Check input against limits
%------------------------------------------------------------------------------

if ( in <= 0)
   error('Input must be greater than zero.')
end
if ( in > (2^MAX_BITSIZE) )
   error(fprintf('FFTSIZE : Try block size less than %5.0f\n',(2^MAX_BITSIZE)))
end

%------------------------------------------------------------------------------
%	Everything is O.K., lets compute the required fft block size.
%------------------------------------------------------------------------------

for ii = 1:MAX_BITSIZE
    blocksize = 2^ii;
    if ( (in/blocksize) == 1 )
       out = blocksize;
       return
    end
    if ( fix(in/blocksize) == 0 )
       out = blocksize;
       return
    end
end
