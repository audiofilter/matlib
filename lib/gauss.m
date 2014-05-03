function y = gauss(x,std)
  y = exp(-(x.*x)/(2*std^2)) / (std*sqrt(2*pi));
