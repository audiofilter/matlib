function ap = eigsolv2(P,Nap);
% EIGSOLV2
% MATLAB m-file for finding the vector a 
% such that a^TPa = min (eigenfilter problem)
% Format: ap = eigsolv2(P,Nap);
% Timo Laakso  24.07.1992
% Last revised 16.01.1996

Psub=P(2:Nap,2:Nap);
p=P(2:Nap,1);
ap1=-Psub\p;
ap=[1 ap1'];
