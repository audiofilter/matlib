%% puncturing Puncture send data after convolutional encoding.
%%
%%   data = puncturing (x, y) assembles a sequential column vector
%%   by pucturing the two input vectors x and y, which were created
%%   by convolutional encoding.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Puncturing
%% Project       : MOUSE
%%
%% File          : puncturing.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.5 $
%%---------------------------------------------------------------------------

function data = puncturing (x, y)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  n = DVBT_SETTINGS.symbol_length.bit_stream;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_n, should_be_one] = size (x);
  assert (should_be_one == 1, 'puncturing', 'column vector expected');
  assert (should_be_n == n, 'puncturing', ...
          sprintf ('symbol size: %d expected, %d found', ...
                   n, should_be_n));
  [should_be_n, should_be_one] = size (y);
  assert (should_be_one == 1, 'puncturing', 'column vector expected');
  assert (should_be_n == n, 'puncturing', 'x and y size do not match');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.sender, '  puncturing (%d)\n', n);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  switch DVBT_SETTINGS.puncturing.mode
    case 1/2
      data=zeros(2*n,1);
      for i = 1:n
        data(2*(i-1)+1) = x(i);
        data(2*(i-1)+2) = y(i);
      end
    case 2/3
      data=zeros(3*n/2,1);
      for i = 1:2:n
        data(3*(i-1)/2+1) = x(i);
        data(3*(i-1)/2+2) = y(i);
        data(3*(i-1)/2+3) = y(i+1);
      end
    otherwise
      error (sprintf ('puncturing mode %g not implemented.\n', ...
		      DVBT_SETTINGS.puncturing.mode));
      return
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fwrite (DUMP.puncturing, data, 'uchar');