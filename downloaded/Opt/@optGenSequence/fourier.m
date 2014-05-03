function G=fourier(g,f)
% OPTGENSEQUENCE/FOURIER  sequence Fourier transform
% G=fourier(g,f)
% returns FT of optGenSequence g at f as an optGenSequence
f=f(:)';
h=get_h(g);
xoff=get_xoff(g);
pool=get_pool(g);
% n=(1:size(h,2))'+g.noff;
G=optGenSequence;
G=set_h(G,h*exp(-j*2*pi*g.locs*f));
G=set_xoff(G,xoff);
G=set_pool(G,pool);
G=set_locs(G,f);
