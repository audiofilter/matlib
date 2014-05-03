%% convolutional_tb Testbench for Convolutional Encoder and Decoder
%%
%%   This testbench script runs without arguments and checks if the
%%   subsystem of convolutional encoder and decoder works.

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
%% File          : convolutional_tb.m
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

assert (DVBT_SETTINGS.convolutional_code.init_kammeyer, ...
	'convolutional_tb', ...
	'need Kammeyer code to run');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters and abbreviations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = 2;
n = DVBT_SETTINGS.symbol_length.bit_stream;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('generating data.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = round(rand(n,m));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('encoding (simple)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DVBT_SETTINGS.convolutional_code.use_kammeyer = 0;
y_simple_x = zeros(n,m);
y_simple_y = zeros(n,m);
for l = 1:m
  fprintf ('.');
  DVBT_STATE_SENDER.convolutional_code = ...
      DVBT_SETTINGS.convolutional_code.init_register;
  [y_simple_x(:,l), y_simple_y(:,l)] = convolutional_encode (x(:,l));
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('encoding (Kammeyer)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DVBT_SETTINGS.convolutional_code.use_kammeyer = 1;
y_kammeyer_x = zeros(n,m);
y_kammeyer_y = zeros(n,m);
for l = 1:m
  fprintf ('.');
  [y_kammeyer_x(:,l), y_kammeyer_y(:,l)] = convolutional_encode (x(:,l));
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking data:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(any(y_simple_x ~= y_kammeyer_x))
  fprintf ('\nSimple encoder does not match Kammeyer encoder.\n');
else
  fprintf (' OK.\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('decoding (simple)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DVBT_SETTINGS.convolutional_code.use_kammeyer = 0;
z_simple = zeros(n,m);
for l = 1:m
  fprintf ('.');
  DVBT_STATE_RECEIVER.convolutional_code = ...
      DVBT_SETTINGS.convolutional_code.init_register;
  z_simple(:,l) = convolutional_decode (y_simple_x(:,l), y_simple_y(:,l));
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('decoding (Kammeyer)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DVBT_SETTINGS.convolutional_code.use_kammeyer = 1;
z_kammeyer = zeros(n,m);
for l = 1:m
  fprintf ('.');
  z_kammeyer(:,l) = convolutional_decode (y_kammeyer_x(:,l), y_kammeyer_y(:,l));
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking data:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf (' (simple)');
if any(any(z_simple ~= x))
  fprintf (' error in simple codec.\n');
  dump_close;
  error ('convolutional code incorrect.');
end
fprintf (' (Kammeyer)');
if any(any(z_kammeyer ~= x))
  fprintf (' error in Kammeyer codec.\n');
  dump_close;
  error ('convolutional code incorrect.');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_close;
fprintf ('\n');
fprintf ('convolutional code works.\n');
