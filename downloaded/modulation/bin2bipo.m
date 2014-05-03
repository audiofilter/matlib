function [bipolar_sequence] = bin2bipo(binary_sequence)

% BIN2BIPO ....	Binary to bipolar conversion
%
%	[P] = BIN2BIPO(B) converts the binary sequence B into a bipolar sequence
%		using the transformation:
%
%			    1 ----> +1, -1, alternating
%			    0 ----> 0 
%
% 		For example:  [1 0 1 1 1 ...] ----> [1 0 -1 1 -1 ...] 

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

no_binary = length(binary_sequence);

for ii = 1:no_binary
    bipolar_sequence(ii) =  ...
                  binary_sequence(ii) * (-1)^(sum(binary_sequence(1:ii)) - 1);
end

if(size(bipolar_sequence) ~= size(binary_sequence) )
    bipolar_sequence=bipolar_sequence'; % MODIF. OCTAVE
end  

