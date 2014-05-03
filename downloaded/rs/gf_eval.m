%% gf_eval Evaluate a polynome using Galois-field arithmetics.
%%
%%   y = gf_eval(poly, x) evaluates the polynome stored in the vector
%%   poly at the value x using Galois-field arithmetics.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Galois Fields - Polynome Evaluation
%% Project       : MOUSE
%%
%% File          : gf_eval.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.2 $
%%---------------------------------------------------------------------------

function result = gf_eval (polynome, x)

  global GF;

  result = GF.zero;
  for ii = length(polynome):-1:1
    result = gf_add (gf_mul (result, x), polynome(ii));
  end
  