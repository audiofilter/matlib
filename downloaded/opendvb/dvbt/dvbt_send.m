%% dvbt_send DVB-T Sender.
%%
%%   y = dvbt_send(x) produces a colum vector y of compley A/D converter
%%   outputs for a column vector of bytes x of a MPEG transport multiplex
%%   packet. Due to different block sizes of MPEG packets and OFDM symbols,
%%   the function can also return an empty vector.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : DVB-T Sender
%% Project       : MOUSE
%%
%% File          : dvbt_send.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.12 $
%%---------------------------------------------------------------------------

function data_channel_in = dvbt_send (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_SENDER;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  len_packet = DVBT_SETTINGS.packet_length.mux;
  len_symbol = DVBT_SETTINGS.symbol_length.bit_stream;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_len_packet, num_packets] = size (data_in);
  assert (should_be_len_packet == len_packet, 'dvbt_send', ...
          sprintf ('packet size: expected %d, found %d', ...
                   len_packet, should_be_len_packet));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf(DUMP.main, 'S: sending %d packets.\n', num_packets);
  fprintf(DUMP.sender, 'sending %d packets.\n', num_packets);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions

  % Process MPEG transport MUX packets
  for k = 1:num_packets
    data=data_in(:,k);
  
    data = scramble (data);
    data = rs_encode (data);
    data = outer_interleave (data);

    % put data into bit_stream
    data = reshape(de2bi(data, 8, 'left-msb')', ...
		   8*DVBT_SETTINGS.packet_length.outer_interleaver,1);
    if isempty (DVBT_STATE_SENDER.bit_stream)
      DVBT_STATE_SENDER.bit_stream = data;
    else
      DVBT_STATE_SENDER.bit_stream = ...
          [ DVBT_STATE_SENDER.bit_stream ; data ];
    end
    % increment packet counter
    DVBT_STATE_SENDER.n = DVBT_STATE_SENDER.n + 1;
  end

  % convert MUX packets into OFDM symbols
  [num_bits, should_be_one] = size (DVBT_STATE_SENDER.bit_stream);
  assert (isempty (DVBT_STATE_SENDER.bit_stream) | should_be_one == 1, ...
          'dvbt_send', 'inconsistent bit stream');
  num_symbols = floor (num_bits/len_symbol);
  ofdm_symbols = zeros (len_symbol, num_symbols);
  for k = 1:num_symbols
    ofdm_symbols(:,k) = DVBT_STATE_SENDER.bit_stream...
        (1+(k-1)*len_symbol:k*len_symbol);
  end
  if ~ isempty (DVBT_STATE_SENDER.bit_stream)
    DVBT_STATE_SENDER.bit_stream = DVBT_STATE_SENDER.bit_stream...
        (1+num_symbols*len_symbol:num_bits);
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf(DUMP.main, 'S: sending %d symbols.\n', num_symbols);
  fprintf(DUMP.sender, 'sending %d symbols.\n', num_symbols);

  % Process OFDM symbols
  data_channel_in = [];
  for k = 1:num_symbols
    data = ofdm_symbols(:,k);
    
    [x, y] = convolutional_encode (data);
    data = puncturing (x, y);
    [symbols] = inner_interleave (data);
    data = map (symbols);
    data = insert_reference_signals (data);
    data = ofdm_encode(data);

    % put data into channel
    if isempty (data_channel_in)
      data_channel_in = data;
    else
      data_channel_in = [ data_channel_in , data ];
    end
    % increment symbol counters
    DVBT_STATE_SENDER.l = DVBT_STATE_SENDER.l + 1;
    if DVBT_STATE_SENDER.l >= DVBT_SETTINGS.symbols_per_frame
      assert (DVBT_STATE_SENDER.l == DVBT_SETTINGS.symbols_per_frame, ...
	      'dvbt_send', 'invalid frame state');
      DVBT_STATE_SENDER.l = 0;
      DVBT_STATE_SENDER.m = DVBT_STATE_SENDER.m + 1;
      if DVBT_STATE_SENDER.m >= DVBT_SETTINGS.frames_per_superframe
	assert (DVBT_STATE_SENDER.m == DVBT_SETTINGS.frames_per_superframe, ...
		'dvbt_send', 'invalid frame state');
	DVBT_STATE_SENDER.m = 0;
	% also reset packet counter
	DVBT_STATE_SENDER.n = 0;
	assert (isempty(DVBT_STATE_SENDER.bit_stream), 'dvbt_send', ...
		'invalid frame parameters');
      end
    end
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
