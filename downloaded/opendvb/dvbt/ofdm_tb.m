%% ofdm_tb Testbench for OFDM Encoder and Decoder
%%
%%   This testbench script runs without arguments and checks if the
%%   subsystem of OFDM encoder and decoder works.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Convolutional Encoder/Decoder Testbench
%% Project       : MOUSE
%%
%% File          : ofdm_tb.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.3 $
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
l = 3;
m = DVBT_SETTINGS.symbol_length.ad_conv;
n = DVBT_SETTINGS.symbol_length.fft;
g = DVBT_SETTINGS.ofdm.guard_length;
k = DVBT_SETTINGS.ofdm.carrier_count;
assert (m == n+g, 'ofdm_encode', 'invalid guard length')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('generating data.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = (floor(rand(k,l)*3)-1) + j*(floor(rand(k,l)*3)-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('encoding');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = zeros(m,l);
for o = 1:l
  fprintf ('.');
  y(:,o) = ofdm_encode (x(:,o));
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('decoding');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z = zeros(k,l);
for o = 1:l
  fprintf ('.');
  z(:,o) = ofdm_decode (y(:,o));
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking data:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if max(max(x - z)) >= 100*eps
  fprintf (' error.\n');
  dump_close;
  error ('ofdm values incorrect.\n');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_close;
fprintf ('\n');
fprintf ('ofdm works.\n');
