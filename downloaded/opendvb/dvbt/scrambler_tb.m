%% scrambler_tb Testbench for Scrambler and Descrambler
%%
%%   This testbench script runs without arguments and checks if the
%%   subsystem of scrambler and descrambler works.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Scrambler/Descrambler Testbench
%% Project       : MOUSE
%%
%% File          : scrambler_tb.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.6 $
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
dvbt_send_init;
dvbt_receive_init;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import globals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global DVBT_SETTINGS;
global DVBT_STATE_SENDER;
global DVBT_STATE_RECEIVER;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters and abbreviations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = 53;
n = DVBT_SETTINGS.packet_length.mux;
p = DVBT_SETTINGS.scrambler.prbs_period;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('generating data.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = floor(rand(n,m)*255.99);
for k = 1:m
  x(1,k) = DVBT_SETTINGS.scrambler.sync_byte;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reading prbs reference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = my_fopen ([getenv('MOUSE_TOP') '/home/tkirke/opendvb/ref/scrambler_prbs.ref'], 'r');
[prbs_sequence, expected_length] = fread (f, Inf, 'uchar');
fclose (f);
if expected_length ~= n*p-1
  error ('corrupted reference file.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('scrambling');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = zeros(n,m);
for k = 1:m
  if rem (k,10) == 0
    fprintf ('.');
  end
  DVBT_STATE_SENDER.n = k-1;
  y(:,k) = scramble (x(:,k));
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('sanity check of scrambling:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(bitxor(y(2:n,1), prbs_sequence(1:n-1)) ~= x(2:n,1))
  fprintf (' error\n');
  dump_close;
  error ('broken scrambler');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking descramble initial data:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:5
  result = descramble (zeros(n,1));
  if ~ isempty (result)
    fprintf (' error\n');
    dump_close;
    error ('error in descrambling initial data.\n');    
  end
end
fprintf (' OK\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('descrambling');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z = zeros(n,m);
for k = 1:m
  if rem (k,10) == 0
    fprintf ('.');
  end
  DVBT_STATE_RECEIVER.n = k-1;
  z(:,k) = descramble (y(:,k));
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking data:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(any(z ~= x))
  fprintf (' error.\n');
  dump_close;
  error ('scrambler values incorrect.\n');
end
fprintf (' OK.\n');

dump_close;
fprintf ('\n');
fprintf ('scrambler works.\n');
