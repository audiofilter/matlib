%% rs_tb Testbench for Reed/Solomon Encoder and Decoder
%%
%%   This testbench script runs without arguments and checks if the
%%   subsystem of Reed/Solomon encoder and decoder works.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universitšt Dresden
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
m = 49;
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
fprintf ('Checking encode');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for index = 1:m
  fprintf ('.');
  if any(any(rs_syndrome (y(:,index)) ~= 0))
    error ('incorrectly encoded data.');
  end
end
fprintf ('OK\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Error simulation\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for index = 1:m
  num_errors = rem(index, (t+1));
  fprintf (DUMP.receiver, 'Making %d errors in packet %d\n', ...
	   num_errors, index);
  for err = 1:num_errors
    pos = floor(1+rand(1,1)*(n-0.01));
    fprintf (DUMP.receiver, '  packet%d[%d] was %d\n', ...
	     index, pos, y(pos,index));
    y(pos,index) = floor (rand(1,1) * 255.99);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('Reed/Solomon decode');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z = zeros(k,m);
for index = 1:m
  fprintf ('.');
  z(:,index) = rs_decode (y(:,index));
end
fprintf ('OK\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking data:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(any(z ~= x))
  fprintf (' error.\n');
  dump_close;
  error ('Reed/Solomon incorrect.\n');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_close;
fprintf ('\n');
fprintf ('Reed/Solomon works.\n');
