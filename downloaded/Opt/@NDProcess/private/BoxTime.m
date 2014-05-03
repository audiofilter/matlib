function [R]= BoxTime(t,width,freqs,Coeff)
%   NDPROCESS/private/BOXTIME
%       finds inverse fourier transform of a superposition of
%       boxcars of width 'width' located at freqs.
%       The I.F.T. is computed at times given in t.

R = zeros(size(t,1),1);

for qq = 1:size(t,1) % loop over times
  for zz = 1:size(freqs,1) % loop over # of bases
    sincVector = zeros(1,size(width,2));
    ii = find(t(qq,:) == 0);
    % for any coordinates which are 0, sinc is just the width
    sincVector(ii) = width(zz,ii);
    ii = find(t(qq,:) ~= 0);
    sincVector(ii) = sin(pi.*width(zz,ii).*t(qq,ii))./(pi.*t(qq,ii));
    sincres = prod(sincVector);
    R(qq) = R(qq) + Coeff(zz) * ...
	    sincres * exp(j*2*pi*dot(t(qq,:), freqs(zz,:)));
  end
end

