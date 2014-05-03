function [aquad] = optQuadVector(aff,absflag,sqflag) 
% optQuadVector: optimized quadratic vector class, derived from optVector
% this class represents element-wise magnitude/squaring of an optVector
%
% child members:
% absflag : indicates if abs() was taken
% sqflag  : indicates if ().^2 was taken
%
% child methods:
% constructor:
%   [aquad] = optQuadVector(aff,absflag,sqflag) 
%      creates an optimized affine quad from opt. affine aff
% insertion/extraction functions:
%   [vect]=get_optVector(qvect)
%      returns the base optVector component
% operators:
%   [quad]=sum(aquad)     
%      creates a single quadratic by summing - like energy
%   [subs]=subsref(seq,s)  ()
%      extract a subsequence or element(scalar)
% overloaded operators:
%   [aquad]=power(a,b)    .^
%      for raising an abs to an abs.^2
%   [aquad]=mtimes(a,b)    *
%   [aquad]=times(a,b)    .*
%      scalar and elementwise multiplication
%   [aquad]=mrdivide(a,b)  / 
%   [aquad]=rdivide(a,b)  ./
%      scalar and elementwise division

if nargin<3
  error('optQuadVector(aff,absflag,sqflag) requires 3 input args');
else
  aquad.absflag=absflag;
  aquad.sqflag=sqflag;
  aquad = class(aquad, 'optQuadVector', optVector(aff));
  % cast to optVector ensures correct input to class
end;
superiorto('optVector');   % ensures that optQuadVector methods called first
