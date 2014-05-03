%% gf_add Add two elements of a Galois field.
%%
%%   c = gf_add(a,b) adds two numbers a and b using Galois field
%%   arithmetics.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Galois Fields - Addition
%% Project       : MOUSE
%%
%% File          : gf_add.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.3 $
%%---------------------------------------------------------------------------

function result = gf_add (a, b)

  result = bitxor (a,b);
  