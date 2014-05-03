function L2 = L2fnorm(g,f,W)
% optArray/L2fnorm : Frequency-domain weighted L2 norm
% L2 = L2fnorm(g,f,W)
% equivalent to sum(abs(fourier(g,f)*W).^2)
% W defaults to ones(size(f,1),1);

global OPT_DATA;

if nargin<3
	W=ones(size(f,1),1);
end;
if prod(size(W))==1
	W=repmat(W,size(f,1),1);
end;

seg_var_prod=1e6; % product of segment length and number of variables
vars=OPT_DATA.pools(get_pool(g));
segsize=ceil(seg_var_prod/vars);      % segment length
Nf=size(f,1);
numsegs=floor(Nf/segsize);


if numsegs*segsize<Nf
	L2 = sum(abs(fourier(g,f(segsize*numsegs+1:Nf,:)) ...
		     * W(segsize*numsegs+1:Nf,1)).^2);
else
	numsegs=numsegs-1;
	L2 = sum(abs(fourier(g,f(Nf-segsize+1:Nf,:)) ...
		     * W(Nf-segsize+1:Nf,1)).^2);
end;

for k=0:numsegs-1
	L2 = L2 + sum(abs(fourier(g,f(k*segsize+(1:segsize),:)) ...
			  * W(k*segsize+(1:segsize),1)).^2);
end;
