function [b_out] = detect(in,vth,sampling_instant,b_original)

% DETECT ......	Convert the waveform at the output of the receiver filter 
%		back to the binary sequence. Probability of bit error (BER)
%		is also computed if the original binary sequence is provided. 
%
%	DETECT(Y,v_th,Ti,B) is the calling form to this function with the
%		following parameters:
%
%		Y ..... = waveform at the output of the receiver filter;
%		v_th .. = decision threshold.  If the linecode is BIPOLAR then 
%			  this parameter must specify an interval of the form
%			  [v_th_negative, v_th_positive].
%		Ti .... = initial sampling instant.  Input waveform will be 
%			  sampled at  Ti, (Ti+Tb), (Ti+2Tb), ... 
%		B ..... = original input binary sequence (optional).
%
%	Z = DETECT(...) is the same as above but also returns the estimated 
%		binary sequence.

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
%       o       Modified under OCTAVE 2.0.14 2000.08.12 
%===========================================================================

global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Check input parameter consistency
%------------------------------------------------------------------------------

if ( (nargin ~= 3) & (nargin ~= 4) )
   error(eval('eval(BELL),eval(WARNING),help detect'));
   return;
end

%------------------------------------------------------------------------------
%	Now let us determine the basic pulse shapes and amplitude values
%------------------------------------------------------------------------------

Ts = 1/SAMPLING_FREQ;
Tb = 1/BINARY_DATA_RATE;

samples_delay   = fix(sampling_instant/Ts);
no_samples      = length(in);
no_decision     = fix((no_samples-samples_delay)/SAMPLING_CONSTANT);
if (no_decision <= 0)
  error('Initial sampling instant exceeds input waveform duration.');
end
index_test      = SAMPLING_CONSTANT * [0:(no_decision-1)] + samples_delay;
% b_estimate      = zeros(no_decision,1);
b_estimate      = zeros(1,no_decision);  % MODIF. OCTAVE
v_threshold     = vth;


if ( length(v_threshold) == 1 )		% all binaries cases except BIPOLAR

    index = ( in(index_test) >= v_threshold );
%    b_estimate(index) = ones(sum(index),1);
    b_estimate(index) = ones(1,sum(index)); % MODIF. OCTAVE

elseif ( length(v_threshold) == 2 )	% BIPOLAR case

    v_thr_pos      = max(v_threshold);
    index_pos_test = index_test( in(index_test)>=0 );
    index_pos      = ( in(index_test)>=0 );
    b_estimate(index_pos) = ( in(index_pos_test) >= v_thr_pos );

    v_thr_neg      = min(v_threshold);
    index_neg_test = index_test( in(index_test)<0  );
    index_neg      = ( in(index_test)<0  );
    b_estimate(index_neg) = ( in(index_neg_test) <= v_thr_neg );

elseif ( length(v_threshold) >2 )		% PAM case

    b_estimate = zeros(sum(index_test),1);
    v_threshold = sort (v_threshold);
    n_th = size(v_threshold,2);
    b_estimate = ( in(index_test) < v_threshold(1));
    for i=2:n_th
        b_estimate = b_estimate+i*(( in(index_test) >= v_threshold(i-1))&( in(index_test)  < v_threshold(i)));
    end
    b_estimate = b_estimate+(n_th+1)*( in(index_test) >= v_threshold(n_th) );


else

    error('Unknown linecode type')

end


if (nargin == 4)
    in_binary = b_original;
    out_binary = b_estimate;
    no_decision = min(length(in_binary),length(out_binary));
    seq0 =  in_binary(1:no_decision);
    seq1 = out_binary(1:no_decision);
%    correct    = ~xor(seq0(:),seq1(:));
    correct = (seq0 == seq1);
    no_correct = sum(correct);
    fprintf('Probability of bit error (BER) = %10.6f.\n',(1-no_correct/no_decision));
end

if(nargout == 1)
    b_out = b_estimate;
end
