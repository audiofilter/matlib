function [seq] = optGenSequence(arg1,arg2) 
% OPTGENSEQUENCE optimized affine sequence class, derived from OPTVECTOR
%
% child members:
%   locs  : vector of time indices
%   optVector : parent class member; contains h, xoff and pool
%
% child methods:
% constructor:
%   [seq] = optGenSequence(locs, pool) 
%      creates an optimized affine sequence
%      at time indices given in locs in optSpace pool
%   [seq] = optGenSequence(locs, vect) 
%      creates an optimized affine sequence from optVector vect
%      at time indices given in locs
%   [seq] = optGenSequence(locs, x) 
%      creates a constant sequence from vector or sequence x
%      at time indices given in locs
%   [seq] = optGenSequence(vect) 
%      creates an optimized affine sequence from optVector vect
%      at uniform time indices starting from the origin
%   [seq] = optGenSequence(x) 
%      creates a constant sequence from vector or sequence x
%      at uniform time indices starting from the origin
%   [seq] = optGenSequence() 
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

global OPT_DATA; % needed here only for casebug check

if nargin==0 
  opt=optVector;
  seq.locs = [];
  seq = class(seq, 'optGenSequence', opt); 
elseif isa(arg1,'optGenSequence') 
  seq = arg1; 
elseif nargin==1 
  switch lower(class(arg1))
   case 'optvector'
    seq.locs = [0:length(arg1)-1]';
    seq = class(seq,'optGenSequence',arg1);
   case 'optsequence'
    ARG=struct(arg1); % violates data hiding
    seq.locs = [0:length(arg1)-1]'+ARG.noff+1;
    if OPT_DATA.casebug
      seq = class(seq,'optGenSequence',ARG.optvector);
    else
      seq = class(seq,'optGenSequence',ARG.optVector);
    end
   case 'double'
    opt=optVector(arg1(find(arg1))); % only take nonzero entries
    seq.locs = [find(arg1)-1]';
    seq = class(seq,'optGenSequence',opt);
   otherwise
    error('illegal argument to optGenSequence()');
  end;
elseif nargin==2
  switch lower(class(arg2))
   case 'optspace' % called with (locs, pool)
    [opt]=optVector(length(arg1),arg2);
    seq.locs = sort(arg1(:));
    seq = class(seq,'optGenSequence',opt);
   case 'double' % called with (locs, x)
    if length(arg1) ~= length(arg2)
      error('vector of time indices must have same length as constant vector');
    end;
    arg1=arg1(:);
    %[seq.locs,sid] = sort(arg1(find(arg2)));
    % keep zero entries: comment out prev. line, uncomment next line
    [seq.locs,sid] = sort(arg1);
    opt = optVector(arg2(sid));
    seq = class(seq,'optGenSequence',opt);
    disp('called with (locs, x)')
   case 'optvector' % called with (locs, vect)
    if length(arg1) ~= length(arg2)
      error('vector of time indices must have same length as optVector');
    end;
    [seq.locs,sid] = sort(arg1(:));
    arg2 = arg2(sid);     % rearrange optVector according to locs's order
    seq = class(seq,'optGenSequence',arg2);
    disp('called with (locs, vect)')
   otherwise
    error('illegal argument to optGenSequence()');
  end;
else
  error('illegal arguments to optGenSequence()');
end;
superiorto('optVector');   % ensures that optGenSequence methods called first
superiorto('optSequence');

if ~isempty(find(abs(diff(seq.locs))<10*eps)) % since locs is sorted check for neighboring matches
  error('duplicate entries in vector of time indices');
end;
if ~isreal(seq.locs)
  error('non-real entries in vector of time indices');
end;

