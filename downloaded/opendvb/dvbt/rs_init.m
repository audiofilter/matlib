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
  global DVBT_SETTINGS;

  assert (n >= k+2*t, 'rs', 'length too small');
  assert (t == GF.m, 'rs', 't does not fit m');
  
  % systematic RS(255,239,t=8) code (p. 11)
  DVBT_SETTINGS.rs.SY = {};
  DVBT_SETTINGS.rs.SY.n = GF.q-1; % length
  DVBT_SETTINGS.rs.t = t; % dimension
  DVBT_SETTINGS.rs.SY.k = DVBT_SETTINGS.rs.SY.n - 2*DVBT_SETTINGS.rs.t;
  
  % shortened RS(204,188,t=8) code (p. 12)
  DVBT_SETTINGS.rs.k = k;
  DVBT_SETTINGS.rs.n = n;
  DVBT_SETTINGS.rs.padding = DVBT_SETTINGS.rs.SY.n - DVBT_SETTINGS.rs.n;
  
  % code generator polynomial
  DVBT_SETTINGS.rs.lamda = GF.alpha;

  % roots of generator polynomial
  DVBT_SETTINGS.rs.r = zeros (2*t,1);
  raised_lamda = GF.one;
  for k = 1:2*t
    DVBT_SETTINGS.rs.r(k) = raised_lamda;
    raised_lamda = gf_mul (raised_lamda, DVBT_SETTINGS.rs.lamda);    
  end
  
  DVBT_SETTINGS.rs.g = zeros (2*t+1,1);
  DVBT_SETTINGS.rs.g(1) = GF.one;
  for k = 1:2*t
    %                 k-1
    % g(x) := (x+lamda   ) g(x)

    DVBT_SETTINGS.rs.g(k+1) = GF.one;
    for r = k:-1:2
      DVBT_SETTINGS.rs.g(r) = ...
	  gf_add (DVBT_SETTINGS.rs.g(r-1), ...
		  gf_mul (DVBT_SETTINGS.rs.r(k), ...
			  DVBT_SETTINGS.rs.g(r)));
    end
    DVBT_SETTINGS.rs.g(1) = gf_mul(DVBT_SETTINGS.rs.r(k), ...
                                   DVBT_SETTINGS.rs.g(1));
  end

