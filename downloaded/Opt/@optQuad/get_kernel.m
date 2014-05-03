function Q=get_kernel(quad,format)
% optQuad/get_kernel kernel-matrix extraction function
% Q=get_kernel(quad,format)
% quadratic is of form 
% [1;x].'*[k c.'/2;c/2 H]*[1;x] = x.'*H*x + c.'*x + k
% format: 'sparse', 'full', 'purequad', 'affine', 'linear', or 'const'
% 'asis' returns nonzero portion as currently stored (default)
% 'full' returns the whole kernel, unfactored
% 'fullfact' returns the whole kernel, factored
% 'purequad' returns H, the purely quadratic kernel, unfactored
% 'purequadfact' returns H, the purely quadratic kernel, factored
% 'affine' returns [k;c],the affine part of the quadratic
% 'linear' returns c, the linear part of the quadratic
% 'const' returns k, the constant part

global OPT_DATA;
if nargin==1
	format='asis';
end;
switch format
case 'asis'
	Q=quad.kernel;
case 'fact'
	if quad.factored
		Q=quad.kernel;
	else
		Q=mfactor(quad.kernel);
	end;
case 'nofact'
	if quad.factored
		Q=real(quad.kernel*quad.kernel');
	else
		Q=quad.kernel;
	end;
case {'full','purequad'}
	M=OPT_DATA.pools(quad.pool);
	Q=sparse(M+1,M+1);
	R=size(quad.kernel,1);
	rows=2+quad.xoff:R+1+quad.xoff;
	if quad.factored
		Q(rows,rows)=real(quad.kernel*quad.kernel');
	else
		Q(rows,rows)=quad.kernel;
	end;
	if strcmp(format,'purequad')
		Q=Q(2:M+1,2:M+1);
	end;
case {'fullfact','purequadfact'}
	M=OPT_DATA.pools(quad.pool);
	R=size(quad.kernel,1);
	rows=2+quad.xoff:R+1+quad.xoff;
	if quad.factored
		Q=sparse(M+1,size(quad.kernel,2));
		Q(rows,:)=quad.kernel;
	else
		S=mfactor(quad.kernel);
		Q=sparse(M+1,size(S,2));
		Q(rows,:)=S;
	end;
	if strcmp(format,'purequadfact')
		Q=Q(2:M+1,:);
	end;	
case {'affine','linear'}
	M=OPT_DATA.pools(quad.pool);
	Q=sparse(M+1,1);
	if (quad.xoff==-1)
		R=size(quad.kernel,1);
		if quad.factored
			Q(2:R,1)=2*quad.kernel(2:R,:)*quad.kernel(1,:).';
			Q(1,1)=quad.kernel(1,:)*quad.kernel(1,:).';
		else
			Q(2:R,1)=2*quad.kernel(2:R,1);
			Q(1,1)=quad.kernel(1,1);
		end;
	end;
	if strcmp(format,'linear')
		Q=Q(2:M+1,:);
	end;
case 'const'
	if (quad.xoff==-1)
		if quad.factored
			Q=quad.kernel(1,:)*quad.kernel(1,:).';
		else
			Q=quad.kernel(1,1);
		end;
	else
		Q=0;
	end;
otherwise
	error('illegal format');
end;
