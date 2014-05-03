%% inner_interleave Inner (block) Interleaver.
%%
%%   y = inner_interleave(x) performs block interleaving on OFDM
%%   symbols for DVB-T receiver. x and y are column vectors of sof
%%   bits.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Inner (Block) Interleaver
%% Project       : MOUSE
%%
%% File          : inner_interleave.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.6 $
%%---------------------------------------------------------------------------

function [data_out] = inner_interleave (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_SENDER;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  n = DVBT_SETTINGS.symbol_length.inner_interleaver;
  m = DVBT_SETTINGS.map.bits;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_n, should_be_one] = size (data_in);
  assert (should_be_n == n, 'inner_interleave', ...
	  'invalid block size');
  assert (should_be_one == 1, 'inner_interleave', ...
	  'column vector expected');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.sender, '  inner_interleave (%d, L=%d)\n', ...
	   n, DVBT_STATE_SENDER.l);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  sblock_size=DVBT_SETTINGS.inner_interleaver.block_size*m;
  
  [symbol_size, should_be_one] = size (data_in);
  num_blocks=symbol_size/sblock_size;
  if rem(symbol_size,sblock_size) ~= 0
    error (sprintf ('symbol size %d does not match block size %d\n',...
		    symbol_size, sblock_size));
    return;
  end

  y = zeros (n/m, m);
  for i = 1:num_blocks
    x=data_in(1+(i-1)*sblock_size:i*sblock_size);

    % Step 1: Demultiplexer
    a=reshape (x, m, DVBT_SETTINGS.inner_interleaver.block_size)';
    b=zeros (DVBT_SETTINGS.inner_interleaver.block_size, m);
    
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

    b(:,1+mapping) = a;
    
    [should_be_ii_block_size, should_be_log2_qam_mode] = size (b);

    % Step 2: Bit Interleaver
    a=zeros (DVBT_SETTINGS.inner_interleaver.block_size, m);
    h_param=[0 63 105 42 21 84];
    for e = 0:m-1
      for w = 0:DVBT_SETTINGS.inner_interleaver.block_size-1
        % compute H(e,w)
        h=rem(w+h_param(1+e), DVBT_SETTINGS.inner_interleaver.block_size);
        a(1+w,1+e)=b(1+h,1+e);
      end
    end

    y(1+(i-1)*DVBT_SETTINGS.inner_interleaver.block_size:i*DVBT_SETTINGS.inner_interleaver.block_size,:) = a;
  end
  
  % Step 3: Symbol Interleaver
  data_out = zeros (n/m, m);
  for i = 1:n/m
    if rem(DVBT_STATE_SENDER.l, 2) == 0
      data_out(1+DVBT_SETTINGS.inner_interleaver.Hq(i),:) = y(i,:);
    else
      data_out(i,:) = y(1+DVBT_SETTINGS.inner_interleaver.Hq(i),:);
    end
  end  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fwrite (DUMP.inner_interleave, data_out, 'uchar');