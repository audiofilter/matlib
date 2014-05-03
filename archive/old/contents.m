% Tony's Toolbox.
% Version 1.0   15-Apr-94
% Copyright (c) Stanford Telecom Inc.
%
% pngen  	maximal length code with +1/0  outputs
% pngen1 	maximal length code with +1/-1 outputs
%
% initbpe	setup for BPE
% bpe		unquantized Block Phase estimator
%
% cmpi		Read in 3 column file (logic analyser) and create complex vector
%		with additional quantization handling
% det_eq	Determine 5 tap equalizer to reduce ISI given impulse response as input
% zero_pad	Insert 'N' zeros between samples.
%
% PLOT STUFF
% eyediag 	eye diagram plot
%
%
% IMPULSE RESPONSES
% cicimp 	impulse response for cascaded integrator comb interpolation filter
% rc		impulse response for raised cosine filter.
% src  		impulse response for square root raised cosine filter.
% al_src	impulse response for square root raised cosine with Allens' window & Quantization