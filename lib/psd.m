function [y] = psd (x,N)
#  N = 2048;
  y = zeros(N,1);
  n = floor(length(x)/N);
  w = gauss_window(N)';
  for i=0:n-1,
#    z = abs(fftshift(fft(x((1+i*N):(N+i*N)).*hanning(N))));
    z = abs(fftshift(fft(x((1+i*N):(N+i*N)).*w)));
    y = y + (z.*z);
  endfor
  y = 10*log10(y);
endfunction
