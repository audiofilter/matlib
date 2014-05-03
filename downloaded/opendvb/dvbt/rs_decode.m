%% rs_decode Reed/Somomon Decoder.
%%
%%   y = rs_decode(x) decodes a MPEG transport multiplex packet
%%   using the Reed/Solomon algorithm. x and y are column vectors
%%   of Galois field elements.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Reed/Somomon - Decoder
%% Project       : MOUSE
%%
%% File          : rs_decode.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.13 $
%%---------------------------------------------------------------------------

function data_out = rs_decode (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global GF;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  k = DVBT_SETTINGS.rs.k;
  n = DVBT_SETTINGS.rs.n;
  t = DVBT_SETTINGS.rs.t;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_n, should_be_one] = size (data_in);
  assert (should_be_one == 1, 'rs_decode', 'column vector expected');
  assert (should_be_n == n, 'rs_decode', ...
          sprintf ('packet size: %d expected, %d found', ...
                   n, should_be_n));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '  rs_decode. (n=%d, k=%d)\n', n, k);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fwrite (DUMP.rs_decode, data_in, 'uchar');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  data_out = data_in(1:k);

  % calculate syndromes and stop processing in case of no error
  syndrome = rs_syndrome (data_in);
  if all(syndrome == GF.zero)
    
    fprintf (DUMP.receiver, '    rs_decode: no error correction necessary\n');
    
  else

    data = data_in;
    
    [locator, num_errors, fail] = rs_berlekamp_massey (syndrome);
    if ~ fail
      [nulls, fail] = rs_chien (locator, num_errors);
      if ~ fail
	[data, fail] = rs_forney (data, syndrome, locator, num_errors, nulls);
      end
    end
    if fail
      fprintf (DUMP.receiver, '    rs_decode: error correction failed\n');
    else
      fprintf (DUMP.receiver, '    rs_decode: error correction successful\n');
    end

    data_out = data(1:k);
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
