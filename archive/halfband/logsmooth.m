function [f,p] = logsmooth(X,inBin,nbin)
% function [f,p] = logsmooth(X,inBin,nbin)
% Smooth the fft, X, and convert it to dB.
% Use nbin(8) bins from 0 to 3*inBin, 
% thereafter increase bin sizes by a factor of 1.1, staying less than 2^10.
% For the 3 sets of bins inBin+[0:2], 2*inBin+[0:2], and 
% 3*inBin+[0:2], don't do averaging. This way, the noise BW
% and the scaling of the tone and its harmonics are unchanged.
% Unfortunately, harmonics above the third appear smaller than they 
% really are because their energy is averaged over several bins.
if nargin<3
    nbin = 8;
end
N=length(X); N2=N/2;
n = nbin;
f1 = rem(inBin-1,n)+1;
startbin = [f1:n:inBin-1 inBin:inBin+2 inBin+3:n:2*inBin-1 ...
	 2*inBin+[0:2] 2*inBin+3:n:3*inBin-1 3*inBin+[0:2] ];
m = startbin(length(startbin))+n;
while m < N2
   startbin = [startbin m];
   n = min(n*1.1,2^10);
   m = round(m+n);
end
stopbin = [startbin(2:length(startbin))-1 N2];
f = ((startbin+stopbin)/2 -1)/N;
p = zeros(size(f));
for i=1:length(f)
    p(i) = dbp(norm(X(startbin(i):stopbin(i)))^2 / ...
              (stopbin(i)-startbin(i)+1));
end
