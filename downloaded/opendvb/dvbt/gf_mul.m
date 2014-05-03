%% gf_mul Multiplies two elements of a Galois field.
%%
%%   c = gf_mul(a,b) multiplies two numbers a and b using Galois field
%%   arithmetics.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Galois Fields - Multiplication
%% Project       : MOUSE
%%
%% File          : gf_mul.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.5 $
%%---------------------------------------------------------------------------

function result = gf_mul (a,b)

  global GF;

  result = gf_exp(gf_log(a) + gf_log(b));
