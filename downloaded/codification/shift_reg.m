function [PnSeqOut, ShiftRegState] = shift_reg(connections,ShiftRegState, NumChips)

% Usage: [PnSeqOut, ShiftRegState] = shift_reg(connections,ShiftRegState, NumChips)
%
% This function acts as a shift register sequence generator
% Inputs:
%   CharPoly      = Characteristic Polynomial of PN code
%   ShiftRegState = State of the shift register before clocking.
%   NumChips      = Number of chips to compute of PN sequence
%
% Outputs:
%   PnSeqOut      = Vector holding NumChips of PN sequence
%   ShiftRegState = New State of the shift Register
% 
% Example: Create a m sequence that repeats every 2^5-1 bits
%   connections   = [ 1 4 ]
%   ShiftRegState = [ 1 0 0 0 0];        
%
% Original author: N.S. Correal
% For academic use only

PnSeqOut = zeros(1,NumChips);
OutputBit = length(ShiftRegState);  % index to ShR output

CharPoly = bin_state(0,OutputBit);

for i=1:length(connections)
  CharPoly = CharPoly+bin_state(2^(OutputBit-connections(i)),OutputBit);
end

CharPoly = ~ ~ CharPoly;

for chip = 1:NumChips
  Feedback = rem(sum(CharPoly.*ShiftRegState),2); % Feedback Bit
  PnSeqOut(chip) = ShiftRegState(OutputBit); 
  ShiftRegState = [  Feedback ShiftRegState(1:(OutputBit-1)) ];
end

end

  
