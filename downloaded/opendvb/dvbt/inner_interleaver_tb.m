%% inner_interleaver_tb Testbench for Inner (block) Interleaver and Deinterleaver.
%%
%%   This testbench script runs without arguments and checks if the
%%   subsystem of inner interleaver and deinterleaver works.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Inner (block) Interleaver and Deinterleaver Testbench
%% Project       : MOUSE
%%
%% File          : inner_interleaver_tb.m
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
global DUMP;
global DVBT_SETTINGS;
global DVBT_STATE_SENDER;
global DVBT_STATE_RECEIVER;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters and abbreviations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = DVBT_SETTINGS.symbol_length.inner_interleaver;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('generating data.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1 = (1:n)';
x2 = (1:n)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('interleaving.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DVBT_STATE_SENDER.l = 0;
y1 = inner_interleave (x1);
DVBT_STATE_SENDER.l = 1;
y2 = inner_interleave (x2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('deinterleaving.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DVBT_STATE_RECEIVER.l = 0;
z1 = inner_deinterleave (y1);
DVBT_STATE_RECEIVER.l = 1;
z2 = inner_deinterleave (y2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking data:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(any(z1 ~= x1)) | any(any(z2 ~= x2))
  fprintf (' error.\n');
  dump_close;
  error ('inner interleaver incorrect.\n');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_close;
fprintf ('\n');
fprintf ('Inner Interleaver works.\n');
