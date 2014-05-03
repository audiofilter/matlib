%$Id$
function n=twodim(arr,sps)
clf
k = floor(length(arr)/sps - 1); 
for kk=0:k
for jj=1:sps
n(jj,kk+1) = arr(kk*sps+jj);
end
end