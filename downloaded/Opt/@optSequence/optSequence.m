function [seq] = optSequence(n,pool) 
% OPTSEQUENCE optimized affine sequence class, derived from OPTVECTOR
%
% child members:
%   noff : index offset of first point in optimized sequence
%
% child methods:
% constructor:
%   [seq] = optSequence(n,pool) 
%      creates an optimized affine sequence of length n
%   [seq] = optSequence(vect) 
%      creates an optimized affine sequence from optVector vect
%   [seq] = optSequence(x) 
%      creates a constant sequence from vector or sequence x
%   [seq] = optSequence() 
%      creates an empty sequence
% operators:
%   [pseq]=plus(a,b)     
%      sequence addition
%   [mseq]=minus(a,b) 
%      sequence subtraction
%   [cseq]=times(a,b)
%      sequence convolution
%   [tseq]=transpose(seq) 
%      sequence flip
%   [tseq]=ctranspose(seq) 
%      sequence flip and conjugate
%   [subs]=subsref(seq,s)
%      extract a subsequence or element
% overloaded operators:
%   [mseq]=mtimes(a,b)  
%      scalar and elementwise sequence multiplication

if nargin==0 
  opt=optVector;
  seq.noff = -1;
  seq = class(seq, 'optSequence', opt); 
elseif isa(n,'optSequence') 
  seq = n; 
elseif nargin==1 
  seq.noff = -1;
  switch lower(class(n))
    case 'optvector'
      seq = class(seq,'optSequence',n);
    case 'double'
      opt=optVector(n);
      seq = class(seq,'optSequence',opt);
    otherwise
      error('illegal argument to optSequence()');
  end;
elseif nargin==2
  [opt]=optVector(n,pool);
  seq.noff = -1;
  seq = class(seq,'optSequence',opt);
else
  error('illegal arguments to optSequence()');
end;
superiorto('optVector');   % ensures that optSequence methods called first
