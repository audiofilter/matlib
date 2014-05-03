function [rpconv]=times(a,b)
%       convolution of a process with an affine sequence (system)
%       rpconv=a.*b or [rpconv]=times(a,b)
global OPT_DATA;
if isa(a,'optSequence')
    a=optGenSequence(a);
end;
if isa(b,'optSequence')
    b=optGenSequence(b);
end;
if isa(b,'CTProcess') & isa(a,'optGenSequence')
  rpconv=times(b,a);
elseif isa(a,'CTProcess') & isa(b,'optGenSequence')
  rpconv=a;
  for n=1:length(a.ind)
    rpconv.sys{n}=a.sys{n}.*b;
  end;
else
  error('Illegal arguments to times(a,b).  One of a,b must be an optGenSequence');
end;