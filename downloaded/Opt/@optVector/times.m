function [mopt]=times(a,b)
% optVector/times (AKA operator .*):  element-wise multiplication
% [mopt]=times(a,b), mopt=a.*b

% we know at least one of a,b is of class optVector, but not which
if ~isa(a,'optVector') | ~isa(b,'optVector')
  mopt=optVector(a).*optVector(b);
else
  if (~isconst(a) & ~isconst(b))
    error('in a*b, only 1 term can depend on opt vars');
  elseif isconst(b)
    mopt=a;
    if (length(a)==1 | length(b)==1)
      mopt.h=mopt.h*b.h;
    else
      mopt.h=mopt.h.*repmat(b.h,size(mopt.h,1),1);
    end;
  else
    mopt=b.*a;
  end;
end;
