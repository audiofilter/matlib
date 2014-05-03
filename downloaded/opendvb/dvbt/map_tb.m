%% map_tb Testbench for OFDM Mapper/Demapper
%%
%%   This testbench script runs without arguments and checks if the
%%   subsystem of OFDM mapper and demapper works.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Mapper/Demapper Testbench
%% Project       : MOUSE
%%
%% File          : map_tb.m
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
m = DVBT_SETTINGS.map.bits;
n = DVBT_SETTINGS.symbol_length.payload;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('generating data.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = round(rand(n,m));
for ii = 1:2^m
  val = ii;
  for jj = 1:m
    if rem(val,2) ~= 0
      x(ii,jj) = 1;
    else
      x(ii,jj) = 0;
    end
    val = floor (val/2);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('mapping\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = map (x);
y1 = y + 0.1*(randn(n,1) + 1i * randn(n,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('demapping\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z1 = demap (y1);
z = z1 >= 0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking data:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if max(max(z - x)) > 100*eps
  fprintf (' error.\n');
  dump_close;
  error ('error in mapper.\n');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_close;
fprintf ('\n');
fprintf ('Mapper works.\n');

