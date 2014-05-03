%% outer_deinterleave Outer (convolutional) Deinterleaver.
%%
%%   y = outer_deinterleave(x) performs convolutional deinterleaving
%%   on Galois field elements.x and y are column vectors.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Outer (convolutional) Deinterleaver
%% Project       : MOUSE
%%
%% File          : outer_deinterleave.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.6 $
%%---------------------------------------------------------------------------

function data_out = outer_deinterleave (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_RECEIVER;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  i = DVBT_SETTINGS.outer_interleaver.i;
  l = DVBT_SETTINGS.outer_interleaver.queue_size;
  m = DVBT_SETTINGS.outer_interleaver.m;
  n = DVBT_SETTINGS.packet_length.outer_interleaver;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_n, should_be_one] = size (data_in);
  assert (should_be_one == 1, 'outer_deinterleave', 'column vector expected');
  assert (should_be_n == n, 'outer_deinterleave', ...
          sprintf ('packet size: %d expected, %d found', ...
                   n, should_be_n));

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '  outer_deinterleave. (%d)\n', n);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fwrite (DUMP.outer_deinterleave, data_in, 'uchar');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  for mm = 1:m
    for ii = 1:i
      DVBT_STATE_RECEIVER.outer_interleaver.queue...
	  ((i-ii)*n + (mm-1)*i + ii) = ...
	  data_in((mm-1)*i + ii);
    end
  end

  data_out = DVBT_STATE_RECEIVER.outer_interleaver.queue(1:n);
  DVBT_STATE_RECEIVER.outer_interleaver.queue = ...
      [ DVBT_STATE_RECEIVER.outer_interleaver.queue(n+1:l) ;
       zeros(n,1) ];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  