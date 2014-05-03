%% rs_berlekamp_massey Reed/Somomon, Berlekamp/Massey Algorithm.
%%
%%   [locator, num_errors, fail] = rs_berlekamp_massey (syndrome)
%%   determines the locator polynome from the error syndrome.
%%   num_errors returns the number of errors found.
%%   fail indicates that the errors can not be corrected.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Reed/Somomon - Berlekamp/Massey
%% Project       : MOUSE
%%
%% File          : rs_berlekamp_massey.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.6 $
%%---------------------------------------------------------------------------

function [locator, num_errors, fail] = rs_berlekamp_massey (syndrome)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global GF;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  t = DVBT_SETTINGS.rs.t;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_2t, should_be_one] = size (syndrome);
  assert (should_be_one == 1, 'rs_berlekamp_massey', 'column vector expected');
  assert (should_be_2t == 2*t, 'rs_berlekamp_massey', ...
          sprintf ('syndrome size: %d expected, %d found', ...
                   2*t, should_be_2t));
  fail = 0;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '    rs_berlekamp_massey\n');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions

  % Block 1: Initialization
  % locator polynome := 1
  locator = zeros (2*t, 1);
  locator(:) = GF.zero;
  locator(1) = GF.one;
  num_errors = 0;

  % auxiliary polnome := 0
  aux = zeros(2*t,1); % Hilfspolynom
  aux(:) = GF.zero;

  for jj = 1:2*t
    % Block 2: Compute Discrepancy
    discrepancy = syndrome(jj);
    for mu = 1:num_errors
      discrepancy = gf_add (discrepancy, ...
			    gf_mul (locator(mu+1), syndrome(jj-mu)));
    end

    if discrepancy ~= GF.zero
      % Block 3: Adjust locator
      old_locator=locator;
      locator = gf_add (locator, gf_mul (discrepancy, aux));

      if 2*num_errors < jj
	% Block 4: Adjust B
	aux = gf_mul (gf_inv(discrepancy), old_locator);
	num_errors = jj - num_errors;
      end
    end
    
    assert (aux(2*t) == GF.zero | jj == 2*t, 'rs_berlekamp_massey', ...
	    'auxiliary polynome overflow');
    aux = [0 ; aux(1:2*t-1)];
  end

  if num_errors > t
    fail = 1;
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, ...
	   '      rs_berlekamp_massey: locator(deg=%d) = [', ...
	   num_errors);
  for p = 1:2*t
    fprintf (DUMP.receiver, '%d', locator(p));
    if p < 2*t
      fprintf (DUMP.receiver, '; ');
    end
  end
  fprintf (DUMP.receiver, '];\n');
  