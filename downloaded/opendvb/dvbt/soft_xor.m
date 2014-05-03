%% soft_xor XOR for soft-decision bits.
%%
%%   c = soft_xor(a,b) computes a fuzzy XOR for two soft decision
%%   values a and b. Soft descition values are floats in the range
%%   of [0;1].
  
%%   y = demap(x) demaps a column vector of complex data items
%%   to a squence of soft descision bits. Each value of the input
%%   vector corresponds to a row of bits in the outout matrix.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : XOR for soft-decision bits
%% Project       : MOUSE
%%
%% File          : soft_xor.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.5 $
%%---------------------------------------------------------------------------

function x = soft_xor (a, b)

  if b < 0.5
    x = a;
  elseif a == 0.5
    x = 0.5;
  elseif b > 0.5
    x = 1-a;
  end
