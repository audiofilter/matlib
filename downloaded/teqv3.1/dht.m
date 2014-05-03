% DHT 1-D discrete Hilbert transform
% function y=dht(x) returns 1-D discrete Hilbert transform
% by using 32768 points fast Fourier transform

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
%Programmers:	Niranjan Damera-Venkata
% Version:        10/12/00	@(#)dht.m	1.2
%
%The authors are with the Department of Electrical and Computer
%Engineering, The University of Texas at Austin, Austin, TX.
%They can be reached at blu@ece.utexas.edu.
%Biao Lu is also with the Embedded Signal Processing
%Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function y=dht(x)

N=32768;

sig(1:(N/2))=sign(linspace(1,(N/2),(N/2)));
sig((N/2)+1)=0;
sig((N/2)+2:N)=sign(linspace(-1,-(N/2)-1,(N/2)-1));
sig(1)=0;

x1=zeros(N,1);
s=size(x);

x1(1:s(2))=x;

mag=abs(fft(x1))+1e-10;

logmag=log(mag);

in=ifft(logmag);

ph=-j*fft(sig'.*in);

rec=mag.*exp(j*ph);

recu=ifft(rec);

y=recu(1:s(2));
