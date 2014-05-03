function [P]=pwr(rp)
% NDPROCESS/PWR  [P]=pwr(rp)
% returns the power in process rp as an optimizable quadratic
% quantity of type optQuad.
global OPT_DATA;
pool=get_pool(rp);
if pool==0
  Q=sparse(0);         % assemble component kernels without offset
else
  % pre-allocate a "full" sparse matrix:
  % this wastes memory (really shouldn't use sparse at all),
  % but this can save a ton of time by avoiding reallocs when many
  % base processes are involved
  Nv=OPT_DATA.pools(pool);
  Q = zeros(Nv+1);  
  % kernel matrix is as big as all the optvars + 1 (for constants)
end;
for p=1:length(rp.ind)  %loop over processes
  h=get_h(rp.sys{p});
  [M,N]=size(h);
  xoff=get_xoff(rp.sys{p});
  x1=xoff+1; x2=x1+M-1;   % range of variables used by system 'h'
  locs = get_locs(rp.sys{p});   % time indices of system 'h'
  
  Coeff=OPT_DATA.ndprocs(rp.ind(p)).Coeff; % row vector of process coefficients
  freqs=OPT_DATA.ndprocs(rp.ind(p)).freqs; % matrix, (#bases)x(dim)
  param=OPT_DATA.ndprocs(rp.ind(p)).param;
  Nc=length(Coeff);
  basis=OPT_DATA.ndprocs(rp.ind(p)).basis;
  
  % compute autocorrelation function R at all necessary points
  % Locs contains all possible differences of two time indices
  lng = size(locs,1);
  Locs = repmat(locs, lng, 1);
  %bigMM = repmat([1:lng]', lng, 1);
  %bigLL = zeros(lng*lng,1);
  for qq = 0:lng-1
  %  bigLL(qq*lng+1:qq*lng+lng) = repmat(qq+1, lng, 1);
    Locs(qq*lng+1:qq*lng+lng,:) = ... 
	Locs(qq*lng+1:qq*lng+lng,:) - repmat(locs(qq+1,:), lng, 1);
  end
  [Ridx,Uidx,MPidx] = unique(Locs, 'rows');
  
  % inverse xform of psd:
  if ~iscell(basis)
    % if one basis function is given, find inverse in one shot
    Rn = feval([basis 'Time'],Ridx, param, freqs, Coeff);
  else
    % if individual basis functions are given, inverse transform
    % must be found by superposition.
    Rn = zeros(size(Ridx,1),1);
    for qq=1:length(basis)
      Rn = Rn + feval([basis{qq} 'Time'], Ridx, param{qq}, ...
		      freqs(qq,:), Coeff(qq) );
    end
  end
  
  tic; disp('st')
  if exist('pwrengine') ~= 3
    warning(['MEX file not present. Matlab routine used instead.'])
  end
  if (OPT_DATA.mexflag == 1) & (exist('pwrengine')==3)
    Qt = pwrengine(h, Rn(:), Ridx, locs);
  elseif OPT_DATA.mexflag == 177
    Qt = zeros(M,M);
    for zz=1:length(Rn)
      mplex = find(MPidx == zz);
      for qq=1:length(mplex)
	Qt = Qt + Rn(zz) * h(:,bigLL(mplex(qq))) * h(:,bigMM(mplex(qq)))' ;
      end
    end
  else
    % Krazy Konvolution
    Qt=zeros(M,M); % use a full matrix here for speed
    for ll=1:lng
      for mm=1:lng
	Qt = Qt + Rn(wherein(Ridx,-locs(ll,:)+locs(mm,:))) ...
		       * h(:,ll)*h(:,mm)' ;
	%Qt = Qt + real(conj(Rn(wherein(Ridx,-locs(ll,:)+locs(mm,:)))) ...
	%	       * h(:,ll)*h(:,mm)') ;
      end
    end
  end
  toc
  %plug into large Q
  Q(x1+1:x2+1,x1+1:x2+1)=Q(x1+1:x2+1,x1+1:x2+1)+Qt;
end;
if(max(size(Q)))==1
  P=full(Q);
else
  P=optQuad(Q,0,-1,pool);
end;
