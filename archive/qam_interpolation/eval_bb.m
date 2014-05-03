%clear all;
%clf;
pn = 1;
%lag = input('Method  0 sinc, 1 Lagrange, 2 windowed sinc, 3 RC ','s');
lag = '3';
over = 4;
TX_M = 12*over + 2;
alpha = 0.2;

% Interpolator size
sinc_size = 33;
np = 1;

% Timing/phase quantization
t_inc = 0.5/np;
tx_time_off = -t_inc;

% Quantize coefficients
coef_bits = 10;
coeflev = 2^(coef_bits-1);

for l=1:np+1
  tx_time_off = tx_time_off + t_inc;
  src_offset = tx_time_off; % offset timing error!
  t_adj = tx_time_off;
  [rcv,rcf] = tx_rc(1000,over,TX_M,alpha,0,pn,src_offset);

  ainterp_dly = zeros(1,sinc_size+4);
  alinterp = zeros(1,sinc_size);
  xinterp = zeros(1,sinc_size+4);
  
  lagr_size = 4;
  interp_dly = zeros(1,lagr_size+5) + i*zeros(1,lagr_size+5);
  linterp = zeros(1,lagr_size+1)+i*zeros(1,lagr_size+1);
  intepr = zeros(1,lagr_size+5)+i*zeros(1,lagr_size+5);

  if (lag == '1')
%    disp('Lagrange');
    ref = 1.026; % -0.001;
    for j=1:size(rcv,2)
      interp_dly = [2*real(rcv(j)) interp_dly(1:lagr_size+4)];
      linterp = lagrange(t_adj,lagr_size);
      interp = [ 0 0 0 linterp 0 ];
      nrcv(j) = interp_dly*interp';
    end
	%    sample_offset = 1;
    sample_offset = 1;
  elseif (lag == '0')
%    disp('Sinc');
    % Move outside of loop
    ref = 1.026; % -0.001;
    alinterp = sinc_off(1,sinc_size,-t_adj);
    xinterp = [ 0 0 0 alinterp 0];
    % end move
    for j=1:size(rcv,2)
      ainterp_dly = [2*real(rcv(j)) ainterp_dly(1:sinc_size+3)];
      nrcv(j) = ainterp_dly*xinterp';
    end
    sample_offset = 3;
  elseif (lag == '3')
%    disp('RC');
    ref = 1.0;
    % Move outside of loop
    alinterp = 0.25*rc_off(alpha,3,sinc_size,-t_adj)/(1.0-0.228);
    xinterp = [ 0 0 0 alinterp 0];
    % end move
    for j=1:size(rcv,2)
      ainterp_dly = [2*real(rcv(j)) ainterp_dly(1:sinc_size+3)];
      nrcv(j) = ainterp_dly*xinterp';
    end
    sample_offset = 2;
  elseif (lag == '2')
    ref = 0.99; % -0.001;
%    disp('Sinc with Chebyshev window');
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
      nrcv(j) = ainterp_dly*xinterp';
    end
    sample_offset = 3;
	%    if (mod(sinc_size,2) == 0) sample_offset = 2; end
  end
  calc_bb_err; % Calculate loss;
  e(l) = rms_err;
  f(l) = tx_time_off;
  grid;
end
figure;
plot(f,20*log10(e),'x-');
title('RMS error vs timing offset');
grid;
%figure
x=5;
if(x==5)
  plot(dem,'k');
  hold on;
  plot(nrcv,'gx-');
  axis([940 1000 -2 2]);
end


