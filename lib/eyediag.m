%$Id: eyediag.m,v 1.1 1997/09/25 17:09:24 kirke Exp $
% Does eyediagram plot
function eyediag(arr,sps)
clf
k = length(arr)/sps - 1; 
for kk=0:k
for jj=1:sps
eye(jj) = arr(kk*sps+jj);
end
plot(real(eye));
hold on;
end
hold off;