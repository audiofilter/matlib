function G=fourier(g,nu)
% OPTSEQUENCE/FOURIER  sequence Fourier transform
% G=fourier(g,nu)
% returns FT of optSequence g at nu as an optGenSequence
nu=nu(:)';
h=get_h(g);
xoff=get_xoff(g);
pool=get_pool(g);
n=(1:size(h,2))'+g.noff;
G=optGenSequence;
%G=optVector;
G=set_h(G,h*exp(-j*2*pi*n*nu));
G=set_xoff(G,xoff);
G=set_pool(G,pool);
G=set_locs(G,nu);
