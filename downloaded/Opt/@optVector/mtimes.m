function [mopt]=mtimes(a,b)
% optVector/mtimes (AKA operator *): matrix-vector multiplication
% [mopt]=mtimes(a,b), mopt=a*b

warnstr=['Because the lengths match but not the dimensions,',char(13),...
		'I''m guessing you wanted elementwise multiplication.',char(13),...
		'The use of * for element-wise multiplication is deprecated.',...
	char(13),...
	'Please use .* for this purpose, and * for matrix multiplication.'];

if isa(a,'double')
	if (size(a,2)~=length(b) & length(a)~=1)
		if(length(a)==length(b))
			warning(warnstr);
			mopt=a.*b;
		else
			error('size mismatch in a*b');
		end;
	else
		mopt=b;
		mopt.h=b.h*a.';
	end;
elseif isa(b,'double')
	if (length(b)~=1 & length(a)~=1)
		warning(warnstr);
		mopt=a.*b;
	else
		mopt=a;
		mopt.h=a.h*b(:).';
	end;
else
	if (~isconst(a) & ~isconst(b))
		error('in a*b, only 1 term can depend on opt vars');
	elseif (length(a)~=1 & length(b)~=1)
		warning(warnstr);
		mopt=a.*b;
	elseif isconst(a)
		mopt=b;
		mopt.h=a.h*b.h;
	else
		mopt=a;
		mopt.h=a.h*b.h;
	end;
end;
