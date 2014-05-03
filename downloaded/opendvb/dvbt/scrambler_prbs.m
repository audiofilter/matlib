%% scrambler_prbs Pseudo Random Bit Sequence for use of Scrambler.
%%
%%   [byte_sequence, state_out] = scrambler_prbs (byte_length, state_in)
%%   returns a pseudo random byte sequence of requested length.
%%   The state of the feedback register is passed through state_in and
%%   state_out.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Scrambler - Pseudo Random Bit Sequence
%% Project       : MOUSE
%%
%% File          : scrambler_prbs.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.5 $
%%---------------------------------------------------------------------------

function [byte_sequence, state_out] = scrambler_prbs (byte_length, state_in)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Global declarations
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global DUMP;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parameter checking
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [should_be_one, r] = size (state_in);  
  assert (should_be_one == 1, 'scramble', 'row vector expected');
  assert (r == 15, 'scramble', 'inconsistent prbs state');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Debugging dump
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf(DUMP.main, '\tscrambler_prbs. (n=%d)\n', byte_length);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Perform actions
  bit_length = 8 * byte_length;
  shift_register = state_in;
  
  bit_sequence=zeros(bit_length,1);
  for i = 1:bit_length
    new_bit = xor (shift_register(14), shift_register(15));
    shift_register = [new_bit shift_register(1:14)];
    bit_sequence(i) = new_bit;
  end

  byte_sequence = bi2de(reshape(bit_sequence, 8, byte_length)', 'left-msb');
  state_out = shift_register;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
