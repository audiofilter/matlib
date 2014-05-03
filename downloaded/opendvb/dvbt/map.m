%% map Performs OFDM/QAM mapping.
%%
%%   y = map(x) maps a column vector of bits to a sequence of complex
%%   data items. Each row of the output matrix corresponds to a value
%%   in the input matrix.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : OFDM Mapper
%% Project       : MOUSE
%%
%% File          : map.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.5 $
%%---------------------------------------------------------------------------

function data_out = map (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_SENDER;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  m = DVBT_SETTINGS.map.bits;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [n, should_be_m] = size (data_in);
  assert (should_be_m == m, ...
	  'map', 'invalid number of bits');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.sender, '  map (%dx%d)\n', n, m);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  data_out = zeros(n,1);
  for ii = 1:n
    bits = data_in(ii,:);

    symbol = [0 0];
    for jj = 1:2:m
      bit1 = bits(DVBT_SETTINGS.map.bit_ordering(jj));
      bit2 = bits(DVBT_SETTINGS.map.bit_ordering(jj+1));

      pair = [1 1] - 2*[bit1 bit2];

      if symbol == 0
	symbol = pair;
      else
	symbol = (pair + [2 2]) .* symbol;
      end
    end
    
    % add offset for non-uniform mapping
    symbol = symbol ...
	+ DVBT_SETTINGS.map.offset .* sign(symbol);
    
    data_out(ii) = symbol * [1 ; 1i];
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  raw_data = reshape ([real(data_out)' ; imag(data_out)'], ...
		      2*DVBT_SETTINGS.symbol_length.payload, 1);
  fwrite (DUMP.map, raw_data, 'float32');