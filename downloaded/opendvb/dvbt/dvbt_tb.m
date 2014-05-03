%% dvbt_tb Testbench for DVB-T Sender and Receiver
%%
%%   This testbench script runs without arguments and checks if the
%%   system of DVB-T sender and receiver works.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : DVB-T Sender/Receiver Testbench
%% Project       : MOUSE
%%
%% File          : dvbt_tb.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/12/08 19:29:43 $ by $Author: gordon $
%% Revision      : $Revision: 1.17 $
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
visualization_settings;
dvbt_send_init;
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

input_file = my_fopen ([DUMP.SETTINGS.ref_dir '/5-superframes/test.ts'], 'r');
%input_file = my_fopen ([DUMP.SETTINGS.ref_dir '/random.ts'], 'r');
%input_file = my_fopen ([DUMP.SETTINGS.ref_dir '/sequence.ts'], 'r');

compare_queue = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('DVB-T send&receive');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while ~ feof (input_file) | ~ isempty (compare_queue)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Read a packet
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if ~ feof (input_file)
    % get an MPEG transport MUX packet into a row vector
    [data_in, count] = fread (input_file, n);
    fprintf (DUMP.main, 'TB: reading block of length %d\n', count);
  else
    count = 0;
  end
  % zero pad packet if necessary
  if count == 0
    data_in = [ DVBT_SETTINGS.scrambler.sync_byte ; zeros(n-1,1) ];
  elseif count < n
    data_in = [ data_in ; zeros(n-count,1) ];
  end
  if count > 0
    % put packet into compare_queue
    if isempty (compare_queue)
      compare_queue = data_in;
    else
      compare_queue = [ compare_queue , data_in ];
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Send a packet
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  data_channel_in = dvbt_send (data_in);
  if ~ isempty (data_channel_in)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Transmit a symbol
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf ('.');
    data_channel_out = channel_model (data_channel_in);
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
        for k = 1:min(packets_in,packets_out)
          fprintf (DUMP.main, 'TB: comparing received packet\n');
          send_packet=compare_queue(:,k);
          receive_packet=data_out(:,k);
	  if all(all(send_packet == receive_packet))
	    fprintf (DUMP.main, 'TB: successfully transmitted %d bytes\n', ...
		     length(receive_packet));
	  else
	    dump_close;
	    error ('transmission error');
	  end
          assert (all(all(send_packet == receive_packet)), ...
		  'dvbt_tb', 'packet transmitted incorrectly.');
        end
        
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Remove packets from compare queue
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if packets_out < packets_in
          compare_queue = compare_queue(:,packets_out+1:packets_in);
        else
          compare_queue = [];
        end
      end
    end
  end  
end
fprintf ('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fclose (input_file);
dump_close;
fprintf ('\nDVB-T works.\n');
