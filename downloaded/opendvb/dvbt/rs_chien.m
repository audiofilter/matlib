%% rs_chien Reed/Somomon, Chien Search.
%%
%%   [nulls, fail] = rs_chien (locator, num_errors)
%%   computes the zeros of the error locator polynome.
%%   fail indicates that the errors can not be corrected.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Reed/Somomon - Chien Search
%% Project       : MOUSE
%%
%% File          : rs_chien.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.6 $
%%---------------------------------------------------------------------------

function [nulls, fail] = rs_chien (locator, num_errors)

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
  assert (should_be_one == 1, 'rs_chien', 'column vector expected');
  assert (should_be_2t == 2*t, 'rs_chien', ...
          sprintf ('locator size: %d expected, %d found', ...
                   2*t, should_be_2t));
  fail = 0;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '    rs_chien(num_errors=%d)\n', num_errors);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions

  % find nulls of locator polynome
  result = find (gf_eval (locator, GF.nz) == GF.zero);

  nulls=zeros(t,1); % actually: zeros(num_errors,1)
  nulls(:) = GF.one;
  if length(result) ~= num_errors
    fail = 1;
  else
    nulls(1:length(result))=result;    
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '      rs_chien: nulls = [');
  for p = 1:num_errors
    fprintf (DUMP.receiver, '%d', nulls(p));
    if p < num_errors
      fprintf (DUMP.receiver, '; ');
    end
  end
  fprintf (DUMP.receiver, '];\n');
