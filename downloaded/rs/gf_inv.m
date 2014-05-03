%% gf_inv Multiplicative inverse in Galois arithmetics.
%%
%%   c = gf_inv(a) returns the multiplicative inverser using Galois field
%%   arithmetics.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Galois Fields - Multiplicative Inverse
%% Project       : MOUSE
%%
%% File          : gf_inv.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.3 $
%%---------------------------------------------------------------------------

function result = gf_inv (a)

  global GF;
  
  result = gf_exp((GF.q-1) - gf_log(a));
