%% sample_rate_conversion Sample rate conversion part of digital frontend of DVB-T receiver.
%%
%%   y = sample_rate_conversion(x) converts the sample rate of the A/D
%%   converter to that used by the OFDM code.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Digital Frontend - Sample Rate Conversion
%% Project       : MOUSE
%%
%% File          : sample_rate_conversion.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.2 $
%%---------------------------------------------------------------------------

function output = sample_rate_conversion (input)

  %% currently this module does nothing.
  output = input;