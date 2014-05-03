%% outer_interleaver_tb Testbench for Outer Interleaver and Deinterleaver.
%%
%%   This testbench script runs without arguments and checks if the
%%   subsystem of outer interleaver and deinterleaver works.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Outer (convolutional) Interleaver/Deinterleaver Testbench
%% Project       : MOUSE
%%
%% File          : outer_interleaver_tb.m
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
dump_open
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
l = 37;
i = DVBT_SETTINGS.outer_interleaver.i;
m = DVBT_SETTINGS.outer_interleaver.m;
n = DVBT_SETTINGS.packet_length.outer_interleaver;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('generating data.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = (1:n)' * ones (1,l) + ones (n,1) * (1i * (1:l));
y = zeros(n,l+i-1);
z = zeros(n,l);
z1 = zeros(n,i-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('interleaving');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:l
  fprintf ('.');
  y(:,k) = outer_interleave (x(:,k));
end
for k = l+1:l+i-1
  fprintf ('.');
  y(:,k) = outer_interleave (zeros(n,1));
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('deinterleaving');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:i-1
  fprintf ('.');
  z1(:,k) = outer_deinterleave (y(:,k));
end
for k = 1:l
  fprintf ('.');
  z(:,k) = outer_deinterleave (y(:,k+i-1));
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking data:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(any(z ~= x))
  fprintf (' error.\n');
  dump_close;
  error ('outer interleaver incorrect.\n');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_close;
fprintf ('\n');
fprintf ('Outer Interleaver works.\n');
