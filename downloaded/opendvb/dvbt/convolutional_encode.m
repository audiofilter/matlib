%% convolutional_encode Convolutional decoder.
%%
%%   [x, y] = convolutional_encode (data) encodes a data vector
%%   with a convolutional code. data needs to be a column vector,
%%   x and y contains the unpunctured output vectors of the
%%   same dimensions than data.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Convolutional Encoder
%% Project       : MOUSE
%%
%% File          : convolutional_encode.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.10 $
%%---------------------------------------------------------------------------

function [x, y] = convolutional_encode (data)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_SENDER;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  m = DVBT_SETTINGS.convolutional_code.m;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [n, should_be_one] = size (data);
  assert (should_be_one == 1, ...
	  'convolutional_encode', 'column vector expected');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.sender, '  convolutional_encode (%d)\n', n);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  if DVBT_SETTINGS.convolutional_code.use_kammeyer
    
    [data_out, last_state, x_tail] = conv_encoder ...
	(data, DVBT_SETTINGS.convolutional_code.g, 0, 0);
    
    x = data_out(1:2:2*n-1);
    y = data_out(2:2:2*n);

  else
    
    x=zeros(n,1);
    y=zeros(n,1);
    for k = 1:n
      data_in=data(k);
      
      x(k) = data_in;
      for v = DVBT_SETTINGS.convolutional_code.mother_x
	x(k) = xor(x(k), DVBT_STATE_SENDER.convolutional_code(v));
      end
      
      y(k) = data_in;
      for v = DVBT_SETTINGS.convolutional_code.mother_y
	y(k) = xor(y(k), DVBT_STATE_SENDER.convolutional_code(v));
      end
      
      DVBT_STATE_SENDER.convolutional_code = ...
	  [data_in DVBT_STATE_SENDER.convolutional_code(1:m-1)];
    end

  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fwrite (DUMP.convolutional_encode, [x y], 'uchar');