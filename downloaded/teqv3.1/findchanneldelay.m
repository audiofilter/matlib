% delay = findchanneldelay(h, win_len)
%
% h: channel impulse response 
% window_length: window length for sliding energy calculation
% delay:  channel delay
%
%Copyright (c) 1999-2003 The University of Texas
%All Rights Reserved.
% 
%This program is free software; you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation; either version 2 of the License, or
%(at your option) any later version.
% 
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
% 
%The GNU Public License is available in the file LICENSE, or you
%can write to the Free Software Foundation, Inc., 59 Temple Place -
%Suite 330, Boston, MA 02111-1307, USA, or you can find it on the
%World Wide Web at http://www.fsf.org.
% 
%Programmers:	Ming Ding
% Version:        01/15/02	@(#)findchanneldelay.m	1.0
%
%The authors are with the Department of Electrical and Computer
%Engineering, The University of Texas at Austin, Austin, TX.
%They can be reached at ming@ece.utexas.edu.
%Ming Ding is also with the Embedded Signal Processing
%Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function delay = findchanneldelay(h, win_len)

delay=0;
eng_win=0;

for i=1:(length(h)-win_len+1)
	tmp = sum(h(i:i+win_len-1).^2);
	if (tmp >= eng_win)
		eng_win = tmp;
		delay = i-1;
	end
end
