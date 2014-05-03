function [rpconv]=times(a,b)
%       convolution of a process with an affine sequence (system)
%       rpconv=a.*b or [rpconv]=times(a,b)
global OPT_DATA;
if isa(b,'Process') & isa(a,'optSequence')
  rpconv=times(b,a);
elseif isa(a,'Process') & isa(b,'optSequence')
  rpconv=a;
  for n=1:length(a.ind)
    rpconv.sys{n}=a.sys{n}.*b;
  end;
else
  error('Illegal arguments to times(a,b).  One of a,b must be an optSequence');
end;