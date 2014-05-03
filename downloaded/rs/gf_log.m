%% gf_log Galois logarithm function.
%%
%%   c = gf_log(a) returns the logarithm of Galois field element a as
%%   integer.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Galois Fields - Logarithm
%% Project       : MOUSE
%%
%% File          : gf_log.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.3 $
%%---------------------------------------------------------------------------

function result = gf_log (a)

  global GF;

  [m, n] = size (a);
  
  result = zeros (m, n);
  
  for i = 1:m
    for j = 1:n
      if a(i,j) == GF.zero
	result(i,j) = -Inf;
      else
	result(i,j) = GF.log(a(i,j))-1;
      end
    end
  end