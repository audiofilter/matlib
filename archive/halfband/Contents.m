% Delta-Sigma Toolbox.
% Version 5.0	04-July-1997
% R. Schreier, Oregon State University
%
% Modulator synthesis and simulation
%   synthesizeNTF - Noise transfer function (NTF) synthesis.
%   clans         - Closed-loop analysis of noise shapers 
%		    (NTF synthesis for multi-bit modulators).
%   simulateDSM   - Simulate a delta-sigma modulator using either 
%		    its NTF or its state-space description.
%   simulateSNR   - Use simulateDSM to simulate a DSM with sine wave inputs 
%		    of varying amplitudes and then determine the SNR for each.
%   predictSNR    - SNR predicttion for binary modulators 
%		    (Ardalan & Paulos method)
%   simulateESL   - Simulate the element selection logic in a mismatch-shaping
%                   DAC.
%
% Modulator realization
%   realizeNTF	  - Compute coefficients for a particular modulator topology.
%   stuffABCD	  - Create the state-space description of a modulator given
%                   the coefficients for a particular topology.
%   scaleABCD     - Perform dynamic-range scaling.
%   mapABCD       - Convert a state-space description back to coefficients.
%
% Demonstrations
%   dsdemo1       - NTF synthesis: 5th-order lowpass and 8th-order bandpass.
%   dsdemo2       - Time-domain simulation and SNR calculation.
%   dsdemo3       - Modulator realization and dynamic range scaling.
%   dsdemo4       - Continuous-time bandpass modulator design using LC tanks.
%   dsdemo6       - Mismatch-shaping DAC.
%
% Other functions related to delta-sigma 
%   designHBF     - Design multiplierless half-band filters which use the 
%                 - the Saramaki recursive filter structure.
%   findPIS       - Compute a positively-invariant set for a DSM. (The 
%                   PosInvSet sub-directory will need to be added to your PATH)
%   evalTF        - Numerically evaluate a transfer function (TF).
%   infnorm       - Calculate the infinity norm (maximum gain) of a TF.

%       Copyright (c) 1993-97 R. Schreier
%       $Revision: 5.1 $
