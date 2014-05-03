%% demap Performs OFDM/QAM demapping.
%%
%%   y = demap(x) demaps a column vector of complex data items
%%   to a squence of soft descision bits. Each value of the input
%%   vector corresponds to a row of bits in the outout matrix.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : OFDM Demapper
%% Project       : MOUSE
%%
%% File          : demap.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.7 $
%%---------------------------------------------------------------------------

function data_out = demap (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_RECEIVER;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  m = DVBT_SETTINGS.map.bits;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [n, should_be_one] = size (data_in);
  assert (should_be_one == 1, ...
	  'map', 'column vector expected');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '  demap (%d)\n', n);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  raw_data = reshape ([real(data_in)' ; imag(data_in)'], ...
		      2*DVBT_SETTINGS.symbol_length.payload, 1);
  fwrite (DUMP.demap, raw_data, 'float32');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  data_out = zeros(n,m);
  for ii = 1:n
    symbol = [real(data_in(ii)) imag(data_in(ii))];
    bits = zeros(1,m);

    % remove offset of non-uniform mapping
    symbol = symbol ...
	- DVBT_SETTINGS.map.offset .* sign(symbol);
    
    weight = 2^(DVBT_SETTINGS.map.bits/2-1);
    confidence = 2^(DVBT_SETTINGS.map.bits/2-1);
    for jj = 1:2:m
      bit1 = -0.5*(symbol(1) / confidence) + 0.5;
      bit2 = -0.5*(symbol(2) / confidence) + 0.5;

      bits(DVBT_SETTINGS.map.bit_ordering(jj)) = bit1;
      bits(DVBT_SETTINGS.map.bit_ordering(jj+1)) = bit2;

      symbol = abs(symbol) - weight;
      weight = weight / 2;
    end
    
    data_out(ii,:) = bits;    
  end

  if ~ DVBT_SETTINGS.map.use_softbits
    data_out = data_out >= 0.5;
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
