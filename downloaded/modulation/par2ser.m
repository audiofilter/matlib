function [serial] = par2ser(parallel)

% PAR2SER .....	serial to parallel conversion
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
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%===========================================================================

% [no_sample, no_bit] = size(parallel);
% parallel = parallel(:,no_bit:-1:1);	% reorder MSB and LSB
% parallel = parallel';
% serial   = parallel(:)';

% MODIF. OCTAVE
serial = parallel(:)';

