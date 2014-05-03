function L2 = L2fnorm(g,f,W,D)
% optGenSequence/L2fnorm : Frequency-domain weighted L2 error norm
% L2 = L2fnorm(g,f,W,D)
% equivalent to sum(abs((fourier(g,f)-D)*W).^2)
% W defaults to 1
% D defaults to 0

global OPT_DATA;

Nf=length(f);
if nargin<4
	D=optGenSequence(f,zeros(Nf,1))
	% by the way Dan, this makes an empty o.G.S.
end;
if nargin<3
	W=optGenSequence(f,ones(Nf,1));
end;

seg_var_prod=1e6; % product of segment length and number of variables
vars=OPT_DATA.pools(get_pool(g));
segsize=ceil(seg_var_prod/vars);      % segment length
numsegs=floor(Nf/segsize);

subs.type = '()';
subs.subs{2} = 'i';
if numsegs*segsize<Nf
	%subs.subs = {[f(segsize*numsegs+1:Nf)]};
	subs.subs{1} = segsize*numsegs+1:Nf;
	L2 = sum(abs((fourier(g,f(segsize*numsegs+1:Nf)) - subsref(D,subs)) ...
		* subsref(W,subs)).^2);
else
	%subs.subs = {[f(Nf-segsize+1:Nf)]};
	subs.subs{1} = Nf-segsize+1:Nf;
	numsegs=numsegs-1;
	L2 = sum(abs((fourier(g,f(Nf-segsize+1:Nf)) - subsref(D,subs) ) ...
		* subsref(W,subs)).^2);
end;

for k=0:numsegs-1
  %subs.subs = {[f(k*segsize+(1:segsize))]};
  subs.subs{1} = k*segsize+(1:segsize);
	L2 = L2 + sum(abs((fourier(g,f(k*segsize+(1:segsize))) ...
		              - subsref(D,subs))...
		* subsref(W,subs)).^2);
end;
