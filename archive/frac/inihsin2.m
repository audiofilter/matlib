function win=inihsin2(L,wrip,d)
% INIHSIN2
% MATLAB m-file for noninteger delay design
% Initialization for hsincw2.m (Chebyshev window)
% Format: win = inihsin2(L,wrip,d)
%
% Timo Laakso   28.12.1992
% Shifted windows added 16.10.95
% Last revision 14.01.1996 / Timo Laakso

% 1) Chebyshev or HAMMING window for sinc windowing:
%
if rem(L,2)==1                    % odd length
  win=chebwin(L,wrip); win=win'; 
%  win=hamming(L); win=win'; 
else                              % even length
  d=d-0.5;                        % change the delay to match with hsincw.m
  winc=chebwin((2*L-1),wrip);
%  winc=hamming(2*L-1); win=win'; 
  for k=1:L
    win(k)=winc(2*k-1);           % decimate every other sample
  end  
end  % even length
%
cwind=win-win;  % zeroing of interpolated window cwind 


if abs(d)>0.00000001 % Shift the window 
  for n=1:L          % (see Laakso et al., MWSCAS'95,Rio)
    for k=1:L    
%      alpha=pi*(n-k-d);
%      cwind(n)=cwind(n)+win(k)*(sin(alpha))/alpha;
      alpha=(n-k-d);
      cwind(n)=cwind(n)+win(k)*sinc(alpha);
    end % for k
  end % for n
else cwind=win; end
win=cwind;
