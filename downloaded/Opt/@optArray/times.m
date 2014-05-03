function [cseq]=times(a,b)
% OPTARRAY/TIMES  sequence convolution
% [cseq]=times(a,b)
% [cseq]=a.*b
% one of a,b must not depend on the optimization variables

if ~isa(a,'optArray') | ~isa(b,'optArray')
  error('in a.*b, both must be of type optArray')
end

if size(a.locs,2) ~= size(b.locs,2)
    error('sequences must be of the same dimension.');
end

global OPT_DATA;
%disp('hi there')
if isa(a,'optArray') & isa(b,'optArray')
    if isconst(b)
        ha=get_h(a);
        hb=full(get_h(b));
        [Ma,Na]=size(ha);
        [Mb,Nb]=size(hb);  
        
        % conv sum exists at (a.locs \times b.locs) locations
        Locs = repmat(a.locs, Nb, 1);
        for qq=0:Nb-1
            Locs(qq*Na+1:qq*Na+Na,:) = Locs(qq*Na+1:qq*Na+Na,:) ...
                + repmat(b.locs(qq+1,:), Na ,1);
        end
        Locs = sortrows(Locs);
        infs = inf.*ones(1,size(a.locs,2));
        newlocs = Locs(find(sum(abs(diff([Locs;infs])), 2) > 10*eps),:);  % desired locs

	if issparse(ha) & Nb == 1
	  hc = spalloc(Ma, size(newlocs,1), size(newlocs,1)*Nb);
	else
	  hc = zeros(Ma, size(newlocs,1));
	end
        for qq=1:size(newlocs,1)
            shiflocs = -b.locs+repmat(newlocs(qq,:), size(b.locs,1) , 1);
            aidx = wherein(a.locs, shiflocs); % find matching time indices
            htmp = repmat(hb(:,find(~isnan(aidx))) , Ma, 1) ...
                .* ha(:,aidx(find(~isnan(aidx))));
            hc(:,qq) = sum(htmp,2); % convolution sum
        end
        cseq=a;
        cseq=set_h(cseq,hc);
        cseq.locs = newlocs;
    elseif isconst(a)
        cseq=times(b,a);
    else
        error('only one of the variables in a.*b can depend on opt vars');
    end;
else 
    warning('automatically casting argument to optArray in times.m');j
    cseq=times(optArray(a),optArray(b));
end;  
