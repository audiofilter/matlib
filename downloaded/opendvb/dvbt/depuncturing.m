%% depuncturing Depuncture recieved input data for convolutional decoder.
%%
%%   [x, y] = depuncturing(data) reconstructs the convolutional encoding
%%   vectors x and y for use with convolutional_decode from a data stream
%%   of soft bits in the range of [0;1]. Punctured data values are assumed
%%   to have value 0.5.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Depuncturing
%% Project       : MOUSE
%%
%% File          : depuncturing.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.5 $
%%---------------------------------------------------------------------------

function [x, y] = depuncturing (data)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations & Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  [n, should_be_one] = size (data);
  assert (should_be_one == 1, 'depuncturing', 'column vector expected');

  m = DVBT_SETTINGS.puncturing.mode * n;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '  depuncturing (%d)\n', n);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fwrite (DUMP.depuncturing, data, 'uchar');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  switch DVBT_SETTINGS.puncturing.mode
    case 1/2
      x=zeros(m,1);
      y=zeros(m,1);

      for i = 1:m
        x(i) = data(2*(i-1)+1);
        y(i) = data(2*(i-1)+2);
      end
      
    case 2/3
      x=zeros(m,1);
      y=zeros(m,1);

      for i = 1:2:m
        x(i+0) = data(3*(i-1)/2+1);
        x(i+1) = 0.5;
        y(i+0) = data(3*(i-1)/2+2);
        y(i+1) = data(3*(i-1)/2+3);
      end

    otherwise
      error (sprintf ('puncturing mode %g not implemented.\n', ...
		      DVBT_SETTINGS.puncturing.mode));
      return
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
