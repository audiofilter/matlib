function A=beam(H,f,theta,d)
% A=beam(H,f,theta,d)
% calculates wideband beam response
% H is cell array of element frequency responses (optVector)
% f is a vector of frequencies (in Hz)
% theta is a vector of angles (in radians)
% d is the element spacing (in meters)

for k=1:length(theta)
  A{k}=H{1};
  for n=1:length(H)-1
    A{k}=A{k}+2*real(H{n+1}*exp(-j*2*pi*f/3e8*n*d*sin(theta(k))));
  end;
end;
