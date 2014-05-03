function [R]= CircleTime(t,radius,freqs,Coeff)
%   NDPROCESS/private/CIRCLETIME
%       finds inverse fourier transform of a superposition of
%       circles of radius 'width' located at freqs.
%       The I.F.T. is computed at times given in t.

R = zeros(size(t,1),1);

for qq = 1:size(t,1) % loop over times
  for zz = 1:size(freqs,1) % loop over # of bases'
    normT = norm(t(qq,:));
    if normT == 0
      % at 0, limit of J_11(2 pi ||t||) / ||t||  == pi.
      %   lim   r J_1(2 pi ||t|| r) / ||t||    ==  pi r^2
      % ||t||-> 0    
      besselres = pi * radius(zz).^2;
    else
      besselres = (besselj(1, 2*pi*radius(zz)*normT)) ...
	  .* (radius(zz) ./ normT);
    end
    R(qq) = R(qq) + Coeff(zz) * ...
	    besselres * exp(j*2*pi*dot(t(qq,:), freqs(zz,:)));
  end
end

