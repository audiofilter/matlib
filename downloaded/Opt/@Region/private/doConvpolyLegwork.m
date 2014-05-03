function doConvpolyLegwork(ind, param);
% calculations for convpoly region

global OPT_DATA;

% take the convex hull to eliminate extra points
% note that there is a bug in Matlab R12 which causes a bad result
% for 3 points in 2-D. The function does not exist in R11 (v5.3).
% Works on R12.1 and above.
% Hence the bugfix as follows:
if (param.dim == 2) & (size(param.points,1) == 3)
  K = [1 2; 2 3; 3 1];
else
  K = convhulln(param.points);
end
% determine halfspaces
% A is composed of column vectors a
% there are as many a's (and entries in b) as the polytope has facets
A = zeros(param.dim, size(K,1));
b = zeros(size(K,1),1);
for qq=1:size(K,1)
  D = param.points(K(qq,:),:); % create basis matrix for determinants
  for zz=1:param.dim
    DD = D; DD(:,zz) = ones(param.dim,1); % replace with column of 1's
    A(zz,qq) = det(DD); % for hyperplane a'x = b
  end
  b(qq) = det(D);
  % now check for direction of inequality
  % by testing other points in the set to determine
  % which side of the current hyperplane they occupy.
  % Since this test is quite sensitive to numerical error, all the
  % points are tested, and the majority determines the direction of
  % the inequality.
  % the number of points tested could be reduced if a better test
  % is found.
  ltt = 0; gtt = 0;
  for zz=1:size(param.points,1)
    if any(zz == K(qq,:))
      % don't check points which are in the current facet of the polytope
      ;
    else 
      if A(:,qq)' * param.points(zz,:)' < b(qq)
	ltt = ltt + 1;
      else
	gtt = gtt + 1;
      end
    end
  end
  if ltt >= gtt
    % if enough are less than, flip the halfspace
    A(:,qq) = -A(:,qq);
    b(qq) = -b(qq);
  end
end

% copy into global OPT_DATA
OPT_DATA.regions(ind).param.A = A;
OPT_DATA.regions(ind).param.b = b;
OPT_DATA.regions(ind).param.points = param.points(unique(K(:)),:);
% only store extreme points
