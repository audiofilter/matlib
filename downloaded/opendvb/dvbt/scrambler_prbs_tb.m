%% scrambler_prbs_tb Testbench for Scrambler's Pseudo Random Bit Sequence Testbench
%%
%%   This testbench script runs without arguments and checks if the
%%   pseudo random bit sequence of scrambler works.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Scrambler Pseudo Random Bit Sequence Testbench
%% Project       : MOUSE
%%
%% File          : scrambler_prbs_tb.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.5 $
%%---------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set system to defined state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization routines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_open;
global_settings;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import globals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global DVBT_SETTINGS;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters and abbreviations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = DVBT_SETTINGS.packet_length.mux;
p = DVBT_SETTINGS.scrambler.prbs_period;
m = n*p-1;

expected_first_value = bin2dec ('00000011');
expected_second_state = [1 1 0 0 0 0 0 0 1 0 0 1 0 1 0];
expected_final_state = [1 1 0 1 0 0 1 1 0 1 0 1 1 0 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('reading data.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = my_fopen ([getenv('MOUSE_TOP') '/home/tkirke/opendvb/ref/scrambler_prbs.ref'], 'r');
[expected_sequence, expected_length] = fread (f, Inf, 'uchar');
fclose (f);
if expected_length ~= m
  error ('corrupted reference file.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking first value:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[first_value, second_state] = ...
    scrambler_prbs (1, DVBT_SETTINGS.scrambler.init_prbs_register);
if first_value ~= expected_first_value
  fprintf (' error\n');
  dump_close;
  error ('incorrect first value');
end
if any(second_state ~= expected_second_state)
  fprintf (' error\n');
  dump_close;
  error ('incorrect second state');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking continuous:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[sequence, final_state] = ...
    scrambler_prbs (m, DVBT_SETTINGS.scrambler.init_prbs_register);
if any(final_state ~= expected_final_state)
  fprintf (' error\n');
  dump_close;
  error ('incorrect final state');
end
if any(sequence ~= expected_sequence)
  fprintf (' error\n');
  dump_close;
  error ('incorrect sequence');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking chunk-wise');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[sequence, state] = scrambler_prbs ...
    (n-1, DVBT_SETTINGS.scrambler.init_prbs_register);
for k = 2:p
  fprintf ('.');
  [chunk, state] = scrambler_prbs (n, state);
  sequence = [sequence ; chunk];
end
if any(state ~= expected_final_state)
  fprintf (' error\n');
  dump_close;
  error ('incorrect final state');
end
if any(any(sequence ~= expected_sequence))
  fprintf (' error\n');
  dump_close;
  error ('incorrect sequence');
end
fprintf ('OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_close;
fprintf ('\n');
fprintf ('scrambler_prbs works.\n');
