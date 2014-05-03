function subvec=subsref(vec,s)
% optVector/subsref subscript operator
% returns subvector with indices s
%
% usage:  subvec=vec(s) or subvec=subsref(vec,s) 

switch s.type
  case '()'
    if length(s.subs)==1  
      subvec=optVector;
      subvec.pool=vec.pool;
      subvec.xoff=vec.xoff;
      % note - this needs better bounds checking!
		subvec.h=vec.h(:,s.subs{1});
    else
      error('illegal arguments to subsref()')
    end;
  otherwise
    error('illegal arguments to subsref()');
end;
