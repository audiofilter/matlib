% $Id: eval_adjust.m,v 1.2 1997/09/04 17:20:50 kirke Exp kirke $
% Plot Mean/Variance of error for TR vs SNR or frequency error, etc
%clear all;
%clf;
pn = 1;
lag = input('Method  0 sinc, 1 Lagrange, 2 windowed sinc ','s');
over = 4;
TX_M = 12*over + 1;
RX_M = 8*over + 1
alpha = 0.18
freq_off = 0.0;  % 10% frequency error wrt IF
freq = 0; %pi/2*(1+freq_off);
% Receiver RC Filter used in calc_err
rcf = src(alpha,over,RX_M);
norm = sqrt(sum(rcf*rcf'));
orig_rcf = rcf/norm;

% Interpolator size
sinc_size = 33;
np = 4;

% Timing/phase quantization
t_inc = 0.5/np;
tx_time_off = -t_inc;

% Quantize coefficients
coef_bits = 10
coeflev = 2^(coef_bits-1);

for l=1:np
  tx_time_off = tx_time_off + t_inc;
  src_offset = tx_time_off; % offset timing error!
  t_adj = tx_time_off;
  [init_phase,rcv,tx_rcf] = sim_tx(1000,over,TX_M,alpha,freq,pn,src_offset);
  %  sim_init;

  d1 = zeros(1,5);
  d2 = zeros(1,3);
  ang = 0;
  ang1 = 0;

  ainterp_dly = zeros(1,sinc_size+4);
  alinterp = zeros(1,sinc_size);
  xinterp = zeros(1,sinc_size+4);
  
  lagr_size = 4;
  interp_dly = zeros(1,lagr_size+5) + i*zeros(1,lagr_size+5);
  linterp = zeros(1,lagr_size+1)+i*zeros(1,lagr_size+1);
  intepr = zeros(1,lagr_size+5)+i*zeros(1,lagr_size+5);

  err_acc = 0;
  lp_out = 0;

  symcount = 0;
  sq_err = 0;
  rcv_data = 0;
  ierr = 0;
  qerr = 0;
  if (lag == '1')
    disp('Lagrange');
    ang2 = 0;
    init_ang2 = init_phase-(t_adj*freq);
    for j=1:size(rcv,2)
	  %%      dw_rcv = 2*(real(rcv(j)))*exp(-i*ang2);
      interp_dly = [2*real(rcv(j)) interp_dly(1:lagr_size+4)];
      linterp = lagrange(t_adj,lagr_size);
      interp = [ 0 0 0 linterp 0 ];
      new_rcv = interp_dly*interp';
	  %%      new_rcv = (new_rcv*exp(i*ang2));
      ang2 = ang2 + freq;
      if (ang2 > 2*pi) 
		ang2 = ang2 - 2*pi;
      end
      nrcv(j) = new_rcv*exp(-i*(ang2+(pi/2+init_ang2)));
    end
	%    sample_offset = 1;
    sample_offset = 1;
  elseif (lag == '0')
    disp('Sinc');
    ang2 = 0;
    init_ang2 = init_phase-(t_adj*freq);
    % Move outside of loop
    alinterp = sinc_off(1,sinc_size,-t_adj);
    xinterp = [ 0 0 0 alinterp 0];
    % end move
    for j=1:size(rcv,2)
      ainterp_dly = [2*real(rcv(j)) ainterp_dly(1:sinc_size+3)];
      new_rcv = ainterp_dly*xinterp';
      ang2 = ang2 + freq;
      if (ang2 > 2*pi) 
		ang2 = ang2 - 2*pi;
      end
      nrcv(j) = new_rcv*exp(-i*(ang2+init_ang2));
    end
    sample_offset = 3;
  elseif (lag == '2')
    disp('Sinc with Chebyshev window');
    ang2 = 0;
    init_ang2 = init_phase-(t_adj*freq);
    % Move outside of loop
    s = sinc_off(1,sinc_size,-t_adj);
    w = inihsin2(sinc_size,40,t_adj);
    for t=1:sinc_size
      alinterp(t) = floor(s(t)*w(t)*coeflev)/coeflev;
    end
    xinterp = [ 0 0 0 alinterp 0];
    % end move
    for j=1:size(rcv,2)
      ainterp_dly = [2*real(rcv(j)) ainterp_dly(1:sinc_size+3)];
      new_rcv = ainterp_dly*xinterp';
      ang2 = ang2 + freq;
      if (ang2 > 2*pi) 
		ang2 = ang2 - 2*pi;
      end
      nrcv(j) = new_rcv*exp(-i*(ang2+init_ang2));
    end
    sample_offset = 4;
	%    if (mod(sinc_size,2) == 0) sample_offset = 2; end
  else
    disp('Lagrange at IF!');
    ang2 = 0;
    init_ang2 = init_phase-(t_adj*freq);
    interp_dly = zeros(1,2*lagr_size+1) + i*zeros(1,2*lagr_size+1);
    linterp = zeros(1,2*lagr_size+1)+i*zeros(1,2*lagr_size+1);
    intepr = zeros(1,2*lagr_size+1)+i*zeros(1,2*lagr_size+1);
    for j=1:size(rcv,2)
      interp_dly = [(rcv(j)) interp_dly(1:2*lagr_size+1)];
      linterp = lagrange(t_adj,lagr_size);
      for kk=1:lagr_size+1
		ifinterp(2*kk) = linterp(kk)*(-1)^kk;
      end
      new_rcv = interp_dly*ifinterp';
	  %%      new_rcv = (new_rcv*exp(i*ang2));
      ang2 = ang2 + freq;
      if (ang2 > 2*pi) 
		ang2 = ang2 - 2*pi;
      end
      nrcv(j) = new_rcv*exp(-i*(ang2+(pi/2+init_ang2)));
    end
	%    sample_offset = 1;
    sample_offset = 1;
  end

  calc_err; % Calculate loss;
			%  save_ang(l) = oang;
			
			e(l) = rms_err;
			f(l) = tx_time_off;
			grid;
			%  pause(1);
end
figure;
plot(f,20*log10(e),'x-');
title('RMS error vs timing offset');
grid;



