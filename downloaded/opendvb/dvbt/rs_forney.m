%% rs_forney Reed/Somomon, Forney Algorithm.
%%
%%   [data_out, fail] = rs_forney (data_in, syndrome, locator, num_errors, nulls)
%%   performs error correction using Forney's algorithm.
%%   fail indicates that the errors can not be corrected.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Reed/Somomon - Forney
%% Project       : MOUSE
%%
%% File          : rs_forney.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.4 $
%%---------------------------------------------------------------------------

function [data_out, fail] = rs_forney (data_in, syndrome, locator, num_errors, nulls)

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
  n = DVBT_SETTINGS.rs.n;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_2t, should_be_one] = size (locator);
  assert (should_be_one == 1, 'rs_forney', 'column vector expected');
  assert (should_be_2t == 2*t, 'rs_forney', ...
          sprintf ('locator size: %d expected, %d found', ...
                   2*t, should_be_2t));
  fail = 0;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '    rs_forney\n');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions

  data_out = data_in;

  % Step 1: calculate T
  evaluator=zeros(num_errors,1);
  for jj = 1:num_errors
    for mu = 1:jj
      evaluator(jj) = gf_add(evaluator(jj), ...
			     gf_mul (locator(mu), ...
				     syndrome(jj-mu+1)));
    end
  end

  % Step 2: calculate C'
  locator_deriv = gf_mul (rem((1:num_errors)', GF.p), ...
			  locator(2:num_errors+1));

  % Calculate error positions
  factors = gf_inv (nulls);
  error_pos = gf_log (factors);

  % Calculate error magnituges
  nominators = gf_eval (evaluator, nulls);
  denominators = gf_eval (locator_deriv, nulls);
  assert (all(denominators ~= GF.zero), 'rs_forney', 'zero denominator');
  error_mag = gf_mul (gf_mul (nominators, ...
			      gf_inv (denominators)), ...
		      factors);

  % Step 3: correct errors
  for index = 1:num_errors
    if error_pos(index) < n
      data_out(n-error_pos(index)) = gf_add (data_out(n-error_pos(index)), ...
					     error_mag(index));
      fprintf (DUMP.receiver, '        correcting data[%d]: %d->%d\n', ...
	       n-error_pos(index), ...
	       data_in(n-error_pos(index)), ...
	       data_out(n-error_pos(index)));
    else
      fail = 1;
      fprintf (DUMP.receiver, '        rs_forney: position=%d out of range\n', ...
	       error_position);
      break;
    end
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
