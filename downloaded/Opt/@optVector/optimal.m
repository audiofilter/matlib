function optvec=optimal(vec,soln)
% optVector/optimal  return optimal (constant) sequence
% optvec=optimal(opt,soln)
  
global OPT_DATA;

% new opt vars might have been added since soln was computed, so check
Ms=length(soln);
[M,N]=size(vec.h);
if Ms<(M+vec.xoff)     % new vars have been added and used by vec
  error(['the optVector depends on variables which were not declared when' ...
	 ' the solution vector was computed.']);
end;

if (vec.pool==0)    % vec is constant, so it is optimal
  optvec=vec;
else
  Me=OPT_DATA.pools(vec.pool)-Ms;
  if isa(soln, 'Solution')
    optvec = optVector([1; get_x(soln); zeros(Me,1)].' ...
		       * get_h(vec, 'full'));
  else
    optvec=optVector([1;soln;zeros(Me,1)].'*get_h(vec,'full'));
  end
end;

   % old code, remove when sure.
%[M,N]=size(vec.h);
%A=sparse(1+length(soln),N);
%A((1+vec.xoff+1):(M+vec.xoff+1),:)=vec.h;
