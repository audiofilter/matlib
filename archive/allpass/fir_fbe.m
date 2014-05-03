function w = fir_fbe(a,wi,Abe);
%
% find band edges of an FIR filter using Newton's method
% using initial estimates
%
% A   : a(1)+a(2)*cos(w)+...+a(n+1)*cos(n*w)
% wi  : initial values for the band edges
% Abe : value of H at the band edges
%
a = a(:);
m = length(a)-1;
w = wi(:);
Abe = Abe(:);
for k = 1:20
   A = cos(w*[0:m]) * a - Abe;
   A1 = -sin(w*[0:m]) * ([0:m]'.*a);
   w = w - A./A1;
end


