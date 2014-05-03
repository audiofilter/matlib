%% remove_reference_signals Removal of Reference Signals.
%%
%%   y = insert_reference_signals(x) removes reference signals,
%%   like pilots and TPS from OFDM symbols. x and y are column
%%   vectors of complex values.

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
%% File          : insert_reference_signals.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/12/08 19:29:43 $ by $Author: gordon $
%% Revision      : $Revision: 1.7 $
%%---------------------------------------------------------------------------

function data_out = remove_reference_signals (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_RECEIVER;
  global VISUALIZATION;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [n, should_be_one] = size (data_in);
  assert (should_be_one == 1, 'remove_reference_signals', ...
	  'column vector expected');
  assert (n == DVBT_SETTINGS.used_carriers, ...
	  'remove_reference_signals', ...
          sprintf ('symbol size: %d expected, %d found', ...
                   DVBT_SETTINGS.used_carriers, n));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '  remove_reference_signals (n=%d, l=%d, m=%d)\n', ...
           n, DVBT_STATE_RECEIVER.l, DVBT_STATE_RECEIVER.m);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  raw_data = reshape ([real(data_in)' ; imag(data_in)'], ...
		      2*DVBT_SETTINGS.ofdm.carrier_count, 1);
  fwrite (DUMP.remove_reference_signals, raw_data, 'float32');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  data_out = zeros(DVBT_SETTINGS.payload_carriers, 1);
  
  % create a set of pilots
  l=DVBT_STATE_RECEIVER.l;
  Kmin=0;
  Kmax=DVBT_SETTINGS.ofdm.carrier_count;
  pilot_set = union (DVBT_SETTINGS.refsig.continual_pilots, ...
                     Kmin + 3*rem(l,4) + ...
		     12*(0:(DVBT_SETTINGS.ofdm.carrier_count-12)/12));

  % Insert TPS symbols
  tps_set=DVBT_SETTINGS.refsig.tps;

  % separate data from pilots and TPS
  v=1; % current input payload carrier index
  pilot=1; % current pilot index in pilot_set
  tps=1; % current tps index in tps_set
  for u = 1:DVBT_SETTINGS.ofdm.carrier_count % for all output carriers
    p = 1+pilot_set(pilot); % get next pilot
    if tps <= length(tps_set) % get next tps
      t = 1+tps_set(tps);
    else
      t = 0;
    end
    
    if u == p % it's a pilot signal
      pilot = pilot + 1;
    elseif u == t; % it's a TPS signal
      tps = tps + 1;
    else % it's a payload carrier
      data_out(v) = data_in(u) / DVBT_SETTINGS.refsig.alpha;
      v = v + 1;
    end
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Visualization
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if VISUALIZATION.spectrum2
    figure(VISUALIZATION.figure.spectrum2);
    gset title "QAM points";
    my_points=[real(data_out) imag(data_out)];
    gplot my_points title 'QAM points' with points;
  end

