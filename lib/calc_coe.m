function h = calc_coe(N,g,alpha,beta)

L2 = 2^nextpow2(N)+1;
ctable = cos((0:L2-1)*pi/(L2-1));

H = zeros(1,L2);
phi0 = H;
phi1 = ones(1,L2);
beta = [1 beta];


for i=1:N
  H = H + g(i)/beta(i+1)*phi1;

  if (i==N)
	break;
  endif

  tmp = phi1;
  phi1 = ((ctable-alpha(i)*ones(1,L2))/beta(i+1)).*phi1-beta(i+1)/beta(i)*phi0;
  phi0 = tmp;


end

H= [H fliplr(H(2:L2-1))];
bb = ifft(H,2*(L2-1));
h = real([bb(2*(L2-1)-(N-2):2*(L2-1)) bb(1:N)]);







