%% dvbt_receive_init Close all dump files.
%%
%%   dvbt_receive_init() initializes state of DVB-T reciever
%%   in global DVBT_STATE_RECEIVER to defined values.
%%   This function can also be used to reset the receiver.
%%   It has to be called after global_settings.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : DVB-T Receiver - Initialization
%% Project       : MOUSE
%%
%% File          : dvbt_receive_init.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.1 $
%%---------------------------------------------------------------------------

function dvbt_receive_init ()

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DVBT_SETTINGS;
  global DVBT_STATE_RECEIVER;
  DVBT_STATE_RECEIVER = {};
  
  %% Part 1: MUX adaptation and randomization for energy dispersal
  %% see ETSI EN 300 744, section 4.3.1, p. 11
  DVBT_STATE_RECEIVER.scrambler = {};
  % Contents of PRBS shift register  
  DVBT_STATE_RECEIVER.scrambler.prbs_register = ...
      DVBT_SETTINGS.scrambler.init_prbs_register;
  % Packet counter to apply SYNC inverter and reset PRBS
  DVBT_STATE_RECEIVER.scrambler.packet_count = 0;

  %% Part 3: Outer Interleaver
  %% see ETSI EN 300 744, section 4.3.2, pp. 12
  DVBT_STATE_RECEIVER.outer_interleaver = {};
  switch DVBT_SETTINGS.outer_interleaver.init
    case 'zero'
      DVBT_STATE_RECEIVER.outer_interleaver.queue = ...
	  zeros(DVBT_SETTINGS.outer_interleaver.queue_size,1);
    case 'rand'
      DVBT_STATE_RECEIVER.outer_interleaver.queue = floor ...
	  (rand(DVBT_SETTINGS.outer_interleaver.queue_size,1)*255.9);
    case 'prbs'
      [DVBT_STATE_RECEIVER.outer_interleaver.queue, dont_care] = ...
	  scrambler_prbs (DVBT_SETTINGS.outer_interleaver.queue_size, ...
			  DVBT_SETTINGS.scrambler.init_prbs_register);
    otherwise
      error ('unknown init mode for outer interleaver.');
  end

  %% Byte stream losely coupling Viterbi w. Reed/Solomon
  DVBT_STATE_RECEIVER.byte_stream = [];

  %% Part 4: Convolutional encoder
  %% see ETSI EN 300 744, section 4.3.3, pp. 13
  DVBT_STATE_RECEIVER.convolutional_code = ...
      DVBT_SETTINGS.convolutional_code.init_register;

  %% Frame structure
  %% see ETSI EN 300 744, section 4.5, p. 7
  %% Packet number within super frame
  DVBT_STATE_RECEIVER.n = 0;  
  %% Symbol number within frame, l = 1:68
  DVBT_STATE_RECEIVER.l = 0;
  %% Frame number within super-frame, m = 1:4
  DVBT_STATE_RECEIVER.m = 0;
