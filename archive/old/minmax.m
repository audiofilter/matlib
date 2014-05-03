function [mneye, mxeye] = minmax(arr,sps)
clf
mxeye = zeros(1,sps);
mneye = max(arr)*ones(1,sps);
k = length(arr)/sps - 1; 
for kk=1:k
for jj=1:sps
eye(jj) = arr(kk*sps+jj);
if (abs(eye(jj))>mxeye(jj)) 
	mxeye(jj) = abs(eye(jj));
end 
if (abs(eye(jj))<mneye(jj)) 
	mneye(jj) = abs(eye(jj));
end 
end
%plot(real(eye),'.');
%hold on;
end
%hold off;
plot(mxeye);
hold on;
plot(mneye);