%% visualization_settings Settings for Visualization
%%
%%   visualization_settings() initializes constant values and parameters
%%   relevant to visualization into a global data structure
%%   named VISUALIZATION.
  
%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Channel Model
%% Project       : MOUSE
%%
%% File          : visualization_settings.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/12/08 19:29:43 $ by $Author: gordon $
%% Revision      : $Revision: 1.1 $
%%---------------------------------------------------------------------------

function visualization_settings ()

  global VISUALIZATION;
  
  %% Visualization
  VISUALIZATION = {};
  VISUALIZATION.figure = {};
  
  VISUALIZATION.signal = 1;
  VISUALIZATION.figure.signal = 1;

  VISUALIZATION.spectrum = 1;
  VISUALIZATION.figure.spectrum = 2;

  VISUALIZATION.spectrum2 = 1;
  VISUALIZATION.figure.spectrum2 = 3;
