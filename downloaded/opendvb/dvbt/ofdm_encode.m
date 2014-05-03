%% ofdm_encode OFDM encoder.
%%
%%   y = ofdm_encode(x) performs an inverse FFT to encode samples.
%%   x and y are column vectors of complex values.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : OFDM Encoder
%% Project       : MOUSE
%%
%% File          : ofdm_encode.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.4 $
%%---------------------------------------------------------------------------

function data_out = ofdm_encode (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  m = DVBT_SETTINGS.symbol_length.ad_conv;
  n = DVBT_SETTINGS.symbol_length.fft;
  g = DVBT_SETTINGS.ofdm.guard_length;
  k = DVBT_SETTINGS.ofdm.carrier_count;
  assert (m == n+g, 'ofdm_encode', 'invalid guard length')

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_k, should_be_one] = size (data_in);
  assert (should_be_one == 1, 'ofdm_encode', 'column vector expected');
  assert (should_be_k == k, 'ofdm_encode', ...
          sprintf ('symbol size: %d expected, %d found', ...
                   k, should_be_k));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.sender, '  ofdm_encode (m=%d, n=%d, k=%d)\n', ...
	   m, n, k);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  frequency_domain = zeros(n,1);
  if DVBT_SETTINGS.ofdm.use_fftshift
    frequency_domain(1+(n-k+1)/2:(n+k+1)/2) = data_in;
    time_domain = ifft(fftshift (frequency_domain));
  else
    frequency_domain(1:(k+1)/2) = data_in(1+(k-1)/2:k);
    frequency_domain(1+n-(k-1)/2:n) = data_in(1:(k-1)/2);
    time_domain = ifft (frequency_domain);
  end

  data_out = [ time_domain(1+n-g:n) ; time_domain ];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  raw_data = reshape ([real(data_out)' ; imag(data_out)'], ...
		      2*DVBT_SETTINGS.symbol_length.ad_conv, 1);
  raw_data = DVBT_SETTINGS.refsig.alpha * raw_data;
  fwrite (DUMP.ofdm_encode, raw_data, 'float32');