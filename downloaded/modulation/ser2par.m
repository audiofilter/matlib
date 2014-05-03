function [parallel] = ser2par(serial,no_bit)

% SER2PAR .....	Serial to parallel conversion
%
%	SER2PAR(X,N) generates from the input serial data represented by the
%		sequence X, using N bits/sample.
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
%       o       Modified under OCTAVE 2.0.14 2000.08.12
%===========================================================================

% no_sample = fix(length(serial)/no_bit);
% parallel  = zeros(no_bit,no_sample);
% parallel(:) = serial(1:(no_sample*no_bit));
% [nrow, ncol] = size(parallel);
% parallel = parallel(nrow:-1:1,:);	% reorder MSB and LSB
% parallel = parallel';

% MODIF. OCTAVE
no_sample = fix(length(serial)/no_bit);
parallel=reshape(serial,no_bit,no_sample);
