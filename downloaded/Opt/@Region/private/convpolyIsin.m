function [result,I] = convpolyIsin(reg, points)
% REGION/PRIVATE/CONVPOLYISIN  determine if points are in a convex polytope

global OPT_DATA;
version1 = logical(1); % change to taste

if version1
  %%%%%%%%%%%%%%%%%%%%%%%%%% ver1 - hyperplanes
  param = OPT_DATA.regions(reg.ind).param;
  if ~isfield(OPT_DATA.regions(reg.ind).param, 'A')
    doConvpolyLegwork(reg.ind, param); 
    % do preprocessing if first time called, then reload parameters
    param = OPT_DATA.regions(reg.ind).param;
  end

  map = zeros(size(points,1),1);

  for qq = 1:size(points,1)
    OKflag = logical(1);
    for zz = 1:length(param.b)
      if (param.A(:,zz)' * points(qq,:)' < param.b(zz))
	OKflag = logical(0);
	break; % if it violates even one inequality, we're done
      end
    end
    if OKflag
      map(qq) = 1;
    end
  end


else
  %%%%%%%%%%%%%%%%%%%%%%%%%% ver2 - LP
  % note: if this is better, adjust doc in Region.m
  if ~isfield(OPT_DATA.regions(reg.ind).param, 'K')
    % do preprocessing if first time called
    initConvpoly(reg.ind);
  end
  param = OPT_DATA.regions(reg.ind).param;
  hullv = param.hullv;
  pars.fid = 0; K.l = size(hullv,1); K.f = 0;
  A = [ (param.points(hullv,:))'; ones(1,size(hullv,1))] ;
  for qq = 1:size(points,1)
    [devnull, devnull, info] = sedumi(A, [points(qq,:) 1]', 0, K,pars );
    if info.pinf == 0
      map(qq) = 1;
    end
  end
  
end

if OPT_DATA.regions(reg.ind).complement
  map = not(map);
end
I = find(map);
result = points(I,:);
