function y = sinc_win_off(isps,npts,off)
% Fir consisting of Windowed sinc function with a fractional offset of
% off,
% Window is Chebshev with 40 db stopband ripple

y = zeros(1,npts);
mid = (npts + rem(npts,2))/2;
w = inihsin2(npts,40,-off);
for t=1:npts
  y(t) = sinc(t-mid+(off/isps))*w(t);
end
