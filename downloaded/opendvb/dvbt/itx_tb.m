%% itx_tb Tests DVB-T Receiver against the sender of Giuseppe Baruffa.
%%
%%   This testbench script runs without arguments and checks if the
%%   DVB-T receiver works with a of the sender of Giuseppe Baruffa.
%%   Currently, this test does not pass.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Italian Transmitter Testbench
%% Project       : MOUSE
%%
%% File          : itx_tb.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.4 $
%%---------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set system to defined state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization routines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_open;
global_settings;
dvbt_receive_init;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import globals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global DUMP;
global DVBT_SETTINGS;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters and abbreviations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = DVBT_SETTINGS.packet_length.mux;
m = DVBT_SETTINGS.symbol_length.ad_conv;

output_file = my_fopen ([DUMP.SETTINGS.ref_dir '/5-superframes/10_IFFT.ref'], 'r');
input_file = my_fopen ([DUMP.SETTINGS.ref_dir '/5-superframes/test.ts'], 'r');

compare_queue = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('DVB-T receive');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while ~ feof (input_file) | ~ isempty (compare_queue)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Read a packet
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if ~ feof (input_file)
    % get an MPEG transport MUX packet into a row vector
    [data_in, count] = fread (input_file, n);
    fprintf (DUMP.main, 'TB: reading block of length %d\n', count);
    if count > 0
      % zero pad packet if necessary
      if count < n
	data_in = [ data_in ; zeros(n-count,1) ];
      end
      % put packet into compare_queue
      if isempty (compare_queue)
	compare_queue = data_in;
      else
	compare_queue = [ compare_queue , data_in ];
      end
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Transmit a symbol
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf ('.');
  if ~ feof (output_file)
    %% Get symbol from output file
    [raw_data, count] = fread (input_file, 2*m, 'float32', 0, 'ieee-le');
    fprintf (DUMP.main, 'TB: reading symbol of length %d\n', count);
  else
    count = 0;
  end
  % zero pad if necessary
  if count == 0
    raw_data = zeros(2*m,1);
  elseif count < 2*m
    raw_data = [ raw_data ; zeros(2*m-count,1) ];
  end
  % make complex data
  data_channel_out = (raw_data(1:2:2*m-1) + j .* raw_data(2:2:2*m)) ...
      ./ DVBT_SETTINGS.ofdm_mode;

  % Receive packet
  data_out = dvbt_receive (data_channel_out);
  
  if ~ isempty (data_channel_out)
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Receive a packet
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    data_out = dvbt_receive (data_channel_out);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Check received packet
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~ isempty (compare_queue) & ~ isempty (data_out)
      [should_be_n, packets_in] = size(compare_queue);
      assert (should_be_n == n, 'dvbt_tb', 'inconsistent compare queue');
      [should_be_n, packets_out] = size(data_out);
      assert (should_be_n == n, 'dvbt_tb', 'incorrect data output');
      for k = 1:packets_out
	fprintf (DUMP.main, 'TB: comparing received packet\n');
	send_packet=compare_queue(:,k);
	receive_packet=data_out(:,k);
	if all(all(send_packet == receive_packet))
	  fprintf (DUMP.main, 'TB: successfully transmitted %d bytes\n', ...
		   length(receive_packet));
	else
	  error ('transmission error');
	end
	assert (send_packet == receive_packet, 'dvbt_tb', ...
		'packet transmitted incorrectly.');
      end
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Pemove packets from compare queue
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if packets_out < packets_in
	compare_queue = compare_queue(:,packets_out+1:packets_in);
      else
	assert (packets_out == packets_in, 'dbvt_tb', ...
		'more packets received than sent.');
	compare_queue = [];
      end
    end
  end
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fclose (input_file);
fclose (output_file);
dump_close;
fprintf ('\nItalian Sender works.\n');
