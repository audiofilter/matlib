%% insert_reference_signals Insertion of Reference Signals.
%%
%%   y = insert_reference_signals(x) inserts reference signals,
%%   like pilots and TPS into OFDM symbols. x and y are column
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
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.5 $
%%---------------------------------------------------------------------------

function data_out = insert_reference_signals (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_SENDER;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  n = DVBT_SETTINGS.symbol_length.payload;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_n, should_be_one] = size (data_in);
  assert (should_be_one == 1, 'insert_reference_signals', ...
	  'column vector expected');
  assert (should_be_n == n, ...
	  'insert_reference_signals', ...
          sprintf ('symbol size: %d expected, %d found', ...
                   n, should_be_n));

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.sender, '  insert_reference_signals (n=%d, l=%d, m=%d)\n', ...
           n, DVBT_STATE_SENDER.l, DVBT_STATE_SENDER.m);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  data_out = zeros(DVBT_SETTINGS.ofdm.carrier_count, 1);

  % create a set of pilots
  l=DVBT_STATE_SENDER.l;
  Kmin=0;
  Kmax=DVBT_SETTINGS.ofdm.carrier_count;
  pilot_set = union (DVBT_SETTINGS.refsig.continual_pilots, ...
                     Kmin + 3*rem(l,4) + ...
		     12*(0:(DVBT_SETTINGS.ofdm.carrier_count-12)/12));

  % Insert TPS symbols
  tps_set=DVBT_SETTINGS.refsig.tps;

  % merge data and pilots
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
      data_out(u) = 4/3 * 2 * (0.5 - DVBT_SETTINGS.refsig.w(p));
      pilot = pilot + 1;
    elseif u == t; % it's a TPS signal
      data_out(u) = 2 * (0.5 - DVBT_SETTINGS.refsig.w(p));
      tps = tps + 1;
    else % it's a payload carrier
      data_out(u) = DVBT_SETTINGS.refsig.alpha * data_in(v);
      v = v + 1;
    end
  end
  assert (v == DVBT_SETTINGS.payload_carriers+1, 'insert_reference_signals', ...
	  sprintf ('payload carriers: %d expected, %d found', ...
		   DVBT_SETTINGS.payload_carriers, v-1));
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  raw_data = reshape ([real(data_out)' ; imag(data_out)'], ...
		      2*DVBT_SETTINGS.ofdm.carrier_count, 1);
  fwrite (DUMP.insert_reference_signals, raw_data, 'float32');
