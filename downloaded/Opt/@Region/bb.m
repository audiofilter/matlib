function [box] = bb(reg, lat)
% REGION/BB  Bounding box for Region
%
% BOX = BB(REG, LAT) returns a bounding box for the Region REG in
% terms of the lattice LAT; that is, in terms of intervals along the
% lattice basis vectors which define a parallepiped that circumscribes
% the Region.  
%
% If the region is unbounded, the function returns inf.
%
% If LAT is an offset lattice, the intervals given are for a
% parallelepiped that circumscribes the Region shifted by the
% inverse of the lattice's offset.

global OPT_DATA;

if ~isa(lat, 'Lattice') | ~isa(reg, 'Region')
  error('BB must be called (region, lattice)')
end

type = get_type(reg);
param = OPT_DATA.regions(reg.ind).param;
box = zeros(1,2*size(get_M(lat),2)); % box is row vector

switch type
 case 'convpoly'
  if OPT_DATA.regions(reg.ind).complement
    % if the convpoly is complemented, this region is unbounded.
    box = inf;
    return;
  end
  if ~isfield(OPT_DATA.regions(reg.ind).param, 'A')
    doConvpolyLegwork(reg.ind, param);
    % do preprocessing if first time called, then reload parameters
    param = OPT_DATA.regions(reg.ind).param;
  end
  EP = param.points;
  % for convpoly, test extreme points
  % the function bbEP() is at the end of this file
  box = bbEP(lat, EP);
  return;
 case 'sphere'
  if OPT_DATA.regions(reg.ind).complement
    box = inf;
    return;
  end
  % for sphere, test extreme points of hypercube which
  % circumscribes the hypersphere.
  EP = zeros(2^param.dim, param.dim);
  for qq=1:2^param.dim
    % 2^dim extreme points of the hypercube
    plusminus = double(dec2bin(qq-1,param.dim)) - 48;
    % convert loop index to binary
    for zz=1:param.dim
      if plusminus(zz)
	EP(qq,zz) = param.center(zz) + param.radius;
      else
	EP(qq,zz) = param.center(zz) - param.radius;
      end
    end
  end
  box = bbEP(lat, EP);
  return;
 case 'halfspace'
  % a halfspace by itself is always unbounded. See below in
  % 'composite' for the treatment of intersection of halfspaces.
  box = inf;
  return;
 case 'composite'
  fcn = msop(reg); 
  % obtain sum-of-products representation of composite region
  pbox = zeros(length(fcn), 2*param.dim);
  %fcn{:}
  for qq = 1:length(fcn)
    tbox = zeros(length(fcn{qq}), 2*param.dim);
    % tbox contains bounding box for each Region in the product term
    hsidx = []; % index of halfspaces in product term
    for zz = 1:length(fcn{qq})
      % get bounding box for each Region in the product term
      if strcmp(OPT_DATA.regions(fcn{qq}(zz)).type, 'halfspace')
	% quick scan to determine which of the variables in the
	% product term are halfspaces. Halfspaces must be treated
	% differently, because by themselves they are unbounded, but
	% an intersection of them can create a bounded region.
	hsidx = [hsidx; zz];
	tbox(zz,1:2:end) = -inf;
	tbox(zz,2:2:end) = inf;
	continue
      end
      if fcn{qq}(zz) < 0
	% if a term is complemented. I'm being a bit profligate
        % already with the creation of new Region objects, only worried
        % because it increases the size of OPT_DATA
	tmpbox = bb(~Region(fcn{qq}(zz)), lat);
      else
	tmpbox = bb(Region(fcn{qq}(zz)), lat);
      end
      if tmpbox == inf
	% if a region in the product term is unbounded, this is
        % essentialy a don't care for an intersection. However if
        % the entire product term is [-inf, inf] for a basis
        % vector, then the row in pbox will have [-inf, inf] and
        % consequently there will be [-inf, inf] in box, causing
        % the function to returned an unbounded signal.
	tbox(zz,1:2:end) = -inf;
	tbox(zz,2:2:end) = inf;
      else
	tbox(zz,:) = tmpbox;
      end
    end % end -- for zz=1:length(fcn{qq})
    % --- now deal with the halfspaces
    if length(hsidx) >= param.dim + 1
      % unless there are at least dim+1 halfspaces in the product
      % term, the intersection is guaranteed to be unbounded.
      A = []; b = []; 
      for zz=1:length(hsidx)
	if OPT_DATA.regions(fcn{qq}(hsidx(zz))).complement
	  b = [b; -OPT_DATA.regions(fcn{qq}(hsidx(zz))).param.b];
	  A = [A; ...
	       -transpose(OPT_DATA.regions(fcn{qq}(hsidx(zz))).param.a)];
	else
	  b = [b; OPT_DATA.regions(fcn{qq}(hsidx(zz))).param.b];
	  A = [A; ...
	       transpose(OPT_DATA.regions(fcn{qq}(hsidx(zz))).param.a)];
	end
      end
      cost = rand(size(A,2) , 1);
      pars.fid = 0; K.f = 0; K.l = size(A,1);
      [devnull, devnull, info1] = sedumi(A', cost, 0, K, pars);
      [devnull, devnull, info2] = sedumi(A', -cost, 0, K, pars);
      if (info1.pinf == 1) | (info2.pinf == 1)
	% if either LP is infeasible, then the polyhedron formed
	% by the intersection of the halfspaces is unbounded.
	%disp('1/2space poly unbounded');
      else
	% polyhedron is bounded; find extreme points...
	% Extreme points are solutions of dim linearly-independent
        % rows of Ax=b, where A and b are from Ax>=b just formed.
	bins = dec2bin(0:2^size(A,1)-1) - 48;
	nLIidx = find(sum(bins,2) == param.dim);
	subA = zeros(param.dim); subb = zeros(param.dim,1);
	EP = [];
	for zz=1:length(nLIidx)
	  % Loop over all possible combinations of dim rows
	  didx = 1; otherIdx = [];
	  for kk=1:size(bins,2)
	    % form linear system
	    if bins(nLIidx(zz), kk)
	      subA(didx,:) = A(kk ,:);
	      subb(didx) = b(kk);
	      didx = didx + 1;
	    else
	      otherIdx = [otherIdx; kk];
	      % keep track of inactive constraints
	    end
	  end
	  if det(subA) ~= 0 
	    % if the rows are in fact linearly independent
	    basicSoln = (subA\subb);
	    % basic solution has dim active constraints
	    constrTest = A*basicSoln >= b;
	    if all(constrTest(otherIdx))
	      % if all constraints are satisfied, this is an
              % extreme point.
	      % We can just test the inactive ones (given in
              % otherIdx) since by definition the active ones are
              % satisfied.
	      % For future speedup: don't need to do full Ax >= b,
              % rather just complement of subA and subb.
	      EP = [EP; basicSoln'];
	    end
	  end
	end
	%EP
	tbox(hsidx(1),:) = bbEP(lat, EP);
      end
    end
    % --- end of dealing with halfspaces
    pbox(qq,1:2:end) = max(tbox(:,1:2:end),[],1);
    pbox(qq,2:2:end) = min(tbox(:,2:2:end),[],1);
    dpbox = diff(pbox(qq,:));
    if any(dpbox(1:2:end) < 0)
      % if we have a null bounding box for the product term (that
      % is, if the beginning of an interval is greater than its end)
      % Note that a zero-volume box is allowed. If this is not
      % desired, change the above to <=
      pbox(qq,1:2:end) = -inf;
      pbox(qq,2:2:end) = inf;
    end
    % for product terms, take maximum of all axis minima, and
    % minimum of all axis maxima, resulting in intersection of
    % bounding boxes.
  end % end -- for qq=1:length(fcn)
  box(1:2:end) = min(pbox(:,1:2:end),[],1);
  box(2:2:end) = max(pbox(:,2:2:end),[],1);
  % for final sum (i.e. union) take minimum of all axis minima, and
  % maximum of all axis maxima
  if any(box == inf) | any(box == -inf)
    box = inf;
  end
  return;
 otherwise
  box = inf;
  return;
end

function [box] = bbEP(lat, EP)
%---- this section to be executed only for primitives ----
M = get_M(lat); % get matrix of lattice basis vectors
M = M*get_scale(lat); % scale basis matrix
latticeOffset = get_off(lat);
EP = EP - repmat(latticeOffset, size(EP,1), 1); % apply offset
box = zeros(1,2*size(M,2)); % box is row vector
for qq=1:size(M,2) 
  % loop over lattice basis vectors to find the interval for each
  NS = null( M(:, [ 1:qq-1 qq+1:end] )');
  % find nullspace of all of the basis vectors except the
  % current one. Since the matrix M is full-rank, the nullspace
  % found will be 1-D, and together with the current basis vector
  % will span a plane (or possibly a line, which is OK)
  % note: null() returns an orthonormal basis to the nullspace.
  %normV= norm(M(:,qq)); % not explicitly needed now
  for zz=1:size(EP,1)
    % loop over extreme points
    curpoint = EP(zz,:);
    PnsEP = dot(curpoint, NS) * NS; 
    % find the projection of the current extreme point onto the
    % nullspace. Simple formula because NS is length-1.
    if all(PnsEP==0)
      % save us from div by 0
      dist(zz) = 0; 
    else
      % candidate for interval is distance of current EP along
      % the basis vector.
      dist(zz) = (norm(PnsEP)^2) / dot(PnsEP,M(:,qq));
    end
  end
  % find minimum and maximum of candidate distance and round
  % to nearest integer away from 0 to determine interval.
  box(2*qq-1) = floor(min(dist));
  box(2*qq) = ceil(max(dist));
end

