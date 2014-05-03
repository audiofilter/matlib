function y = rms (x)
  n = length(x);
  y = sqrt(sum(abs(x).*abs(x))/n);
