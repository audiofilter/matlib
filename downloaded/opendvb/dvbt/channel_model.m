%% channel_model Simulates a transmission channel.
%%
%%   y = channel_model(x) transmits a complex data vector with values in
%%   the range of -1:1 over a simulated transmission channel.
%%   In the current version, the trivial channel model is implemented,
%%   i.e., the transmission function is identity.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Channel Model
%% Project       : MOUSE
%%
%% File          : channel_model.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/12/09 15:28:47 $ by $Author: gordon $
%% Revision      : $Revision: 1.9 $
%%---------------------------------------------------------------------------

function data_channel_out = channel_model (data_channel_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.main, 'C: transmitting %d samples.\n', length(data_channel_in));

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  data_channel_out = data_channel_in;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  raw_data = reshape ([real(data_channel_out)' ; imag(data_channel_out)'], ...
		      2*length (data_channel_out), 1);
  fwrite (DUMP.channel, raw_data, 'float32');