function A=beam2(h,f,fs,theta,d)
% A=beam2(h,f,fs,theta,d)
% calculates wideband beam response
% h is cell array of element filters (optSequence)
% f is a vector of frequencies (in Hz)
% fs is the sampling rate
% theta is a vector of angles (in radians)
% d is the element spacing (in meters)

if length(f)==1
  f=repmat(f,size(theta));
end;
if length(theta)==1
  theta=repmat(theta,size(f));
end;

A=fourier(h{1},f/fs);
for n=1:length(h)-1
  A=A+2*real(fourier(h{n+1},f/fs)*exp(-j*2*pi*f/3e8*n*d.*sin(theta)));
end;
