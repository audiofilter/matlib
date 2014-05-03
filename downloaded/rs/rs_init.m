%% rs_init Initialize Reed/Solomon Encoder and Decoder.
%%
%%   rs_init(n,k,t) initializes a global data structure with the
%%   parameters of the Reed/Solomon encoder and decoder.
%%   This function is called by global_settings.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Galois Fields - Initialization
%% Project       : MOUSE
%%
%% File          : gf_init.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.7 $
%%---------------------------------------------------------------------------

function rs_init (n, k, t)

  global GF;
  global RS;

%  assert (n >= k+2*t, 'rs', 'length too small');
%  assert (t == GF.m, 'rs', 't does not fit m');
  
  % systematic RS(255,239,t=8) code (p. 11)
  RS.SY = {};
  RS.SY.n = GF.q-1; % length
  RS.t = t; % dimension
  RS.SY.k = RS.SY.n - 2*RS.t;
  
  % shortened RS(204,188,t=8) code (p. 12)
  RS.k = k;
  RS.n = n;
  RS.padding = RS.SY.n - RS.n;
  
  % code generator polynomial
  RS.lamda = GF.alpha;

  % roots of generator polynomial
  RS.r = zeros (2*t,1);
  raised_lamda = GF.one;
  for k = 1:2*t
    RS.r(k) = raised_lamda;
    raised_lamda = gf_mul (raised_lamda, RS.lamda);    
  end
  
  RS.g = zeros (2*t+1,1);
  RS.g(1) = GF.one;
  for k = 1:2*t
    %                 k-1
    % g(x) := (x+lamda   ) g(x)

    RS.g(k+1) = GF.one;
    for r = k:-1:2
      RS.g(r) = ...
	  gf_add (RS.g(r-1), ...
		  gf_mul (RS.r(k), ...
			  RS.g(r)));
    end
    RS.g(1) = gf_mul(RS.r(k), ...
                                   RS.g(1));
  end

