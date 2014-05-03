function [quadsum]=sum(quadvec)
% optQuadVector/sum  sum of terms in quadratic vector
% [quadsum]=sum(quadvev)
% quadvec is of class optQuadVector
% quadsum is of class optQuad

% check if quad vec is squared
if ~get_sqflag(quadvec)
  error('Can''t sum absolute values');
end;

pool=get_pool(quadvec);
xoff=get_xoff(quadvec);
max_density=0.25; % threshhold between sparse and full
hh = get_h(quadvec);
density=nnz(hh)/prod(size(hh));
factored=density<=max_density;
if factored
	if get_absflag(quadvec)
		Q=[sparse(real(hh)), sparse(imag(hh))];	
	else
		Q=sparse(real(hh));
	end;
else
	hr=full(real(hh));
	if get_absflag(quadvec)
		hi=full(imag(hh));
		Q=hr*hr.'+hi*hi.'; % only calculate real part
	else
		Q=hr*hr.';
	end;
end;

quadsum=optQuad(Q,factored,xoff,pool);
