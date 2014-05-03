%% gf_exp Galois exponentiation function.
%%
%%   c = gf_exp(a) raises the primitive element of the Galois field
%%   to the power of the argument a.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Galois Fields - Exponentiation
%% Project       : MOUSE
%%
%% File          : gf_exp.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.2 $
%%---------------------------------------------------------------------------

function result = gf_exp (a)

  global GF;

  [m, n] = size (a);
  
  result = zeros (m, n);
  
  for i = 1:m
    for j = 1:n
      if a(i,j) == -Inf
	result(i,j) = GF.zero;
      else
	result(i,j) = GF.exp(1+rem(a(i,j),GF.q-1));
      end
    end
  end