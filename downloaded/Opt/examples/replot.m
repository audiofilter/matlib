function replot(tempsoln)
global handle f h Nf;

delete(handle);
handle=plot(f,20*log10(abs(fft(double(optimal(h,tempsoln)),Nf))));
drawnow;

