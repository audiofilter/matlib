%% descramble Performs OFDM/QAM demapping.
%%
%%   y = descramble(x) reverses the effects of scrambling to a
%%   byte column vector x. It uses the helper function scrambler_prbs.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Descrambler
%% Project       : MOUSE
%%
%% File          : descramble.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.7 $
%%---------------------------------------------------------------------------

function data_out = descramble (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_RECEIVER;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  n = DVBT_SETTINGS.packet_length.mux;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_n, should_be_one] = size (data_in);
  assert (should_be_one == 1, 'descramble', 'column vector expected');
  assert (should_be_n == n, 'descramble', ...
          sprintf ('packet size: %d expected, %d found', ...
                   n, should_be_n));
  sync_byte = data_in(1);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '  descramble. (n=%d, c=%d, sync=%2.2x)\n', ...
           n, DVBT_STATE_RECEIVER.n, sync_byte);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fwrite (DUMP.descramble, data_in, 'uchar');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  switch sync_byte
    case DVBT_SETTINGS.scrambler.inv_sync_byte
      if rem(DVBT_STATE_RECEIVER.n,DVBT_SETTINGS.scrambler.prbs_period) ~= 0
        fprintf (DUMP.receiver, 'descramble: resyncing c from %d to 0\n', ...
                 DVBT_STATE_RECEIVER.n);
	DVBT_STATE_RECEIVER.n = 0;
      end
      DVBT_STATE_RECEIVER.scrambler.prbs_register = ...
          DVBT_SETTINGS.scrambler.init_prbs_register;
    case DVBT_SETTINGS.scrambler.sync_byte
      [ignore, DVBT_STATE_RECEIVER.scrambler.prbs_register] = ...
          scrambler_prbs (1, DVBT_STATE_RECEIVER.scrambler.prbs_register);
    otherwise
      fprintf (DUMP.receiver, ...
               'descramble: dropping invalid packet\n', ...
               sync_byte);
      data_out = [];
      return;
  end

  [prbs, DVBT_STATE_RECEIVER.scrambler.prbs_register] = ...
      scrambler_prbs (n-1, DVBT_STATE_RECEIVER.scrambler.prbs_register);
  data_out=[DVBT_SETTINGS.scrambler.sync_byte ; ...
            bitxor(data_in(2:n),prbs)];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
