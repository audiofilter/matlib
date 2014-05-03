function [seq] = optArray(arg1,arg2,arg3) 
% OPTARRAY optimized affine sequence class, derived from OPTVECTOR
%
% child members:
%   locs  : vector of locations
%   optVector : parent class member; contains h, xoff and pool
%
% child methods:
% constructor:
%   [seq] = optArray(locs, pool) 
%      creates an optimized affine sequence
%      at locations given in locs
%   [seq] = optArray(locs, vect)
%      creates an optimized affine sequence from optVector vect
%      at locations given in locs
%   [seq] = optArray(locs, x)
%      creates a constant sequence from vector or sequence x
%      at time indices given in locs
%   [seq] = optArray(lattice, region, pool)
%      creates an optimized affine sequence at locations on a
%      lattice within a region
%   [seq] = optArray() 
%      creates an empty sequence
% operators:
%   [tseq]=ctranspose(seq)
%      conjugate flip
%   [tseq]=transpose(seq)
%      flip
%   [pseq]=plus(a,b)     
%      sequence addition
%   [mseq]=minus(a,b) 
%      sequence subtraction
%   [cseq]=times(a,b)
%      sequence convolution
%   [subs]=subsref(seq,s)
%      extract a subsequence or element
%   [mseq]=mtimes(a,b)  
%      scalar and elementwise sequence multiplication
%
% locs is of the form
%
%             dim
%        [ x_1 y_1 z_1 ]
%      l [             ]
%      o [  .   .   .  ]
%      c [  .   .   .  ]
%      s [  .   .   .  ]
%        [             ]
%        [ x_n y_n z_n ]
%

if nargin==0 
  opt=optVector;
  seq.locs = [];
  seq = class(seq, 'optArray', opt); 
elseif (nargin==1) & (isa(arg1,'optArray') )
  seq = arg1; 
elseif (nargin==3) & isa(arg1, 'Lattice') & isa(arg2,'Region')
  % called with (lattice, region, pool)
  M = get_M(arg1);
  if get_dim(arg2) ~= size(M,2)
    error('Lattice and Region dimension mismatch.');
  end
  disp(['called with (lattice, region, pool). ', ...
	num2str(get_dim(arg2)),'-D.']);
  boundingbox = bb(arg2, arg1); % find bounding box for region in arg2
  if boundingbox(1) == inf
    error('Region given is unbounded.')
  end
  biglocs = inbox(arg1, boundingbox);
  % extract locations. Should be replaced later to take advantage
  % of lattice math
  locs = isin(arg2, biglocs);
  [opt] = optVector(size(locs,1) , arg3);
  seq.locs = locs;
  seq = class(seq,'optArray',opt);
  return;
elseif (nargin==2)
  if isa(arg2, 'optVector')
    seq.locs = arg1;
    seq = class(seq,'optArray',arg2);   
  elseif isa(arg2, 'optSpace') % called with (locs, pool)
    disp(['called with (locs, pool). ',num2str(size(arg1,2)),'-D.']);
    [opt]=optVector(size(arg1,1),arg2);
    seq.locs = sortrows(arg1); % sort by location
    % double transpose because we want locs oriented (dim x locs)
    seq = class(seq,'optArray',opt);
  else % called with (locs, x)
    arg2 = arg2(:);
    if size(arg1,1) ~= size(arg2,1)
      error('set of locations must have same dimension as constant vector');
    end;
    %[seq.locs,sid] = sortrows(arg1(find(arg2),:));
    % keep zero entries: comment out prev. line, uncomment next line
    [seq.locs,sid] = sortrows(arg1);
    opt = optVector(arg2(sid));
    seq = class(seq,'optArray',opt);
    disp('called with (locs, x)')
  end;
else
  error('illegal arguments to optArray()');
end;
superiorto('optVector');   % ensures that optArray methods called first
superiorto('optGenSequence');
superiorto('optSequence');
superiorto('double');

%if ~isempty(find(sum(diff(seq.locs,1,1).^2 , 2)<10*eps))
if any(all(abs(diff(seq.locs,1,1))<1e6*eps,2))
  % since locs is sorted check for neighboring matches
  error('duplicate entries in locations matrix');
end;
if ~isreal(seq.locs)
  error('non-real entries in locations matrix');
end;

