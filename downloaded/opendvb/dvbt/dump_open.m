%% dump_open Open all dump files.
%%
%%   dump_open() opens all dump files.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Dump Files - Open
%% Project       : MOUSE
%%
%% File          : dump_open.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/05/07 13:03:53 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.7 $
%%---------------------------------------------------------------------------

function dump_open ()

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  DUMP = {};

  config;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % File dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % main files
  DUMP.main = my_fopen([DUMP.SETTINGS.test_dir '/dvbt.txt'], 'w');
  DUMP.sender = my_fopen([DUMP.SETTINGS.test_dir '/send.txt'], 'w');
  DUMP.receiver = my_fopen([DUMP.SETTINGS.test_dir '/receive.txt'], 'w');
  DUMP.channel = my_fopen([DUMP.SETTINGS.test_dir '/channel.dump'], 'w');
  % 1. Scrambler
  DUMP.scramble = my_fopen([DUMP.SETTINGS.test_dir '/scramble.dump'], 'w');
  DUMP.descramble = my_fopen([DUMP.SETTINGS.test_dir '/descramble.dump'], 'w');
  % 2. Reed-Solomon (rs)
  DUMP.rs_encode = my_fopen([DUMP.SETTINGS.test_dir '/rs_encode.dump'], 'w');
  DUMP.rs_decode = my_fopen([DUMP.SETTINGS.test_dir '/rs_decode.dump'], 'w');
  % 3. Outer interleaver
  DUMP.outer_interleave = my_fopen([DUMP.SETTINGS.test_dir '/outer_interleave.dump'], 'w');
  DUMP.outer_deinterleave = my_fopen([DUMP.SETTINGS.test_dir '/outer_deinterleave.dump'], 'w');
  % 4. Convolutional codec
  DUMP.convolutional_encode = my_fopen([DUMP.SETTINGS.test_dir '/convolutional_encode.dump'], 'w');
  DUMP.convolutional_decode = my_fopen([DUMP.SETTINGS.test_dir '/convolutional_decode.dump'], 'w');
  % 5. Puncturing
  DUMP.puncturing = my_fopen([DUMP.SETTINGS.test_dir '/puncturing.dump'], 'w');
  DUMP.depuncturing = my_fopen([DUMP.SETTINGS.test_dir '/depuncturing.dump'], 'w');
  % 6. Innner Interleaver
  DUMP.inner_interleave = my_fopen([DUMP.SETTINGS.test_dir '/inner_interleave.dump'], 'w');
  DUMP.inner_deinterleave = my_fopen([DUMP.SETTINGS.test_dir '/inner_deinterleave.dump'], 'w');
  % 7. Mapper
  DUMP.map = my_fopen([DUMP.SETTINGS.test_dir '/map.dump'], 'w');
  DUMP.demap = my_fopen([DUMP.SETTINGS.test_dir '/demap.dump'], 'w');
  % 8. Reference Signals
  DUMP.insert_reference_signals = my_fopen([DUMP.SETTINGS.test_dir '/insert_reference_signals.dump'], 'w');
  DUMP.remove_reference_signals = my_fopen([DUMP.SETTINGS.test_dir '/remove_reference_signals.dump'], 'w');
  % 9. OFDM codec
  DUMP.ofdm_encode = my_fopen([DUMP.SETTINGS.test_dir '/ofdm_encode.dump'], 'w');
  DUMP.ofdm_decode = my_fopen([DUMP.SETTINGS.test_dir '/ofdm_decode.dump'], 'w');
