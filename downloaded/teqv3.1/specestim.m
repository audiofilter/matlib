%SPECESTIM Frequency spectrum estimation.
% [Sx, Sn, Sh] = SPECESTIM(X, N, H, NN) returns the frequency
% spectrum of the transmitted data in Sx, the channel noise
% in Sn and the magnitude square frequency response of the channel 
% in Sh.
%
% X is the transmitted data vector. N is the channel noise vector.
% H is the channel impulse response. NN is the FFT size in the
% discrete multitone modulation.

% Copyright (c) 1999-2003 The University of Texas
% All Rights Reserved.
%  
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%  
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%  
% The GNU Public License is available in the file LICENSE, or you
% can write to the Free Software Foundation, Inc., 59 Temple Place -
% Suite 330, Boston, MA 02111-1307, USA, or you can find it on the
% World Wide Web at http://www.fsf.org.
%  
% Programmers:	Guner Arslan
% Version:        @(#)specestim.m	1.3	07/26/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [Sx, Sn, Sh] = specestim(x,n,h,N,bf)

% open a figure for progress bar
%if bf == 1
   [figHndl statusHndl] = setprogbar('Estimating frequency spectra ...');     
   %end
% length of x
M = length(x);
% estimate input spectrum using N-point FFT
%Px = (abs(mean(fft(reshape(x,N,M/N)).')).^2)/N;
Px = psd(x,N,'hamming',N/2); 
Sx = Px.';
%Px = spectrum(x,N);  
% update progress bar
if bf ==1
   updateprogbar(statusHndl,1,4);
end
% remove the conjugate symmetric part

%Sx = Px(1:N/2+1);

% estimate noise spectrum using N-point FFT
%Pn = (abs(mean(fft(reshape(n,N,M/N)).')).^2)/N;
%Pn = spectrum(n,N);  
Pn = psd(n,N,'hamming',N/2); 
% update progress bar
if bf ==1
   updateprogbar(statusHndl,2,4);
end
% remove the conjugate symmetric part
%Sn = Pn(1:N/2+1);
Sn = Pn.';
% calculate the channel frequency response using N-point FFT
Fh = fft(h,N);
% update progress bar
if bf ==1 
   updateprogbar(statusHndl,3,4);
end
% remove the conjugate symmetric part
Ph = Fh(1:N/2+1); 
% magnitude square
Sh = (abs(Ph).^2).';
% don't use the DC and Nyquist bands 
%Sh(1) = 0;
%Sh(N/2+1) = 0;
% update progress bar
%if bf ==1
   updateprogbar(statusHndl,4,4);
   close(figHndl);
   %end


