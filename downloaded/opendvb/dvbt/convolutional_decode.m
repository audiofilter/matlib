%% convolutional_decode Convolutional decoder.
%%
%%   data = convolutional_decode (x,y) decodes a soft decision
%%   data stream, consisting of the two vectors x and y.
%%   x and y have to be colum vectors of the same length, containing
%%   data items in the range [0,1], using 0.5 for unknown values created
%%   by puncturing.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Convolutional Decoder
%% Project       : MOUSE
%%
%% File          : convolutional_decode.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.11 $
%%---------------------------------------------------------------------------

function data = convolutional_decode (x, y)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  global DVBT_SETTINGS;
  global DVBT_STATE_RECEIVER;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Abbreviations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  m = DVBT_SETTINGS.convolutional_code.m;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [n, should_be_one] = size (x);
  assert (should_be_one == 1, ...
	  'convolutional_decode', 'column vector expected');
  [should_be_n, should_be_one] = size (y);
  assert (should_be_one == 1, ...
	  'convolutional_decode', 'column vector expected');
  assert (should_be_n == n, ...
	  'convolutional_decode', 'size of x and y do not match');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf (DUMP.receiver, '  convolutional_decode (%d)\n', n);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Data dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fwrite (DUMP.convolutional_decode, [x y], 'uchar');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  if DVBT_SETTINGS.convolutional_code.use_kammeyer
    
    x_hat = viterbi(1-2*reshape([x y]', 2*n, 1), ...
		    DVBT_SETTINGS.convolutional_code.trellis, ...
		    0, 0, 5*DVBT_SETTINGS.convolutional_code.m);
    data = x_hat;

  else

    data=zeros(n,1);
    for k = 1:n
      data_x = x(k);
      for v = DVBT_SETTINGS.convolutional_code.mother_x
	data_x = soft_xor(data_x, DVBT_STATE_RECEIVER.convolutional_code(v));
      end
      
      data_y = y(k);
      for v = DVBT_SETTINGS.convolutional_code.mother_y
	data_y = soft_xor(data_y, DVBT_STATE_RECEIVER.convolutional_code(v));
      end
      
      if data_x == 0.5 & data_y == 0.5
	fprintf(DUMP.receiver, 'warning: undefined symbol %d\n', k);
      end
      if (data_x < 0.5 & data_y > 0.5) ...
            | (data_x > 0.5 & data_y < 0.5)
	fprintf(DUMP.receiver, 'warning: contradicting symbol %d\n', k);
      end
      
      if data_x < 0.5 | data_y < 0.5
	data(k) = 0;
      elseif data_x > 0.5 | data_y > 0.5
	data(k) = 1;
      else
	fprintf(DUMP.main, 'error: error at symbol %d\n', k);      
      end
      
      DVBT_STATE_RECEIVER.convolutional_code = ...
	  [data(k) DVBT_STATE_RECEIVER.convolutional_code(1:m-1)];
    end

  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
