%% global_settings Global Settings and configuration for DVB-T.
%%
%%   global_settings() initializes constant values and parameters
%%   of the DVB-T sender and receiver into a global data structure
%%   named RS.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Global Settings
%% Project       : MOUSE
%%
%% File          : global_settings.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/12/08 19:29:43 $ by $Author: gordon $
%% Revision      : $Revision: 1.22 $
%%---------------------------------------------------------------------------

function global_settings ()

  global RS;
  RS = {};
  
  %% Part 2: Reed/Solomon coding for burst error correction
  %% see ETSI EN 300 744, section 4.3.2, pp. 11
  RS.rs = {};
  %% Based on:  
  %%     8                                           8    4    3    2
  %% GF(2 ), with field generator polynomial p(x) = x  + x  + x  + x  + 1
  gf_init (2, 8, [8 4 3 2 0]);
  % shortened RS(204,188,t=8) code
  rs_init (204,188,8);

