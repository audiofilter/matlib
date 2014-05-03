% example for design of phase equalizer using Remez algorithm and
% overdetermined linear equations. Allpass degree is n. lowpass degree is 7. 
%

%File Name: exampl3.m
%Last Modification Date: %G%	%U%
%Current Version: %M%	%I%
%File Creation Date: Tue Mar  1 09:19:55 1994
%Author: Markus Lang  <lang@jazz.rice.edu>
%
%Copyright: All software, documentation, and related files in this distribution
%           are Copyright (c) 1994  Rice University
%
%Permission is granted for use and non-profit distribution providing that this
%notice be clearly maintained. The right to distribute any portion for profit
%or as part of any commercial product is specifically reserved for the author.
%
%Change History:
%

n = 6;                                              % allpass degree

[a,b] = ellip(7,.08,60,.25);                        % elliptical lowpass design
[H,w] = freqz(a,b,1024);                            % frequency response
om_index = 1:.25*1024+1;                            
om = w(om_index);                                   % passband

buw_ell = unwrap(angle(H(om_index)));               % unwrapped phase 
grp_ell = grpdelay(a,b,1024);                       % GRPD

% plot of magnitude, phase, and group delay (GRPD) response
figure(1); clf;
subplot(221);  plot(w/pi,20*log10(abs(H)));
title('magnitude (ell.)')
subplot(222);  plot(w/pi,grp_ell);
title('GRPD (ell)')

subplot(223)

% phase approximation/equalization using a generalized nonlinear Remez algorithm
[p_c,tau_c] = apdesz(buw_ell, 1, om, n, 0, 0, 't');

title('phase error (ch -, l2 .)')

figure(1); subplot(224);
grp_equ_c = grpdelay(rot90(p_c,2),p_c,1024);
plot(w/pi,grp_equ_c + grp_ell);

title('equal. GRPD (ch -, l2 .)')

% phase approximation/equalization using the LSEE approach
subplot(223); hold on;
[p_l2,tau_l2] = ap_lgs_z(buw_ell, 1, om, n, 0, 0, 't');
hold off

figure(1); subplot(224);
grp_equ_l2 = grpdelay(rot90(p_l2,2),p_l2,1024);
hold on
plot(w/pi,grp_equ_l2 + grp_ell,'.');
hold off


