function [w] = kmk(A,b);
%
% function [w] = kmk(A,b);
%
% function solves the overdetermined system of linear equations
% 
%               A*w = b
% 
% in the l_infinity (or Chebyshev) sense.
%
% subroutine karmark.m is required
%
% Author: Markus Lang  <lang@jazz.rice.edu>, mar-11-1992

% References:  Tr. on ASSP, Vol. 37 - Feb. 1989, pp. 245-253
%              especially Fig.2 p.248.
%              G. Strang: Introduction to Applied Mathematics
%
% Copyright:   All software, documentation, and related files in this
%              distribution are Copyright (c) 1992 LNT, University of
%              Erlangen Nuernberg, FRG, 1992 
%
% Permission is granted for use and non-profit distribution providing that this
% notice be clearly maintained. The right to distribute any portion for profit
% or as part of any commercial product is specifically reserved for the author.
%
% Since this program is free of charge we provide absolutely no warranty.
% The entire risk as to the quality and the performance of the program is
% with the user. Should it prove defective, the user user assumes the cost
% of all necessary serrvicing, repair or correction. 

% initialization
[m,n] = size(A);
A = -[A ones(1,m)'; -A ones(1,m)']';
b = -[b; -b]; 
c = -[zeros(1,n) 1]';
epsi = 1e-5;
[ln,lm]=size(A);

% guarantee c>=0:
indexh=find(c<0);
c(indexh)=-c(indexh);
A(indexh,:)=-A(indexh,:);

% find an initial solution  A*x=b with x>0 --> phase 1
A_Phase1=[A c-A*ones(1,lm)'];
b_Phase1=[zeros(size(b)); 1e10];
x=karmark(A_Phase1,ones(1,lm+1)',b_Phase1,epsi);

x=x(1:lm);
% find the solution of the original problem --> phase 2
A_Phase2=A;
[x,w]=karmark(A_Phase2,x,b,epsi);
w(indexh)=-w(indexh);
w = w(1:n);
