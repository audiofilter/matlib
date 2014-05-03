%% rs_tb Testbench for Reed/Solomon Encoder and Decoder
%%
%%   This testbench script runs without arguments and checks if the
%%   subsystem of Reed/Solomon encoder and decoder works.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Reed/Solomon Encoder/Decoder Testbench
%% Project       : MOUSE
%%
%% File          : rs_tb.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.12 $
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
global GF;
global DVBT_SETTINGS;
global DVBT_STATE_SENDER;
global DVBT_STATE_RECEIVER;
global DUMP;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters and abbreviations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = 1;
k = DVBT_SETTINGS.rs.k;
n = DVBT_SETTINGS.rs.n;
t = DVBT_SETTINGS.rs.t;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('reading data.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reed/Solomon Code Generator Polynome
f = my_fopen ([getenv('MOUSE_TOP') '/home/tkirke/opendvb/ref/rs_cgp.ref'], 'r');
[rs_cgp expected_length] = fread (f, Inf, 'uchar');
fclose (f);
if expected_length ~= 2*t+1
  error ('corrupted reference file.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking against stored tables:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf (' (cgp)');
if DVBT_SETTINGS.rs.g ~= rs_cgp
  fprintf (' error\n');
  dump_close;
  error ('incorrect code generator polynome');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('generating data.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = floor(rand(k,m)*255.99);
for index = 1:m
  if rem(index,8) == 0
    x(1,index) = DVBT_SETTINGS.scrambler.inv_sync_byte;
  else
    x(1,index) = DVBT_SETTINGS.scrambler.sync_byte;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('Reed/Solomon encode');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = zeros(n,m);
for index = 1:m
  fprintf ('.');
  y(:,index) = rs_encode (x(:,index));
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_close;
fprintf ('\n');
