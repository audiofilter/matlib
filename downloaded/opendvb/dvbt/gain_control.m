%% gain_control Gain control part of digital frontend of DVB-T receiver.
%%
%%   y = gain_control(x) performs automated gain control on a column
%%   vector of complex input samples x from the A/D converter.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Digital Frontend - Automated Gain Control
%% Project       : MOUSE
%%
%% File          : gain_control.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.3 $
%%---------------------------------------------------------------------------

function output = gain_control (input)

  %% currently this module does nothing.
  output = input;