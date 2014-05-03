function [lconstr] = LinConstr(rel,vect)
% LinConstr class of optimization constraints
% 
% LinConstr members:
%   rel   : relational operator {<,==} of constraint
%   vect  : affine constraint (class optVector)
%
%   a canonical linear constraint is of the form
%   vect < 0  or  vect == 0
%   or
%    A*x < b  or   A*x == b
%   where A and b are the linear and constant terms of vect.h'
%
% class methods:
% constructor:
%   [constr] = LinConstr(rel,vect)
%   [constr] = LinConstr()
% insertion/extraction:
%   rel=get_rel(lconstr);
%   A=get_A(lconstr);
%   b=get_b(lconstr);

if nargin~=2
  error('LinConstr(rel,h) requires 2 input args');
else
  if isconst(vect)
    error('in the linear constraint a<b, both a and b cannot be constant');
  end;
  switch rel
    case '<'
      if any(any(abs(imag(get_h(vect)))>eps))
	warning('imaginary part of linear constraint will be ignored')
      end;
      lconstr.rel='<';
      lconstr.vect=real(vect);
    case '=='
      hr=real(get_h(vect)); hi=imag(get_h(vect));
      ihi=find(any(abs(hi)>eps)); ihr=find(any(abs(hr)>eps));
      h=[];
      if ~isempty(ihi)
	warning('complex == constraint converted to 2 real constraints');
      end;
      for n=1:length(ihr)
	h=[h hr(:,ihr(n))];
      end;
      for n=1:length(ihi)
	h=[h hi(:,ihi(n))];
      end;
      lconstr.rel='==';
      lconstr.vect=optVector(h,get_pool(vect),get_xoff(vect));
    otherwise
      error('illegal relational operator');
  end;
  lconstr=class(lconstr,'LinConstr');
end;