%$Id$
function n=1to2(arr,sps)
clf
k = length(arr)/sps - 1; 
for kk=0:k
for jj=1:sps
n(jj,sps) = arr(kk*sps+jj);
end
end