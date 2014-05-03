function replot(tempsoln)
global handle pbhandle hLevel f fsb h Nf beta themovie frame bottomhandle tophandle;

dBsoln=dB(fft(double(optimal(h,tempsoln)),Nf));

subplot(tophandle);
delete(pbhandle);

subplot(bottomhandle);
delete(handle);
delete(hLevel);
handle=plot(f,dBsoln);
hLevel=plot(fsb,dB(double(optimal(beta,tempsoln))),'c.');

subplot(tophandle);
pbhandle=plot(f,dBsoln);

drawnow;

frame=frame+1;
themovie(:,frame) = getframe(gcf);
