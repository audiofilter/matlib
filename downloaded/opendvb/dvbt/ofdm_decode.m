%% ofdm_decode OFDM decoder.
%%
%%   y = ofdm_decode(x) performs an FFT to decode samples from
%%   digital frontend. x and y are column vectors of complex values.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : OFDM Decoder
%% Project       : MOUSE
%%
%% File          : ofdm_decode.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/12/08 19:29:43 $ by $Author: gordon $
%% Revision      : $Revision: 1.5 $
%%---------------------------------------------------------------------------

function data_out = ofdm_decode (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global VISUALIZATION;  

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  m = DVBT_SETTINGS.symbol_length.ad_conv;
  n = DVBT_SETTINGS.symbol_length.fft;
  g = DVBT_SETTINGS.ofdm.guard_length;
  k = DVBT_SETTINGS.ofdm.carrier_count;
  assert (m == n+g, 'ofdm_decode', 'invalid guard length')

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_m, should_be_one] = size (data_in);
  assert (should_be_one == 1, 'ofdm_decode', 'column vector expected');
  assert (should_be_m == m, 'ofdm_decode', ...
          sprintf ('symbol size: %d expected, %d found', ...
                   m, should_be_m));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '  ofdm_decode (m=%d, n=%d, k=%d)\n', ...
	   m, n, k);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Italian sender seems to have unnormalized data in dump files,
  %% therefore we have to multiply with it before writing.
  raw_data = reshape ([real(data_in)' ; imag(data_in)'], ...
		      2*DVBT_SETTINGS.symbol_length.ad_conv, 1);
  raw_data = DVBT_SETTINGS.refsig.alpha * raw_data;
  fwrite (DUMP.ofdm_decode, raw_data, 'float32');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  time_domain = data_in(1+g:m);

  if DVBT_SETTINGS.ofdm.use_fftshift
    frequency_domain = fftshift (fft (time_domain));
    data_out = frequency_domain(1+(n-k+1)/2:(n+k+1)/2);
  else
    frequency_domain = fft (time_domain);
    data_out = [ frequency_domain(1+n-(k-1)/2:n) ; ...
		frequency_domain(1:(k+1)/2) ];
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %% Visualization
  if VISUALIZATION.spectrum
    figure(VISUALIZATION.figure.spectrum);
    gset title "signal spectrum";
    gplot abs(data_out) title 'abs' with impulses, ...
	arg(data_out) title 'arg' with points;
  end
