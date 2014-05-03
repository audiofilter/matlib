%% global_settings Global Settings and configuration for DVB-T.
%%
%%   global_settings() initializes constant values and parameters
%%   of the DVB-T sender and receiver into a global data structure
%%   named DVBT_SETTINGS.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Global Settings
%% Project       : MOUSE
%%
%% File          : global_settings.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/12/08 19:29:43 $ by $Author: gordon $
%% Revision      : $Revision: 1.22 $
%%---------------------------------------------------------------------------

function global_settings ()

  global DVBT_SETTINGS;
  DVBT_SETTINGS = {};
  
  %% Part 1: MUX adaptation and randomization for energy dispersal
  %% see ETSI EN 300 744, section 4.3.1, p. 11
  DVBT_SETTINGS.scrambler = {};
  % Value of SYNC byte
  DVBT_SETTINGS.scrambler.sync_byte = hex2dec('47');
  % Value of inverted SYNC byte: /SYNC
  DVBT_SETTINGS.scrambler.inv_sync_byte = ...
      255 - DVBT_SETTINGS.scrambler.sync_byte;
  % Initial contents of shift register of
  % pseudo random binary sequence (PRBS) generator
  DVBT_SETTINGS.scrambler.init_prbs_register = ...
      [1 0 0 1 0 1 0 1 0 0 0 0 0 0 0];
  % PRBS period in packets
  DVBT_SETTINGS.scrambler.prbs_period = 8;

  %% Part 2: Reed/Solomon coding for burst error correction
  %% see ETSI EN 300 744, section 4.3.2, pp. 11
  DVBT_SETTINGS.rs = {};
  %% Based on:  
  %%     8                                           8    4    3    2
  %% GF(2 ), with field generator polynomial p(x) = x  + x  + x  + x  + 1
  gf_init (2, 8, [8 4 3 2 0]);
  % shortened RS(204,188,t=8) code
  rs_init (204,188,8);

  %% Part 3: Outer interleaver (convolutional interleaver)
  %% see ETSI EN 300 744, section 4.3.2, pp. 12
  DVBT_SETTINGS.outer_interleaver = {};
  %% Froney/Ramsey type III approach
  DVBT_SETTINGS.outer_interleaver.i = 12;
  DVBT_SETTINGS.outer_interleaver.m = 17; % 12*17 = 204
  assert (DVBT_SETTINGS.outer_interleaver.i * ...
	  DVBT_SETTINGS.outer_interleaver.m == DVBT_SETTINGS.rs.n, ...
	  'outer_interleaver', 'i*m should be n');
  DVBT_SETTINGS.outer_interleaver.queue_size = ...
      DVBT_SETTINGS.outer_interleaver.i^2 ...
      * DVBT_SETTINGS.outer_interleaver.m;
  DVBT_SETTINGS.outer_interleaver.init = 'zero';

  %% Part 4: Convolutional encoder
  %% see ETSI EN 300 744, section 4.3.3, pp. 13
  viterbi_init;

  %% Part 5: Pucturing
  %% see ETSI EN 300 744, section 4.3.3, pp. 13
  DVBT_SETTINGS.puncturing = {};
  DVBT_SETTINGS.puncturing.mode = 2/3;

  %% section 4.4: OFDM frame structure (pp. 24)
  DVBT_SETTINGS.ofdm_mode = 2048;
  DVBT_SETTINGS.payload_carriers = 1512;  
  DVBT_SETTINGS.used_carriers = 1705;
  DVBT_SETTINGS.symbols_per_frame = 68;
  DVBT_SETTINGS.frames_per_superframe = 4;  

  %% Part 6: Inner interleaver (block interleaver)
  %% see ETSI EN 300 744, section 4.3.4, pp. 14
  DVBT_SETTINGS.inner_interleaver = {};
  %% block size for bit interleaver (p. 17)
  DVBT_SETTINGS.inner_interleaver.block_size = 126;
  %% number of groups from bit interleaver processed by symbol
  %% interleaver in one step
  DVBT_SETTINGS.inner_interleaver.groups = ...
      DVBT_SETTINGS.ofdm_mode / DVBT_SETTINGS.inner_interleaver.block_size;
  %% compute permutation table H(q) (pp. 19)
  Nmax = DVBT_SETTINGS.payload_carriers;
  Mmax = DVBT_SETTINGS.ofdm_mode;
  Nr = log2(Mmax);
  DVBT_SETTINGS.inner_interleaver.Hq = zeros(Nmax,1);
  qq = 0;
  switch DVBT_SETTINGS.ofdm_mode
    case 2048
      perm_table=[4 3 9 6 2 8 1 5 7 0];
    case 8192
      perm_table=[7 1 4 2 9 6 8 10 0 3 11 5];
    otherwise
      error ('unsupported OFDM mode');
  end
  for ii = 0:Mmax-1
    % compute Ri
    switch ii
      case 0
        r1 = zeros (1, Nr-1);
      case 1
        r1 = zeros (1, Nr-1);
      case 2
        r1 = zeros (1, Nr-1);
        r1(1) = 1;
      otherwise
        r1 = [r1(2:Nr-1) , xor(r1(1+0), r1(1+3))];
    end
    r = zeros(1, Nr-1);
    for k = 0:Nr-2
      r(1+perm_table(1+k)) = r1(1+k);
    end
    % compute H(q)
    DVBT_SETTINGS.inner_interleaver.Hq(1+qq) = rem(ii,2) * 2^(Nr-1);
    for jj = 0:Nr-2
      DVBT_SETTINGS.inner_interleaver.Hq(1+qq) = ...
	  DVBT_SETTINGS.inner_interleaver.Hq(1+qq) + r(1+jj) * 2^jj;
    end
    if DVBT_SETTINGS.inner_interleaver.Hq(1+qq) < Nmax
      qq = qq + 1;
    end
  end

  %% Part 7: Mapper
  %% see ETSI EN 300 744, section 4.3.5, pp. 20
  DVBT_SETTINGS.map = {};
  %% QAM-Mode (set 4 for QPSK)
  DVBT_SETTINGS.map.qam_mode = 16;
  DVBT_SETTINGS.map.alpha = 1;
  %% Use Soft-Bits
  DVBT_SETTINGS.map.use_softbits = 0;
  %% derived settings
  DVBT_SETTINGS.map.bits = log2 (DVBT_SETTINGS.map.qam_mode);
  switch DVBT_SETTINGS.map.qam_mode
    case 4
      DVBT_SETTINGS.map.bit_ordering = 1:2;
      assert (DVBT_SETTINGS.map.alpha == 1.0, 'map', ...
	      'only alpha=1 supported for QPSK');
    case 16
      DVBT_SETTINGS.map.bit_ordering = 1:4;
    case 64
      DVBT_SETTINGS.map.bit_ordering = 1:6;
    otherwise
      error (sprintf ('unsupported QAM mode %d', ...
		      DVBT_SETTINGS.map.qam_mode));      
  end
  switch DVBT_SETTINGS.map.alpha
    case 1
      DVBT_SETTINGS.map.offset = 0;
    case 2
      DVBT_SETTINGS.map.offset = 1;
    case 4
      DVBT_SETTINGS.map.offset = 3;
    otherwise
      error (sprintf ('unsupported alpha=%d for QAM-%d', ...
		      DVBT_SETTINGS.map.alpha, ...
		      DVBT_SETTINGS.map.qam_mode));
  end
  
  %% Part 8: Reference Signals
  %% See ETSI EN 300 744, section 4.5, pp. 26
  DVBT_SETTINGS.refsig = {};
  %% Normalization factor for data symbols (Table 6, p. 26)
  DVBT_SETTINGS.refsig.alpha = 1/sqrt(10);
  %% section 4.5.2: PRBS as reference sequence (pp.26)
  DVBT_SETTINGS.refsig.w = zeros(1,DVBT_SETTINGS.used_carriers);
  reg = ones(1,11);
  for k = 1:DVBT_SETTINGS.used_carriers
    DVBT_SETTINGS.refsig.w(k) = reg(11);
    new_bit = xor (reg(9), reg(11));
    reg = [ new_bit reg(1:10) ];
  end
  %% section 4.5.3: scattered pilot cells (p. 27)
  DVBT_SETTINGS.refsig.scattered_pilots_period = 4;
  %% section 4.5.4: continual pilot cells (Table 7, p. 28)
  DVBT_SETTINGS.refsig.continual_pilots = ...
      [ 0 48 54 87 141 156 192 201 255 279 282 333 432 450 ...
       483 525 531 618 636 714 759 765 780 804 873 888 918 ...
       939 942 969 984 1050 1101 1107 1110 1137 1140 1146 ...
       1206 1269 1323 1377 1491 1683 1704];
  %% section 4.6: transmission parameter signaling (TPS)
  %% (Table 8, p. 29)
  DVBT_SETTINGS.refsig.tps = ...
      [34 50 209 346 413 569 595 688 790 901 ...
       1073 1219 1262 1286 1469 1594 1687];
  
  %% Part 9: OFDM encoding using FFT
  DVBT_SETTINGS.ofdm = {};
  DVBT_SETTINGS.ofdm.mode = DVBT_SETTINGS.ofdm_mode;
  DVBT_SETTINGS.ofdm.carrier_count = DVBT_SETTINGS.used_carriers;
  DVBT_SETTINGS.ofdm.guard_interval = 1/4;
  DVBT_SETTINGS.ofdm.guard_length = ...
      DVBT_SETTINGS.ofdm.guard_interval * DVBT_SETTINGS.ofdm.mode;
  % use fftshift function
  DVBT_SETTINGS.ofdm.use_fftshift = 1;
  
  %% Packet lengths
  DVBT_SETTINGS.packet_length = {};
  DVBT_SETTINGS.packet_length.mux = DVBT_SETTINGS.rs.k;
  DVBT_SETTINGS.packet_length.rs = DVBT_SETTINGS.rs.n;
  DVBT_SETTINGS.packet_length.outer_interleaver = DVBT_SETTINGS.rs.n;

  %% OFDM Symbol lengths
  DVBT_SETTINGS.symbol_length = {};
  DVBT_SETTINGS.symbol_length.bit_stream = ...
      DVBT_SETTINGS.payload_carriers*DVBT_SETTINGS.map.bits ...
      * DVBT_SETTINGS.puncturing.mode;
  DVBT_SETTINGS.symbol_length.inner_interleaver = ...
      DVBT_SETTINGS.payload_carriers*DVBT_SETTINGS.map.bits;
  DVBT_SETTINGS.symbol_length.payload = DVBT_SETTINGS.payload_carriers;
  DVBT_SETTINGS.symbol_length.ofdm = DVBT_SETTINGS.ofdm.carrier_count;
  DVBT_SETTINGS.symbol_length.fft = DVBT_SETTINGS.ofdm.mode;  
  DVBT_SETTINGS.symbol_length.ad_conv = ...
      DVBT_SETTINGS.ofdm.guard_length + DVBT_SETTINGS.symbol_length.fft;
  