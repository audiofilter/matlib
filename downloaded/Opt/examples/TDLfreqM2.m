function [X,f]=TDLfreqM2(x, Nfft, deltat, t0, f0, Nf)
% [X,f]=TDLfreqM2(x, Nfft, deltat, t0, f0, Nf)
% calculates frequency response of TDL filter x
% x = TDL taps
% t0 = time of x[1]
% f0 = freq. of X[1]
% deltat = tap spacing
% Nfft = fft size
% Nf = number of frequency samples to return
% X = transform
% f = X frequency grid

%[argl,argr] = argn();
switch nargin
  case 2, deltat=1; t0=0; f0=-0.5; Nf=Nfft;
  case 3, t0=0; f0=-1/2/deltat; Nf=Nfft;
  case 4, f0=-1/2/deltat; Nf=Nfft;
  case 5, Nf=Nfft;
end;
[R,C]=size(x);
t=repmat((0:C-1),R,1)*deltat+t0;
deltaf=1/(Nfft*deltat);
if (Nf==Nfft)
  f=repmat((0:Nfft-1),R,1)*deltaf;
  X=fft(x.*exp(-i*2*pi*f0*t),Nfft,2).*exp(-i*2*pi*f*t0);
  f=f(1,:)+f0;
else
  X1=fft(x.*exp(-i*2*pi*f0*t),Nfft,2);
  X=zeros(R,Nf);
  n1=floor(Nf/Nfft);
  n2=mod(Nf,Nfft);
  for a=0:n1-1
    X(:,a*Nfft+1:(a+1)*Nfft)=X1;
  end;
  if (n2~=0)
    X(:,n1*Nfft+1:Nf)=X1(:,1:n2);
  end;
  f=repmat((0:Nf-1)*deltaf,R,1);
  X=X.*exp(-i*2*pi*f*t0);
  f=f(1,:)+f0;
end;
