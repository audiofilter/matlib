%% dump_close Close all dump files.
%%
%%   dump_close() closes all open dump files.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Dump Files - Close
%% Project       : MOUSE
%%
%% File          : dump_close.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.5 $
%%---------------------------------------------------------------------------

function dump_close ()

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Close all dump files
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % main files
  fclose (DUMP.main);
  fclose (DUMP.sender);
  fclose (DUMP.receiver);
  fclose (DUMP.channel);
  % 1. Scrambler
  fclose (DUMP.scramble);
  fclose (DUMP.descramble);
  % 2. Reed-Solomon
  fclose (DUMP.rs_encode);
  fclose (DUMP.rs_decode);
  % 3. Outer interleaver
  fclose (DUMP.outer_interleave);
  fclose (DUMP.outer_deinterleave);
  % 4. Convolutional codec
  fclose (DUMP.convolutional_encode);
  fclose (DUMP.convolutional_decode);
  % 5. Puncturing
  fclose (DUMP.puncturing);
  fclose (DUMP.depuncturing);
  % 6. Innner Interleaver
  fclose (DUMP.inner_interleave);
  fclose (DUMP.inner_deinterleave);
  % 7. Mapper
  fclose (DUMP.map);
  fclose (DUMP.demap);
  % 8. Reference Signals
  fclose (DUMP.insert_reference_signals);
  fclose (DUMP.remove_reference_signals);
  % 9. OFDM codec
  fclose (DUMP.ofdm_encode);
  fclose (DUMP.ofdm_decode);
