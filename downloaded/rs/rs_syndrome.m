%% rs_syndrome Reed/Somomon, Berlekamp/Massey Algorithm.
%%
%%   syndrome = rs_syndrome (data_in) computes the error syndrome
%%   of data_in. A zero syndrome means that the transmission was
%%   error free.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Reed/Somomon - Syndrome Calculation
%% Project       : MOUSE
%%
%% File          : rs_syndrome.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.5 $
%%---------------------------------------------------------------------------

function syndrome = rs_syndrome (data_in);

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
  fprintf (DUMP.receiver, '    rs_syndrome. (n=%d, k=%d)\n', n, k);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions

  syndrome = gf_eval (data_in(n:-1:1), DVBT_SETTINGS.rs.r);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '      rs_syndrome: syndrome = [');
  for p = 1:2*t
    fprintf (DUMP.receiver, '%d', syndrome(p));
    if p < 2*t
      fprintf (DUMP.receiver, '; ');
    end
  end
  fprintf (DUMP.receiver, '];\n');
