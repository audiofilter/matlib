function [h,D,W] = wls_src(N0,alpha,fr,L)

D = srcfreqpts(alpha,fr,L)';
%W = [(1:L/2)/L fliplr(1:L/2)/L];
pe = ceil(L/(2*fr));
tr = ceil(alpha*pe);
%W = [ones(1,px) 50*ones(1,L-px)]; #2*pe) zeros(1,L-2*pe)];
px = 110;
Stp = sin(pi*(1:px)/(px));
Stp = ones(1,px) + 90*Stp;

W = [ones(1,pe-tr) zeros(1,tr) Stp 10*ones(1,L-pe-px)]; #2*pe) zeros(1,L-2*pe)];
%W = ones(1,L);


h = wls_sig(N0,D,W,L);
