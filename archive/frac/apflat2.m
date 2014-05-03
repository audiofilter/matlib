function ap = apflat2(N,x)
% APFLAT2
% MATLAB m-file for ALLPASS fractional delay filter design
% using MAXIMALLY GLAT GROUP DELAY approximation
% Format: ap = apflat2(N,x)
% Input: N = filter order
%        x = fractional delay (0 < x <= 1) 
% Output: Filter coefficient vector ap=ap(1)...ap(N+1)
%         (Note that ap(1)=1 always)
% Subroutines: standard MATLAB & SP Toolbox functions &
%              bincof2.m
% Timo Laakso   27.02.1993
% Last revision 15.01.1996

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
ap(1)=1;
for k=1:N
  cd=(-1)^k*bincof2(N,k);
  prod=1;
  for t=0:N
    prod=prod*(x+t)/(x+k+t);
  end;
  ap(k+1)=cd*prod;
end;
