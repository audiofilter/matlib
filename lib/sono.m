%$Id$
function n=sono(arr,sps)
clf
k = floor(length(arr)/sps - 1); 
for kk=0:k
for jj=1:sps
%n(jj,kk+1) = arr(kk*sps+jj);
tmp(jj) = arr(kk*sps+jj);
end
tmp = (abs(fft(tmp,sps)));
for jj=1:sps/2
n(jj,kk+1) = tmp(jj);
end
end