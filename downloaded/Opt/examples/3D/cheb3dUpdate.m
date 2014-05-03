function cheb3dUpdate(tempsoln)
global t ff ffi tau N Nf fc respHand CircHand h beta respdotsHand;

delta=double(optimal(beta,tempsoln));
delete(CircHand);
CircHand=plot3(delta*cos(t)*ones(size(fc)),...
                 ones(size(t))*fc,...
               delta*sin(t)*ones(size(fc)));
set(CircHand,'Color',[.2 1 .5]);

hopt=double(optimal(h,tempsoln));
H=fft([hopt(tau+1:N),zeros(1,Nf-N),hopt(1:tau)]);
HH=H(ffi);
delete(respHand);
respHand=plot3(-real(HH),ff,imag(HH));
set(respHand,'Color',[0 .7 1],'LineWidth',8,'LineStyle',':');

drawnow;
