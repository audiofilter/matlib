%% inner_deinterleave Inner (block) Deinterleaver.
%%
%%   y = inner_deinterleave(x) performs block deinterleaving on OFDM
%%   symbols for DVB-T receiver. x and y are column vectors of sof
%%   bits.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Inner (Block) Deinterleaver
%% Project       : MOUSE
%%
%% File          : inner_deinterleave.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.6 $
%%---------------------------------------------------------------------------

function [data_out] = inner_deinterleave (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_RECEIVER;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  n = DVBT_SETTINGS.symbol_length.inner_interleaver;
  m = DVBT_SETTINGS.map.bits;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_nm, should_be_m] = size (data_in);
  assert (should_be_nm == n/m, 'inner_deinterleave', ...
	  'invalid block size');
  assert (should_be_m == m, 'inner_deinterleave', ...
	  'invalid number of columns');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '  inner_deinterleave (%d, l=%d)\n', ...
	   n, DVBT_STATE_RECEIVER.l);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fwrite (DUMP.inner_deinterleave, data_in, 'uchar');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  sblock_size=DVBT_SETTINGS.inner_interleaver.block_size*m;
  
  [symbol_size, should_be_log2_qam_mode] = size (data_in);
  num_blocks=symbol_size/DVBT_SETTINGS.inner_interleaver.block_size;
  if rem(symbol_size,sblock_size) ~= 0
    error (sprintf('symbol size %d does not match block size %d\n',...
		   symbol_size, sblock_size));
    return;
  end
  
  data_out = zeros (n, 1);

  % Step 1: Reverse Symbol Interleaver
  y = zeros (n/m, m);
  for i = 1:n/m
    if rem(DVBT_STATE_RECEIVER.l, 2) == 0
      y(i,:) = data_in(1+DVBT_SETTINGS.inner_interleaver.Hq(i),:);
    else
      y(1+DVBT_SETTINGS.inner_interleaver.Hq(i),:) = data_in(i,:);
    end
  end

  for i = 1:num_blocks
    a = y(1+(i-1)*DVBT_SETTINGS.inner_interleaver.block_size:i*DVBT_SETTINGS.inner_interleaver.block_size,:);

    % Step 2: Reverse Bit Interleaver
    b=zeros (DVBT_SETTINGS.inner_interleaver.block_size, m);
    h_param=[0 63 105 42 21 84];
    for e = 0:m-1
      for w = 0:DVBT_SETTINGS.inner_interleaver.block_size-1
        % compute H(e,w)
        h=rem(w+h_param(1+e), DVBT_SETTINGS.inner_interleaver.block_size);
        b(1+h,1+e) = a(1+w,1+e);
      end
    end
    
    % Step 3: Demultiplexer
    a = zeros (DVBT_SETTINGS.inner_interleaver.block_size, m);
    switch DVBT_SETTINGS.map.qam_mode
      case 4
        mapping=[0 1];
      case 16
        mapping=[0 2 1 3];
      case 64
        mapping=[0 2 4 1 3 5];
      otherwise
        fprintf ('inner interleave: QAM mode %g not implemented.\n', DVBT_SETTINGS.map.qam_mode);
        return
    end
    for k = 1:m
      a(:,k) = b(:,1+mapping(k));
    end

    data_out(1+(i-1)*sblock_size:i*sblock_size) =...
        reshape (a', sblock_size, 1);
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
