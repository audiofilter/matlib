%% dvbt_receive DVB-T Receiver.
%%
%%   y = dvbt_receive(x) receives MPEG-2 transport MUX packets
%%   from A/D converter data. x is a column vector of complex sample
%%   values, y is a matrix of column vectors of MPEG-2 transport packets.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : DVB-T Receiver
%% Project       : MOUSE
%%
%% File          : dvbt_receive.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/12/08 19:29:43 $ by $Author: gordon $
%% Revision      : $Revision: 1.12 $
%%---------------------------------------------------------------------------

function data_out = dvbt_receive (data_channel_out)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_RECEIVER;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  len_packet = DVBT_SETTINGS.packet_length.rs;
  len_symbol = DVBT_SETTINGS.symbol_length.ad_conv;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_len_symbol, num_symbols] = size (data_channel_out);
  assert (should_be_len_symbol == len_symbol, 'dvbt_receive', ...
          sprintf ('symbol length: expected %d, found %d', ...
                   len_symbol, should_be_len_symbol));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf(DUMP.main, 'R: recieving %d symbols.\n', num_symbols);
  fprintf(DUMP.receiver, 'recieving %d symbols.\n', num_symbols);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions

  % Process OFDM symbols
  for k = 1:num_symbols
    data=data_channel_out(:,k);

    data = digital_frontend (data);
    data = ofdm_decode (data);
    data = remove_reference_signals (data);
    [symbols] = demap (data);
    data = inner_deinterleave (symbols);
    [x, y] = depuncturing (data);
    data = convolutional_decode (x, y);

    % put data into byte_stream
    data = bi2de (reshape(data, 8, DVBT_SETTINGS.symbol_length.bit_stream/8)', ...
		  'left-msb');
    if isempty (DVBT_STATE_RECEIVER.byte_stream)
      DVBT_STATE_RECEIVER.byte_stream = data;
    else
      DVBT_STATE_RECEIVER.byte_stream = ...
          [ DVBT_STATE_RECEIVER.byte_stream ; data ];
    end
  end

  % convert OFDM symbols into MUX packets
  [num_bytes, should_be_one] = size (DVBT_STATE_RECEIVER.byte_stream);
  assert (isempty (DVBT_STATE_RECEIVER.byte_stream) | should_be_one == 1, ...
          'dvbt_receive', 'inconsistent byte stream');
  num_packets=floor (num_bytes/len_packet);
  packets=zeros(len_packet,num_packets);
  for k = 1:num_packets
    packets(:,k) = DVBT_STATE_RECEIVER.byte_stream...
        (1+(k-1)*len_packet:k*len_packet);
  end
  if ~ isempty (DVBT_STATE_RECEIVER.byte_stream)
    DVBT_STATE_RECEIVER.byte_stream = DVBT_STATE_RECEIVER.byte_stream...
        (1+num_packets*len_packet:num_bytes);
  end

  % increment symbol counters
  DVBT_STATE_RECEIVER.l = DVBT_STATE_RECEIVER.l + 1;
  if DVBT_STATE_RECEIVER.l >= DVBT_SETTINGS.symbols_per_frame
    assert (DVBT_STATE_RECEIVER.l == DVBT_SETTINGS.symbols_per_frame, ...
	    'dvbt_receive', 'invalid frame state');
    DVBT_STATE_RECEIVER.l = 0;
    DVBT_STATE_RECEIVER.m = DVBT_STATE_RECEIVER.m + 1;
    if DVBT_STATE_RECEIVER.m >= DVBT_SETTINGS.frames_per_superframe
      assert (DVBT_STATE_RECEIVER.m == DVBT_SETTINGS.frames_per_superframe, ...
	      'dvbt_receive', 'invalid frame state');
      DVBT_STATE_RECEIVER.m = 0;
      % also reset packet counter
      DVBT_STATE_RECEIVER.n = 0;
      assert (isempty(DVBT_STATE_RECEIVER.byte_stream), 'dvbt_receive', ...
	      'invalid frame parameters');
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf(DUMP.main, 'R: recieving %d packets.\n', num_packets);
  fprintf(DUMP.receiver, 'recieving %d packets.\n', num_packets);

  % Process MPEG transport MUX packets
  data_out = [];
  for k = 1:num_packets
    data = packets(:,k);
    
    data = outer_deinterleave (data);
    data = rs_decode (data);
    data = descramble (data);

    % put data into output
    if isempty (data_out)
      data_out = data;
    else
      data_out = [ data_out , data];
    end

    % increment packet counter
    DVBT_STATE_RECEIVER.n = DVBT_STATE_RECEIVER.n + 1;
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

