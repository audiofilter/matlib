function [y]= TriangleTime(x,freqs,scale)
% The inverse Fourier transform of Tri((f-freqs)/scale), where
% Tri(f) is the unit height, unit area triagle function	
% y	 elementwise on a vector or matrix x: 
%    scale*sinc(scale*x).^2*e^{j*2*pi*freqs*x}

% % allocate space
%    y=zeros(size(x));
% % for nonzero arguments
%    i= find(x~=0);
%    px= pi*x(i);
%    y(i)=(sin(px)./px).^2.*exp(j*2*pi*d*x(i));
% % for zero arguments
%    i= find(x==0);
%    y(i)= ones(size(i));

   
sincres = zeros(size(x));

ii = find(x==0);
sincres(ii) = scale;
ii = find(x~=0);
sincres(ii) = scale*(sin(pi*x(ii)*scale)./(pi*x(ii)*scale)).^2;

y = sincres .* exp(j*2*pi*freqs(:)*x);
