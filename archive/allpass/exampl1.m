
% example for design of parallel allpass filters allpass (degree n) + delay
% (degree m) according to the L_oo norm
%


%File Name: exampl1.m
%Last Modification Date: %G%	%U%
%Current Version: %M%	%I%
%File Creation Date: Tue Oct 12 11:10:54 1993
%Author: Markus Lang  <lang@dsp.rice.edu>
%
%Copyright: All software, documentation, and related files in this distribution
%           are Copyright (c) 1993  Rice University
%
%Permission is granted for use and non-profit distribution providing that this
%notice be clearly maintained. The right to distribute any portion for profit
%or as part of any commercial product is specifically reserved for the author.
%
%Change History:
%

n = 13;  m = n-1;
 
omp = .4*pi;  oms = .5*pi;    % pass- and stopband frequency
devp = .01;  devs =.004;      % desired deviations in (only the quotient
                              % devp/devs is kept)

np = 200;  ns = 200;          % # of pts - 1 in pass-/stopband

omp = [0:np]/np*omp;  oms = [0:ns]/ns*(pi-oms)+oms;  

om = [omp oms];

bw = [omp*m oms*m+pi];

t = [ones(1,np+1)*devp ones(1,ns+1)*devs];

H = [ones(1,np) zeros(1,ns)];
[p,delta,w,eb] = apparz(bw,1,om,n,t,H,'u');

figure(1); subplot(111); clf; 
[H,w] = freqz(rot90(p,2),p,1024);
delay = exp(-j*w*m);
plot(w/pi,abs(H+delay)/2, w/pi,abs(H-delay)/2,'.')
title('magnitude response of paral. allpass, - lowpass, .highpass')
