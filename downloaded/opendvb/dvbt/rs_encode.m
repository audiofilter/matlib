%% rs_decode Reed/Somomon Encoder.
%%
%%   y = rs_decode(x) encodes a MPEG transport multiplex packet
%%   using the Reed/Solomon algorithm. x and y are column vectors
%%   of Galois field elements.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Reed/Somomon - Encoder
%% Project       : MOUSE
%%
%% File          : rs_encode.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.10 $
%%---------------------------------------------------------------------------

function data_out = rs_encode (data_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_SENDER;
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
  [should_be_k, should_be_one] = size (data_in);
  assert (should_be_one == 1, 'rs_encode', 'column vector expected');
  assert (should_be_k == k, 'rs_encode', ...
          sprintf ('packet size: %d expected, %d found', ...
                   k, should_be_k));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.sender, '  rs_encode. (n=%d, k=%d)\n', n, k);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  parity=zeros(2*t,1);
  parity(:)=GF.zero;
  for index = 1:k
    feedback = gf_add (data_in(index), parity(1));

    parity = gf_add ([parity(2:2*t) ; 0], ...
		     gf_mul (feedback, ...
			     DVBT_SETTINGS.rs.g(2*t:-1:1)));
  end
  
  data_out = [ data_in ; parity ];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.sender, '    rs_encode: parity = [');
  for p = 1:2*t
    fprintf (DUMP.sender, '%d', parity(p));
    if p < 2*t
      fprintf (DUMP.sender, '; ');
    end
  end
  fprintf (DUMP.sender, '];\n');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fwrite (DUMP.rs_encode, data_out, 'uchar');