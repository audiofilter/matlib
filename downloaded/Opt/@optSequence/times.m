function [cseq]=times(a,b)
% OPTSEQUENCE/TIMES  sequence convolution
% [cseq]=times(a,b)
% one of a,b must not depend on the optimization variables

global OPT_DATA;

% we know at least one of a,b is of class optSequence, but not which
if isa(a,'optSequence') & isa(b,'optSequence')
  if isconst(b)
    if OPT_DATA.casebug
      ha=get_h(a.optvector).';
      hb=full(get_h(b.optvector)).';    %get the two h-matrices
    else
      ha=get_h(a.optVector).';
      hb=full(get_h(b.optVector)).';    %get the two h-matrices
    end;
    sparseFlag = issparse(ha);
    ha = full(ha);
    cn=a.noff+b.noff+2;
    if (size(ha,1)>1)
      hb(size(ha,1)+size(hb,1)-1,1)=0;  %hack filter to get convolution
    end;
    hc=fftfilt(ha,hb).';
    hc(find(abs(hc)<10*eps)) = 0;
    % get rid of numerical lint. '10*eps' can be replaced with an
    % appropriate threshhold.
    if sparseFlag & length(b) == 1
      hc=sparse(hc);
    end
% the above fails for ha a 1x1 scalar due to a bug in fftfilt.
%    hc=sparse(filter(ha,1,hb)).';  % this won't work anymore as is
    cseq=a;
    cseq=set_h(cseq,hc);
    cseq.noff=cn(1)-1;
  elseif isconst(a)
    cseq=times(b,a);
  else
    error('only one of the variables in a.*b can depend on opt vars');
  end;
else 
  warning('automatically casting argument to optSequence in times.m');
  cseq=times(optSequence(a),optSequence(b));
end;  
