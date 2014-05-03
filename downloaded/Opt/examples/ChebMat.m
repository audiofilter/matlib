function T=ChebMat(N);
% T=ChebMat(N);
% calculate NxN Chebychev polynomial matrix up to order N-1

T=zeros(N,N);
T(1,N)=1;
T(2,N-1)=1;
for n=3:N
	T(n,:)=2*[T(n-1,2:N), 0]-T(n-2,:);
end;
