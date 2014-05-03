function [P]=pwr(rp)
% CTPROCESS/PWR  [P]=pwr(rp)
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
    Q = zeros(Nv+1);  % kernel matrix is as big as all the optvars + 1 (for constants)
end;
for p=1:length(rp.ind)  %loop over processes
    h=get_h(rp.sys{p});
    [M,N]=size(h);
    xoff=get_xoff(rp.sys{p});
    x1=xoff+1; x2=x1+M-1;   % range of variables used by system 'h'
    locs = get_locs(rp.sys{p});   % time indices of system 'h'
    
    Coeff=OPT_DATA.ctprocs(rp.ind(p)).Coeff; % row vector of process coefficients
    freqs=OPT_DATA.ctprocs(rp.ind(p)).freqs; % row vector
    scale=OPT_DATA.ctprocs(rp.ind(p)).scale; % scaling of basis fcn
    Nc=length(Coeff);
    basis=OPT_DATA.ctprocs(rp.ind(p)).basis; % now, Box or Triangle
    
    % compute autocorrelation function R at all necessary points
    % Locs contains all possible differences of two time indices
    Locs = repmat(locs', length(locs),1) - repmat(locs, 1, length(locs));
    dlocs = sort(Locs(:));
    Ridx = dlocs(find(abs(diff([dlocs(:);inf]))>10*eps));   % get rid of duplicates
    Ridx = unique(dlocs);
    % Ridx is column vector
    % inverse xform of psd: Rn(locs)= Basis(scale, locs) * <Coeff,exp(j*2*pi*freqs*locs)>
    Rn = zeros(length(Ridx),1);
    for qq = 1:length(Ridx)
        Rn(qq) = Coeff * feval([basis 'Time'],Ridx(qq),freqs,scale) ;
    end;

    if OPT_DATA.mexflag == 1
        Qt = pwrengine(h, Rn(:), Ridx(:), locs(:));
    else
        % Krazy Konvolution
        Qt=zeros(M,M); % use a full matrix here for speed
        for ll=1:length(locs)
            for mm=1:length(locs)
                Qt = Qt + real(conj(Rn(find(Ridx==-locs(ll)+locs(mm)))) *h(:,ll)*h(:,mm)') ;
            end
        end
    end
    %plug into large Q
    Q(x1+1:x2+1,x1+1:x2+1)=Q(x1+1:x2+1,x1+1:x2+1)+Qt;
end;
if(max(size(Q)))==1
    P=full(Q);
else
    P=optQuad(Q,0,-1,pool);
end;
