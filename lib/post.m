%$Id: post.m,v 1.1 1997/09/25 17:09:24 kirke Exp $
clf
subplot(2,1,1), plot(real(r),imag(r),'.');
axis([-2 2 -2 2]);
axis('square');
%grid;
subplot(2,1,2), plot(real(eq),imag(eq),'.');
axis([-2 2 -2 2]);
axis('square');
%grid;