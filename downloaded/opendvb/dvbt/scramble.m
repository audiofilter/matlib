%% scramble DVB-T Scrambler.
%%
%%   y = scramble(x) scrambles an MPEG transport packet stored in
%%   a column vector x. It uses the helper function scrambler_prbs.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Scrambler
%% Project       : MOUSE
%%
%% File          : scramble.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.8 $
%%---------------------------------------------------------------------------

function data_out = scramble (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_SENDER;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  n = DVBT_SETTINGS.packet_length.mux;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_n, should_be_one] = size (data_in);
  assert (should_be_one == 1, 'scramble', 'column vector expected');
  assert (should_be_n == n, 'scramble', ...
          sprintf ('packet size: %d expected, %d found', ...
                   n, should_be_n));
  assert (data_in(1) == DVBT_SETTINGS.scrambler.sync_byte, 'scramble', ...
          sprintf ('sync byte: %2.2x expected, %2.2x found', ...
                   DVBT_SETTINGS.scrambler.sync_byte, data_in(1)));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.sender, ...
           '  scramble. (n=%d, c=%d, sync=%2.2x)\n', ...
           n, DVBT_STATE_SENDER.n, data_in(1));

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  if rem(DVBT_STATE_SENDER.n,DVBT_SETTINGS.scrambler.prbs_period) == 0
    % first packet: invert sync byte and reset prbs state
    sync_byte = DVBT_SETTINGS.scrambler.inv_sync_byte;
    DVBT_STATE_SENDER.scrambler.prbs_register = ...
        DVBT_SETTINGS.scrambler.init_prbs_register;
  else
    % following packets: leave sync byte and advance PRBS by one
    sync_byte = DVBT_SETTINGS.scrambler.sync_byte;
    [ignore, DVBT_STATE_SENDER.scrambler.prbs_register] = ...
        scrambler_prbs (1, DVBT_STATE_SENDER.scrambler.prbs_register);
  end

  [prbs, DVBT_STATE_SENDER.scrambler.prbs_register] = ...
      scrambler_prbs (n-1, DVBT_STATE_SENDER.scrambler.prbs_register); 
  data_out=[sync_byte ; bitxor(data_in(2:n),prbs)];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fwrite (DUMP.scramble, data_out, 'uchar');