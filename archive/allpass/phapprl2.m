function[P_VEKTOR] = phapprl2(OMEGA,WA_VEKTOR,N)

% function[P_VEKTOR] = phapprl2(OMEGA,WA_VEKTOR,N) 
% determines the denominator polynomial P_VECTOR of a digital allpass of
% degree N such that the resulting allpass phase approximates the phase
% WA_VEKTOR in the frequency points OMEGA. 
% 
% method:    non weighted overdetermined system of linear equations
%
% Author:    M. Raum, Markus Lang  <lang@jazz.rice.edu>, mar-18-1992
%

% Copyright: All software, documentation, and related files in this
%            distribution are Copyright (c) 1992 LNT, University of Erlangen
%            Nuernberg, FRG, 1992 
%
% Permission is granted for use and non-profit distribution providing that this
% notice be clearly maintained. The right to distribute any portion for profit
% or as part of any commercial product is specifically reserved for the author.
%
% Since this program is free of charge we provide absolutely no warranty.
% The entire risk as to the quality and the performance of the program is
% with the user. Should it prove defective, the user user assumes the cost
% of all necessary serrvicing, repair or correction. 


OMEGA = OMEGA(:);  WA_VEKTOR = WA_VEKTOR(:);

W_VEKTOR = -0.5 * ( N * OMEGA + WA_VEKTOR);
NU_VEKTOR = (N-1):-1:0;
A_MATRIX = sin(OMEGA* NU_VEKTOR + W_VEKTOR * ones(1,N));
B_VEKTOR = - sin(N * OMEGA + W_VEKTOR);

% solution in the L_2 sense
P_VEKTOR = A_MATRIX \ B_VEKTOR;
P_VEKTOR = [1; P_VEKTOR]';

