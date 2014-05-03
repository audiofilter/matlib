function [R]= ImpulseTime(t,width,freqs,Coeff)
%   NDPROCESS/private/IMPULSETIME
%       finds inverse fourier transform of a superposition of
%       impulses located at freqs.
%       The I.F.T. is computed at times given in t.

%R = zeros(size(t,1),1);
%for qq = 1:size(t,1) % loop over times
%    R(qq) = Coeff * exp(j*2*pi*freqs*t(qq,:)');
%end

R = (Coeff*exp(j*2*pi*freqs*t')).' ;
