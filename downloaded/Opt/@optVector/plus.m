function [pvec]=plus(a,b)
% OPTVECTOR/PLUS  affine addition
% [paff]=plus(a,b)
% a and b should be of type optVector

if ~isa(a,'optVector') | ~isa(b,'optVector')
  %error('in a+b, both a and b must be of class optVector');
  pvec=plus(optVector(a),optVector(b));
else
  [Ma,Na]=size(a.h);
  [Mb,Nb]=size(b.h);            %get dimensions
  ax=a.xoff+1; bx=b.xoff+1;
  cx=min([ax bx]);
  Mc=max([ax+Ma bx+Mb])-cx;
  ai=ax-cx+1; bi=bx-cx+1;
  if(Na==1)   % a is a scalar, special case: replicate to b dim
    if issparse(a.h) & issparse(b.h)
      hc=spalloc(Mc,Nb,max([nnz(a.h) nnz(b.h)]));
    else
      hc = zeros(Mc, Nb);
    end
    hc(ai:ai+Ma-1,:)=repmat(full(a.h),1,Nb);
    % WARNING-- the 'full' conversion above is only bc of a stupid
    % MATLAB R13 bug with repmat
    % repmat will give an error if you try to replicate a 1x1
    % sparse matrix.
    % The result will still be sparse if hc was created sparse,
    % although it is not desirable to go back and forth too much.
    hc(bi:bi+Mb-1,:)=hc(bi:bi+Mb-1,:)+b.h;
  elseif(Nb==1) % b is a scalar
    if issparse(a.h) & issparse(b.h)
      hc=spalloc(Mc,Na,max([nnz(a.h) nnz(b.h)]));
    else
      hc = zeros(Mc, Na);
    end
    hc(ai:ai+Ma-1,:)=a.h;
    hc(bi:bi+Mb-1,:)=hc(bi:bi+Mb-1,:)+repmat(full(b.h),1,Na);
    % WARNING-- the 'full' conversion above is only bc of a stupid
    % MATLAB R13 bug with repmat
  else % both are not scalar
	  if(Ma==Mc) % since subsasgn is so slow, only use if needed
		  hc=a.h;
		  hc(bi:bi+Mb-1,:)=hc(bi:bi+Mb-1,:)+b.h;
	  elseif(Mb==Mc)
		  hc=b.h;
		  hc(ai:ai+Ma-1,:)=hc(ai:ai+Ma-1,:)+a.h;
	  else
		  if issparse(a.h) & issparse(b.h) % result is sparse
			  hc=spalloc(Mc,Na,max([nnz(a.h) nnz(b.h)]));
		  else
			  hc = zeros(Mc, Na);
		  end
		  hc(ai:ai+Ma-1,:)=a.h;
		  hc(bi:bi+Mb-1,:)=hc(bi:bi+Mb-1,:)+b.h;
	  end
  end    
  % assemble the sum
  pvec=optVector;   % empty optVector
  pvec.h=hc;
  if (a.pool==b.pool | b.pool==0)
    pvec.pool=a.pool;
  elseif (a.pool==0)
    pvec.pool=b.pool;
  else
    error('in a+b, a and b depend on different optimization spaces');
  end;
  pvec.xoff=cx-1;
end;
