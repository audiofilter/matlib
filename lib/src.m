function y = src(beta,isps,npts)
% function y = src(beta,isps,npts)
%$Id: src.m,v 1.3 1997/09/30 16:28:14 kirke Exp $
% Square root raised cosine function 
% beta = excess bandwidth factor
% isps = samples/symbol
% npts = number of points
y = zeros(1,npts);
for t=1:npts
  i = t - (npts+1)/2;
  i2 = i*i/(isps*isps);
  x1 = pi*i/isps;
  x2 = 4*beta*i/isps;
  x3 = x2*x2 - 1;
  if (x3==0)
    x3 = (1-beta)*pi*i/isps;
    x2 = (1+beta)*pi*i/isps;
    nom  = sin(x2)*(1+beta)*pi - cos(x3)*((1-beta)*pi*isps)/(4*beta*i) + sin(x3)/(4*beta*i2);
    denom = -32*pi*beta*beta*i/isps;
    if (beta==1) 
      nom = 1;
      denom = 4*beta;
    end
  else 
    if (x1==0)
      nom = cos((1+beta)*x1) + (1-beta)*pi/(4*beta);
    else 
      nom = cos((1+beta)*x1) +  sin((1-beta)*x1)/(4*beta*i/isps);
    end
    denom = x3*pi;
  end
  y(t) = -4*beta*nom/denom;
end

